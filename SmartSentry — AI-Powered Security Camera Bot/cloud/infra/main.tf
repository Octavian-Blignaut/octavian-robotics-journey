# ── Provider ─────────────────────────────────────────────────────────────────
terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  prefix = "${var.project_name}-${var.environment}"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ── S3 — alert snapshot storage ──────────────────────────────────────────────
resource "aws_s3_bucket" "alerts" {
  bucket        = "${local.prefix}-alerts"
  force_destroy = false
  tags          = local.common_tags
}

resource "aws_s3_bucket_public_access_block" "alerts" {
  bucket                  = aws_s3_bucket.alerts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ── DynamoDB — alert log ──────────────────────────────────────────────────────
resource "aws_dynamodb_table" "alert_log" {
  name         = "${local.prefix}-alert-log"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "event_id"

  attribute {
    name = "event_id"
    type = "S"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  tags = local.common_tags
}

# ── SNS — outbound notifications ──────────────────────────────────────────────
resource "aws_sns_topic" "alerts" {
  name = "${local.prefix}-alerts"
  tags = local.common_tags
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# ── IAM — Lambda execution role ───────────────────────────────────────────────
data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name               = "${local.prefix}-lambda-exec"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
  tags               = local.common_tags
}

data "aws_iam_policy_document" "lambda_permissions" {
  statement {
    sid       = "Logs"
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }
  statement {
    sid       = "S3Write"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.alerts.arn}/*"]
  }
  statement {
    sid       = "DynamoWrite"
    actions   = ["dynamodb:PutItem"]
    resources = [aws_dynamodb_table.alert_log.arn]
  }
  statement {
    sid       = "SNSPublish"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.alerts.arn]
  }
  statement {
    sid     = "Rekognition"
    actions = ["rekognition:DetectLabels", "rekognition:SearchFacesByImage"]
    # Rekognition does not support resource-level ARNs for these actions
    resources = ["*"] # tighten with a condition on aws:RequestedRegion if needed
  }
}

resource "aws_iam_role_policy" "lambda_permissions" {
  role   = aws_iam_role.lambda_exec.id
  policy = data.aws_iam_policy_document.lambda_permissions.json
}

# ── Lambda — alert handler ────────────────────────────────────────────────────
resource "aws_lambda_function" "alert_handler" {
  function_name    = "${local.prefix}-alert-handler"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "alert_handler.lambda_handler"
  runtime          = "python3.12"
  filename         = "${path.module}/../../lambda_package.zip"
  source_code_hash = filebase64sha256("${path.module}/../../lambda_package.zip")
  timeout          = 30
  memory_size      = 256

  environment {
    variables = {
      S3_BUCKET      = aws_s3_bucket.alerts.bucket
      DYNAMODB_TABLE = aws_dynamodb_table.alert_log.name
      SNS_TOPIC_ARN  = aws_sns_topic.alerts.arn
    }
  }

  tags = local.common_tags
}

# ── IoT Core — topic rule → Lambda ───────────────────────────────────────────
resource "aws_iot_topic_rule" "snapshot_ingest" {
  name        = "${replace(local.prefix, "-", "_")}_snapshot_ingest"
  description = "Route ESP32-CAM snapshots to the alert Lambda"
  enabled     = true
  sql         = "SELECT * FROM 'smartsentry/camera/snapshot'"
  sql_version = "2016-03-23"

  lambda {
    function_arn = aws_lambda_function.alert_handler.arn
  }

  tags = local.common_tags
}

resource "aws_lambda_permission" "iot_invoke" {
  statement_id  = "AllowIoTCoreInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.alert_handler.function_name
  principal     = "iot.amazonaws.com"
  source_arn    = aws_iot_topic_rule.snapshot_ingest.arn
}

# ── Outputs ───────────────────────────────────────────────────────────────────
output "s3_bucket_name" {
  description = "S3 bucket storing alert snapshots"
  value       = aws_s3_bucket.alerts.bucket
}

output "lambda_function_name" {
  description = "Alert handler Lambda function name"
  value       = aws_lambda_function.alert_handler.function_name
}

output "sns_topic_arn" {
  description = "SNS topic ARN for alert notifications"
  value       = aws_sns_topic.alerts.arn
}
