# 🌡️ ThermalGuard — Industrial Thermal Anomaly Detection Rover

> **ROI Rank: #6** | Difficulty: Intermediate | Est. build time: 2–3 days (MVP)

---

## 🧠 What Problem It Solves

Electrical fires and equipment failures are often preceded by localised heat build-up that goes undetected for hours. ThermalGuard is an autonomous rover that **patrols a predefined area**, uses an 8×8 thermal camera array to scan for hot-spots above a configurable threshold, and logs timestamped incident reports to the cloud. It replaces expensive handheld thermal guns and manual inspection routines in server rooms, workshops, and light industrial facilities.

**Commercial angle:** Predictive maintenance and industrial safety are high-margin consulting domains. A rover that proves thermal anomaly detection in a demo video is a compelling pitch to data centres, manufacturing plants, and facilities management companies.

---

## 🛠️ Core Skills You'll Learn

| Category | Specifics |
|----------|-----------|
| Thermal sensing | AMG8833 8×8 IR array via I2C, temperature matrix processing, bilinear interpolation |
| Embedded | ESP32 (Arduino C++ or MicroPython), I2C bus management, interrupt-driven motor control |
| Autonomous navigation | Wall-following / waypoint patrol algorithm, ultrasonic obstacle avoidance |
| Image processing | Python NumPy + Matplotlib (or OpenCV) heatmap generation |
| Cloud | AWS IoT Core MQTT, S3 (heatmap images), DynamoDB (incident log), SNS (alerts) |
| Alerting | Threshold-based anomaly detection, configurable via MQTT retained message |

---

## 🧱 Tech Stack

### Hardware
| Component | Purpose | Approx. Cost |
|-----------|---------|-------------|
| ESP32 development board | WiFi MCU + I2C host | $5–8 |
| AMG8833 thermal camera (Adafruit or clone) | 8×8 IR temperature array | $25–$35 |
| HC-SR04 ultrasonic sensors (×2, front + side) | Obstacle avoidance + wall follow | $2 each |
| 2WD smart car chassis + L298N | Locomotion | $13–$18 |
| Servo (optional, for panning AMG8833) | Wider thermal scan angle | $2 |
| 18650 battery + charger | Portable power | $5 |

**Total hardware budget: ~$55–$75**

### Software
- **Firmware:** Arduino C++ (ESP32): I2C AMG8833 driver, motor PWM, MQTT publish
- **Cloud functions:** Python Lambda: receive thermal matrix → generate heatmap PNG → upload to S3 → check threshold → fire SNS alert
- **Storage:** S3 (heatmap images), DynamoDB (incident log: timestamp, location, max_temp, image_url)
- **Dashboard:** Simple HTML/JS page served from S3 — polls DynamoDB via API Gateway for latest incidents
- **IaC:** Terraform (IoT Core, Lambda, S3, DynamoDB, SNS)

---

## 🚀 Build Scope

### MVP (2–3 days)
- [ ] Flash ESP32 with AMG8833 reader: read 8×8 matrix every 2 seconds
- [ ] Publish thermal matrix as JSON to AWS IoT Core: `thermalguard/rover01/thermal`
- [ ] Lambda function: deserialise matrix, find max temperature pixel, if max > threshold (e.g. 40°C):
  - Generate heatmap PNG (NumPy + Matplotlib colormap)
  - Upload PNG to S3
  - Write incident record to DynamoDB
  - Send SNS alert with max temp + image link
- [ ] Rover drives in a fixed square patrol loop (no obstacle avoidance yet)

### Upgrade Path
- [ ] Add ultrasonic sensors: wall-following algorithm (keep right wall at constant distance)
- [ ] Patrol map: define waypoints in config; rover visits each in sequence, pauses to scan
- [ ] Pan servo: sweep AMG8833 left/right at each waypoint for wider coverage
- [ ] Bilinear interpolation: upsample 8×8 → 32×32 for smoother heatmap images
- [ ] Historical trending: Lambda stores rolling average per grid cell; alert only if temp is > 2 standard deviations above baseline (reduces false positives dramatically)
- [ ] Raspberry Pi upgrade: replace ESP32 with Pi Zero 2W for local heatmap rendering + SD card logging (works offline)
- [ ] Digital twin: stream heatmap data to a simple 2D floor plan overlay in the web dashboard

---

## 💰 Monetization Potential

### Freelance Use Cases
- "Set up automated thermal inspection for our server room" — $2,000–$8,000
- Predictive maintenance consulting for light industrial clients
- Custom patrol robot builds for facilities management — recurring maintenance contracts

### Product Ideas
- **Kit:** "ThermalGuard DIY Kit" — all hardware + pre-flashed ESP32 + tutorial — $75–$120
- **Course:** "Industrial IoT: Build a Thermal Anomaly Detection System" — $79–$149
- **SaaS:** Multi-site thermal monitoring dashboard with configurable thresholds, incident history, PDF reports — $25–$99/month

---

## 📦 GitHub Portfolio Angle

**Why employers/clients care:**
- Industrial / predictive maintenance domain — high commercial value
- Full pipeline: hardware sensor → embedded firmware → cloud processing → alerting → dashboard
- Thermal camera work is niche (most hobbyists stick to basic sensors)
- Demonstrates safety-critical thinking (threshold config, false positive reduction)

### Suggested Repo Structure
```
06-thermalguard/
├── README.md
├── firmware/
│   ├── platformio.ini
│   └── src/
│       ├── main.cpp             ← AMG8833 read + MQTT publish + motor control
│       ├── thermal_sensor.h
│       └── motor_controller.h
├── cloud/
│   ├── lambda/
│   │   └── thermal_processor.py ← heatmap gen + S3 + DynamoDB + SNS
│   └── infra/
│       ├── main.tf
│       └── variables.tf
├── dashboard/
│   └── index.html               ← S3-hosted incident viewer
├── docs/
│   ├── wiring_diagram.png
│   ├── patrol_algorithm.md
│   └── sample_heatmap.png
├── tests/
│   └── test_thermal_processor.py
└── .github/
    └── workflows/
        └── deploy.yml
```

---

## 🎯 Difficulty Level

**Intermediate** — The AMG8833 I2C driver is well supported by Adafruit libraries. The hardest part is the patrol navigation algorithm (wall-following or waypoint logic). The cloud side maps directly to your existing AWS skills.

---

## ⚡ Make It Stand Out

**"Baseline learning mode"** — During the first 24 hours of operation, instead of alerting, the rover builds a per-pixel temperature baseline (rolling mean + standard deviation for each cell in the thermal grid). After the learning period, alerts fire only when a cell exceeds `mean + 3σ` — the statistical process control standard used in real industrial monitoring systems. This one feature transforms a toy project into something that could be pitched to a facilities manager with a straight face.
