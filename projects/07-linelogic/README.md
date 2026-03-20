# 📦 LineLogic — Smart Warehouse Line-Following Robot

> **ROI Rank: #7** | Difficulty: Beginner+ | Est. build time: 1–2 days (MVP)

---

## 🧠 What Problem It Solves

Line-following robots are the backbone of Automated Guided Vehicles (AGVs) in warehouses and factories. LineLogic goes beyond the classic "follow the tape" demo by adding **PID speed control**, **MQTT telemetry**, a **live web dashboard**, and **cloud-stored run analytics** — turning a beginner project into a portfolio piece that shows you understand the real engineering behind industrial AGVs.

**Commercial angle:** AGV and AMR (Autonomous Mobile Robot) systems are replacing human-driven forklifts and carts in warehouses at scale. Engineers who understand the fundamentals command premium rates in logistics automation.

---

## 🛠️ Core Skills You'll Learn

| Category | Specifics |
|----------|-----------|
| Control systems | PID controller theory + implementation, tuning Kp/Ki/Kd empirically |
| Embedded | ESP32 Arduino C++: IR sensor array reading, encoder-based speed feedback |
| Protocols | MQTT (telemetry publish), WebSockets (live dashboard) |
| Cloud | AWS IoT Core, DynamoDB (run logs), S3 (static dashboard) |
| Data analysis | Python: parse run logs, compute lap times, plot speed profiles |
| Web | Vanilla JS + Chart.js live telemetry dashboard |

---

## 🧱 Tech Stack

### Hardware
| Component | Purpose | Approx. Cost |
|-----------|---------|-------------|
| ESP32 development board | WiFi MCU + PID compute | $5–8 |
| TCRT5000 IR sensor array (5-channel or 8-channel) | Line detection | $3–5 |
| 2WD chassis + DC motors | Drive system | $10–15 |
| L298N motor driver | PWM H-bridge | $3 |
| Rotary encoders (×2, optional) | Wheel speed feedback for PID | $2 each |
| 18650 battery + holder | Power | $4 |

**Total hardware budget: ~$30–$40**

### Software
- **Firmware:** Arduino C++ (ESP32): IR array → PID loop → PWM output + MQTT telemetry publish at 10 Hz
- **MQTT broker:** AWS IoT Core
- **Cloud ingest:** IoT Core rule → Lambda → DynamoDB (per-run lap data)
- **Dashboard:** Vanilla JS + Chart.js served from S3: live speed/error/PID output charts
- **Analysis:** Python Jupyter notebook: compare PID tuning runs, plot speed vs. error profiles
- **IaC:** Terraform for IoT Core + DynamoDB + S3 + Lambda

---

## 🚀 Build Scope

### MVP (1–2 days)
- [ ] Lay a black tape track on light flooring (~1m × 0.5m oval)
- [ ] Firmware: read 5-channel IR array, compute weighted centroid error, run PID loop, set L/R motor PWM
- [ ] Publish telemetry to AWS IoT Core every 100 ms: `{error, p_term, i_term, d_term, left_pwm, right_pwm, timestamp}`
- [ ] IoT Core rule: write to DynamoDB table partitioned by `run_id`
- [ ] S3 static dashboard: fetch last 60 seconds of telemetry, render live Chart.js graphs

### Upgrade Path
- [ ] Add rotary encoders: close the speed loop (velocity PID + outer position PID = cascaded control)
- [ ] Intersection detection: recognise T/X junctions from IR pattern; implement simple decision logic (go straight, turn left/right based on MQTT command)
- [ ] Route planning: encode a map of junctions; follow a commanded route (A → B → charging dock)
- [ ] OTA PID tuning: publish new Kp/Ki/Kd values via MQTT retained message; robot picks them up without reflashing
- [ ] Computer vision upgrade: replace IR array with a Pi camera + OpenCV for coloured lane following
- [ ] Fleet sim: run 3 LineLogic bots on the same track with collision avoidance via MQTT coordination
- [ ] Digital twin: render the robot's position on a track diagram in the dashboard using encoder odometry

---

## 💰 Monetization Potential

### Freelance Use Cases
- AGV system design consulting — understanding the fundamentals is the first step
- "Build a prototype AGV for our warehouse demo" — $1,000–$5,000
- Robotics education workshops — teach PID and embedded systems to engineering students

### Product Ideas
- **Kit:** "LineLogic Educational AGV Kit" — chassis + sensors + pre-loaded firmware + Grafana dashboard — $40–$70
- **Course:** "PID Control + IoT Telemetry: Build a Real Robot" — $39–$79 (volume play, great intro-level course)
- **Workshop:** Run a 1-day "Build Your First AGV" workshop — $200–$500 per attendee

---

## 📦 GitHub Portfolio Angle

**Why employers/clients care:**
- PID control is foundational to all motion control systems (robots, drones, CNC, HVAC)
- MQTT telemetry + cloud logging shows production-grade thinking, not just a hardware hack
- Clean, tunable firmware with OTA config shows software engineering discipline
- Great entry point that explicitly leads to larger AGV/AMR work

### Suggested Repo Structure
```
07-linelogic/
├── README.md
├── firmware/
│   ├── platformio.ini
│   └── src/
│       ├── main.cpp             ← PID loop + IR read + MQTT publish
│       ├── pid_controller.h     ← reusable PID class
│       ├── ir_sensor_array.h    ← sensor abstraction
│       └── motor_driver.h       ← L298N PWM abstraction
├── cloud/
│   ├── lambda/
│   │   └── ingest_telemetry.py  ← IoT rule → DynamoDB writer
│   └── infra/
│       └── main.tf
├── dashboard/
│   ├── index.html               ← live Chart.js telemetry viewer
│   └── analysis.ipynb           ← Jupyter: PID tuning analysis
├── docs/
│   ├── wiring_diagram.png
│   ├── pid_tuning_guide.md
│   └── track_layout.png
├── tests/
│   └── test_pid_controller.py   ← unit tests for PID math
└── .github/
    └── workflows/
        └── deploy_lambda.yml
```

---

## 🎯 Difficulty Level

**Beginner+** — IR sensor reading and basic motor control are very approachable. The PID tuning requires patience and iteration but is well documented. The cloud pipeline is the same pattern used in SmartSentry and ThermalGuard, so it gets easier with each project.

---

## ⚡ Make It Stand Out

**"Autonomous PID auto-tuner"** — Implement a simplified Ziegler-Nichols step-response auto-tuning routine: on first boot (or when a MQTT command fires), the robot runs a controlled test, measures the step response of the motor system, and calculates near-optimal Kp/Ki/Kd values automatically. Log the auto-tuned parameters to DynamoDB. This is the kind of self-calibrating behaviour that industrial robotics companies pay a lot for — and it shows you understand control theory at a level well beyond "I copied the PID formula from Wikipedia".
