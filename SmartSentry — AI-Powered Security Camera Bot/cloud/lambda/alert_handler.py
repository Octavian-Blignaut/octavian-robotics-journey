"""
alert_handler.py — AWS Lambda (Python 3.12)

Triggered by an AWS IoT Core topic rule when an ESP32-CAM publishes a JPEG
snapshot to:  smartsentry/camera/snapshot

Flow
────
1. Decode the binary JPEG payload forwarded by IoT Core.
2. Call Rekognition DetectLabels.
3. If "Person" confidence exceeds PERSON_CONFIDENCE threshold:
   a. Save the snapshot to S3.
   b. Write an alert record to DynamoDB.
   c. Publish an SNS notification (email / SMS / push).

Environment variables (set in Terraform / Lambda console)
──────────────────────────────────────────────────────────
  S3_BUCKET          — bucket that stores alert snapshots
  DYNAMODB_TABLE     — DynamoDB table name for the alert log
  SNS_TOPIC_ARN      — SNS topic ARN for outbound notifications
  PERSON_CONFIDENCE  — minimum Rekognition confidence to trigger alert (default: 80)
"""

import base64
import json
import logging
import os
import time
import uuid

import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# ── Config from environment variables ────────────────────────────────────────
S3_BUCKET         = os.environ["S3_BUCKET"]
DYNAMODB_TABLE    = os.environ["DYNAMODB_TABLE"]
SNS_TOPIC_ARN     = os.environ["SNS_TOPIC_ARN"]
PERSON_CONFIDENCE = float(os.environ.get("PERSON_CONFIDENCE", "80"))

# ── AWS clients (initialised once per Lambda container) ──────────────────────
_region      = os.environ.get("AWS_REGION", "us-east-1")
rekognition  = boto3.client("rekognition", region_name=_region)
s3           = boto3.client("s3")
dynamodb     = boto3.resource("dynamodb")
sns          = boto3.client("sns")
table        = dynamodb.Table(DYNAMODB_TABLE)


def lambda_handler(event: dict, context) -> dict:
    """
    Entry point.

    IoT Core topic rule passes the raw JPEG bytes as a Base64-encoded string
    under the key ``image``.  If the rule is configured with a SQL statement
    that selects the raw payload, the key may be named differently — adjust
    below to match your rule's SELECT clause.
    """
    logger.info("Event keys: %s", list(event.keys()))

    # IoT Core encodes binary payloads as Base64 when forwarding to Lambda
    raw = event.get("image") or event.get("payload")
    if raw is None:
        logger.error("No image payload in event: %s", json.dumps(event))
        return {"statusCode": 400, "body": "Missing image payload"}

    image_bytes: bytes = base64.b64decode(raw) if isinstance(raw, str) else raw

    # ── 1. Detect labels with Rekognition ────────────────────────────────────
    rek_response = rekognition.detect_labels(
        Image={"Bytes": image_bytes},
        MaxLabels=10,
        MinConfidence=50,
    )
    labels = {lbl["Name"]: lbl["Confidence"] for lbl in rek_response["Labels"]}
    logger.info("Rekognition labels: %s", labels)

    person_confidence = labels.get("Person", 0.0)
    if person_confidence < PERSON_CONFIDENCE:
        logger.info(
            "No alert — person confidence %.1f < threshold %.1f",
            person_confidence,
            PERSON_CONFIDENCE,
        )
        return {"statusCode": 200, "body": "No person detected"}

    # ── 2. Save snapshot to S3 ───────────────────────────────────────────────
    timestamp = int(time.time())
    event_id  = str(uuid.uuid4())
    s3_key    = f"alerts/{timestamp}-{event_id}.jpg"

    s3.put_object(
        Bucket=S3_BUCKET,
        Key=s3_key,
        Body=image_bytes,
        ContentType="image/jpeg",
    )
    s3_url = f"https://{S3_BUCKET}.s3.amazonaws.com/{s3_key}"
    logger.info("Snapshot saved: %s", s3_url)

    # ── 3. Log to DynamoDB ───────────────────────────────────────────────────
    table.put_item(
        Item={
            "event_id":          event_id,
            "timestamp":         timestamp,
            "person_confidence": str(round(person_confidence, 2)),
            "s3_key":            s3_key,
            "all_labels":        json.dumps(labels),
        }
    )

    # ── 4. Send SNS alert ────────────────────────────────────────────────────
    sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject="🚨 SmartSentry — Person Detected",
        Message=(
            f"Person detected with {person_confidence:.1f}% confidence.\n\n"
            f"Snapshot: {s3_url}\n"
            f"Event ID: {event_id}\n"
            f"All labels: {json.dumps(labels, indent=2)}"
        ),
    )
    logger.info("SNS alert sent for event %s", event_id)

    return {"statusCode": 200, "body": "Alert sent", "event_id": event_id}
