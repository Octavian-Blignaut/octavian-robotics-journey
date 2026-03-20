# 🦾 Octavian's Robotics Journey

> My engineering diary + portfolio of small, high-impact robotics projects — blending hardware, embedded systems, AI, and cloud automation. Every project is designed to build **real, employable skills** and create **monetizable products**.

---

## 🗺️ Project Roadmap

Projects are ranked by **ROI** (career value + monetization potential):

| # | Project | Difficulty | Stack Highlights | ROI |
|---|---------|-----------|-----------------|-----|
| 1 | [🔒 SmartSentry](#1--smartsentry) | Intermediate | ESP32-CAM, AWS Rekognition, MQTT | ⭐⭐⭐⭐⭐ |
| 2 | [🚁 FleetPilot](#2--fleetpilot) | Advanced | ROS 2, AWS IoT Core, React dashboard | ⭐⭐⭐⭐⭐ |
| 3 | [🦾 AutoGrip](#3--autogrip) | Intermediate | Raspberry Pi 4, OpenCV, servo arm | ⭐⭐⭐⭐ |
| 4 | [🌱 SoilMind](#4--soilmind) | Beginner+ | ESP32, DHT22/soil sensors, InfluxDB | ⭐⭐⭐⭐ |
| 5 | [🗣️ EdgeVoice](#5-️-edgevoice) | Intermediate | Raspberry Pi 5, Whisper AI, offline NLP | ⭐⭐⭐⭐ |
| 6 | [🌡️ ThermalGuard](#6-️-thermalguard) | Intermediate | ESP32, AMG8833, autonomous rover | ⭐⭐⭐ |
| 7 | [📦 LineLogic](#7--linelogic) | Beginner+ | ESP32, IR array, MQTT, cloud logging | ⭐⭐⭐ |

---

## Project Summaries

### 1 🔒 SmartSentry
**AI-Powered Security Camera Bot** — detects intruders, recognises faces, and fires real-time alerts to your phone via AWS SNS.
�� [`projects/01-smartsentry/`](projects/01-smartsentry/README.md)

---

### 2 🚁 FleetPilot
**Cloud-Connected Robot Fleet Dashboard** — manage, monitor, and command multiple robots from a single web UI backed by AWS IoT Core and ROS 2.
📁 [`projects/02-fleetpilot/`](projects/02-fleetpilot/README.md)

---

### 3 🦾 AutoGrip
**Computer Vision Pick-and-Place Arm** — a desktop robotic arm that detects objects with OpenCV and sorts them by colour/shape automatically.
📁 [`projects/03-autogrip/`](projects/03-autogrip/README.md)

---

### 4 🌱 SoilMind
**Autonomous Agricultural Monitoring Bot** — a wheeled rover that reads soil moisture, temperature, and humidity, logs data to the cloud, and waters plants on schedule.
📁 [`projects/04-soilmind/`](projects/04-soilmind/README.md)

---

### 5 🗣️ EdgeVoice
**Offline Voice-Controlled Robot** — voice commands processed entirely on-device with OpenAI Whisper; no internet required for core operation.
📁 [`projects/05-edgevoice/`](projects/05-edgevoice/README.md)

---

### 6 🌡️ ThermalGuard
**Industrial Thermal Anomaly Detection Rover** — an autonomous rover that patrols a defined area, flags hot-spots with a thermal camera array, and logs incidents to the cloud.
📁 [`projects/06-thermalguard/`](projects/06-thermalguard/README.md)

---

### 7 📦 LineLogic
**Smart Warehouse Line-Following Robot** — a PID-controlled line follower with MQTT telemetry, a live web dashboard, and cloud-stored run analytics.
📁 [`projects/07-linelogic/`](projects/07-linelogic/README.md)

---

## 🛠️ Skills Being Built

| Domain | Technologies |
|--------|-------------|
| Embedded firmware | C/C++, MicroPython, Arduino framework, ESP-IDF |
| Single-board computers | Raspberry Pi OS, GPIO, I2C, SPI, UART |
| Robot middleware | ROS 2 (Humble), roslaunch, topics, services, actions |
| Computer vision | OpenCV, TensorFlow Lite, YOLO, AWS Rekognition |
| Cloud & IoT | AWS IoT Core, MQTT, InfluxDB, Grafana, SNS/SQS |
| CI/CD for firmware | GitHub Actions, PlatformIO CI, OTA updates |
| AI at the edge | Whisper, Edge Impulse, TensorFlow Lite Micro |

---

## 📂 Repository Structure

```
octavian-robotics-journey/
├── README.md                  ← you are here
└── projects/
    ├── 01-smartsentry/        ← AI security camera bot
    ├── 02-fleetpilot/         ← cloud robot fleet dashboard
    ├── 03-autogrip/           ← CV pick-and-place arm
    ├── 04-soilmind/           ← ag monitoring rover
    ├── 05-edgevoice/          ← offline voice-controlled robot
    ├── 06-thermalguard/       ← thermal anomaly rover
    └── 07-linelogic/          ← smart warehouse line follower
```

---

*Building in public — follow along as I go from cloud engineer to robotics founder 🚀*
