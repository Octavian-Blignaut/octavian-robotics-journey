# 🔒 SmartSentry — AI-Powered Security Camera Bot

> **ROI Rank: #1** | Difficulty: Intermediate | Est. build time: 2–3 days (MVP)

---

## 🧠 What Problem It Solves

Off-the-shelf security cameras are dumb — they record everything and flood you with false alerts.  
SmartSentry uses on-device AI to detect **only humans**, optionally recognise **known faces**, and fires **instant push notifications** only when it matters. It's a standalone product prototype that solves a real pain point for homeowners and small businesses.

**Commercial angle:** Security-as-a-Service is a $50B+ market. A smart, affordable, open-source alternative to Ring/Nest is a compelling freelance and product pitch.

---

## 🛠️ Core Skills You'll Learn

| Category | Specifics |
|----------|-----------|
| Embedded | ESP32-CAM firmware (Arduino/ESP-IDF), camera streaming over HTTP |
| Protocols | MQTT over TLS, HTTPS webhooks, WebSockets |
| Computer Vision | AWS Rekognition API, face collection management, confidence thresholds |
| Cloud | AWS IoT Core (MQTT broker), SNS push notifications, S3 image storage, Lambda triggers |
| Security | TLS certificate provisioning, IAM least-privilege roles, secrets in environment variables |

---

## 🧱 Tech Stack

### Hardware
| Component | Purpose | Approx. Cost |
|-----------|---------|-------------|
| ESP32-CAM (AI Thinker) | Camera + WiFi + MCU | $5–8 |
| 5V power supply / USB-C breakout | Power | $2 |
| PIR sensor (HC-SR501) | Wake-on-motion to save power | $1 |
| LED ring (optional) | Night vision / status indicator | $3 |

**Total hardware budget: ~$15**

### Software
- **Firmware:** Arduino framework (C++), `esp32-camera` library
- **On-device inference (optional upgrade):** TensorFlow Lite Micro person detector
- **Cloud functions:** AWS Lambda (Python 3.12)
- **Notifications:** AWS SNS → mobile push / email / SMS
- **Storage:** AWS S3 (event snapshots), DynamoDB (alert log)
- **IaC:** Terraform or AWS CDK for reproducible infra

### Cloud Architecture
```
ESP32-CAM
  │  (JPEG snapshot over MQTT/TLS)
  ▼
AWS IoT Core  ──►  Lambda  ──►  Rekognition (DetectLabels / SearchFaces)
                     │
              ┌──────┴──────┐
              ▼             ▼
           S3 bucket    DynamoDB        ──►  SNS  ──►  📱 Push / SMS
          (snapshots)   (alert log)
```

---

## 🚀 Build Scope

### MVP (1–3 days)
- [ ] Flash ESP32-CAM with streaming firmware
- [ ] Connect to WiFi and publish JPEG frames to AWS IoT Core via MQTT
- [ ] Lambda function calls `DetectLabels` — if "Person" confidence > 80%, save to S3 and send SNS email
- [ ] Basic web page served from S3 shows last 10 alert snapshots

### Upgrade Path
- [ ] Add PIR sensor: only wake camera and publish when motion detected (10× battery life improvement)
- [ ] Enrol known faces into Rekognition Face Collection; only alert on *unknown* faces
- [ ] Stream live MJPEG feed through a WebSocket proxy (API Gateway + Lambda)
- [ ] Add a second ESP32-CAM for multi-zone coverage; route both through the same IoT Core topic namespace
- [ ] Edge inference: run MobileNet person detector on-device, upload only frames that pass local filter (reduces AWS cost ~90%)
- [ ] OTA firmware updates via AWS IoT Jobs

---

## 💰 Monetization Potential

### Freelance Use Cases
- "Set up smart surveillance with cloud alerts" — command $500–$2,000 per installation for small businesses
- IoT consulting: design + deploy MQTT-based sensor networks

### Product Ideas
- **Kit:** Sell a pre-flashed ESP32-CAM kit with a tutorial for ~$25–$40 (Tindie, Etsy, own website)
- **Course:** "Build Your Own AI Security Camera" — $49–$99 on Gumroad / Udemy
- **SaaS:** Hosted SmartSentry backend (multi-camera, cloud storage, mobile app) — $5–$15/month subscription

---

## 📦 GitHub Portfolio Angle

**Why employers/clients care:**
- Demonstrates end-to-end IoT architecture (hardware → MQTT → cloud → notification)
- Shows AWS service integration (IoT Core, Rekognition, Lambda, S3, SNS)
- Real security domain with commercial relevance
- Proves you can ship working hardware + software together

### Suggested Repo Structure
```
01-smartsentry/
├── README.md
├── firmware/
│   ├── platformio.ini
│   └── src/
│       └── main.cpp          ← ESP32-CAM streaming + MQTT publish
├── cloud/
│   ├── lambda/
│   │   └── alert_handler.py  ← Rekognition + S3 + SNS logic
│   └── infra/
│       ├── main.tf            ← Terraform: IoT Core, Lambda, S3, SNS
│       └── variables.tf
├── dashboard/
│   └── index.html             ← S3-hosted alert viewer
├── docs/
│   ├── architecture.png
│   └── wiring_diagram.png
└── .github/
    └── workflows/
        └── deploy_lambda.yml  ← CI: lint + deploy Lambda on push
```

---

## 🎯 Difficulty Level

**Intermediate** — You need to be comfortable with WiFi networking, basic C++, and AWS IAM. Your existing cloud/DevOps background makes the AWS side very approachable.

---

## ⚡ Make It Stand Out

**"Intrusion heatmap"** — After 30 days of operation, generate a top-down floor plan overlay showing *where* in the frame motion/people were detected most often. Publish it as a weekly PDF report via SES. No other DIY security camera does this. It's the kind of insight that justifies a subscription tier.
