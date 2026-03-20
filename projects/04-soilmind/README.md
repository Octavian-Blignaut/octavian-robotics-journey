# 🌱 SoilMind — Autonomous Agricultural Monitoring Bot

> **ROI Rank: #4** | Difficulty: Beginner+ | Est. build time: 1–2 days (MVP)

---

## 🧠 What Problem It Solves

Over-watering and under-watering are the top two causes of crop loss in small-scale agriculture and home growing. SoilMind is a wheeled rover that autonomously surveys a garden, reads soil moisture, temperature, and humidity at multiple points, logs everything to the cloud, and triggers a water pump when conditions require it — replacing guesswork with data.

**Commercial angle:** Precision agriculture is a $10B+ market. Smart irrigation alone saves 30–50% water. This project is immediately sellable as a kit or consulting deliverable to urban farms, greenhouses, and smart-home enthusiasts.

---

## 🛠️ Core Skills You'll Learn

| Category | Specifics |
|----------|-----------|
| Embedded | ESP32 MicroPython / Arduino C++, deep-sleep power management |
| Sensors | Capacitive soil moisture sensor, DHT22 (temp/humidity), BMP280 (pressure) |
| Protocols | MQTT (sensor → cloud), I2C (sensor bus), UART debugging |
| Cloud/IoT | AWS IoT Core or MQTT broker, InfluxDB Cloud (time-series), Grafana dashboard |
| Actuation | Relay module for water pump control |
| Navigation (upgrade) | Ultrasonic obstacle avoidance, waypoint-based path planning |

---

## 🧱 Tech Stack

### Hardware
| Component | Purpose | Approx. Cost |
|-----------|---------|-------------|
| ESP32 development board | WiFi MCU | $5–8 |
| Capacitive soil moisture sensor (×2–4) | Soil water content | $2–3 each |
| DHT22 | Air temperature + humidity | $3 |
| BMP280 | Barometric pressure (weather prediction) | $2 |
| 5V mini water pump + relay module | Automated irrigation | $5 |
| 2WD smart car chassis kit | Mobility | $10–$15 |
| L298N motor driver | Motor PWM control | $3 |
| 18650 Li-ion battery + holder | Portable power | $5 |

**Total hardware budget: ~$40–$55**

### Software
- **Firmware:** MicroPython on ESP32 (easy iteration) or Arduino C++ (performance)
- **MQTT broker:** AWS IoT Core (free tier covers this easily) or local Mosquitto
- **Time-series DB:** InfluxDB Cloud (free tier) or self-hosted on a $5 VPS
- **Dashboard:** Grafana (free, connects to InfluxDB natively)
- **Alerting:** Grafana alert rules → email/Slack/Telegram when moisture drops below threshold
- **OTA:** ESP32 OTA update via Arduino IDE or custom MQTT trigger

---

## 🚀 Build Scope

### MVP (1–2 days)
- [ ] Stationary (no wheels yet): ESP32 reads DHT22 + soil moisture every 60 seconds
- [ ] Publish readings to AWS IoT Core via MQTT: `sensors/soilmind/node01`
- [ ] IoT Core rule writes data to InfluxDB Cloud (HTTP action)
- [ ] Grafana dashboard: live soil moisture %, temperature, humidity time-series
- [ ] Alert: Grafana fires a Telegram message when moisture < 30%

### Upgrade Path
- [ ] Add wheels + motor driver: rover drives to 3 predefined waypoints and reads sensors at each
- [ ] Ultrasonic sensors: basic obstacle avoidance between waypoints
- [ ] Relay control: MQTT command from Grafana/app triggers water pump for N seconds
- [ ] BMP280: add barometric trend; predict rain and suppress irrigation if pressure dropping
- [ ] Solar panel + MPPT charger: make it fully off-grid
- [ ] Multi-node mesh: add 3–5 stationary ESP32 nodes in different zones; rover acts as mobile base station
- [ ] Mobile app: simple Flutter app to view dashboard and send pump commands

---

## 💰 Monetization Potential

### Freelance Use Cases
- Smart greenhouse automation consulting — $1,000–$5,000 projects
- IoT sensor network design for small farms
- "Wire up our existing irrigation system with smart controls" — tangible, recurring maintenance contracts

### Product Ideas
- **Kit:** "SoilMind Starter Kit" — ESP32 + sensors + tutorial — $35–$60 on Tindie or own store
- **Course:** "Build an IoT Garden Monitor in a Weekend" — $29–$49 on Gumroad (high volume, low price)
- **SaaS:** SoilMind Cloud — multi-site dashboard, weather API integration, predictive watering schedule — $5–$15/month

---

## 📦 GitHub Portfolio Angle

**Why employers/clients care:**
- End-to-end IoT pipeline: sensor → MQTT → cloud → visualisation → actuation
- Real-world domain with measurable impact (water savings, crop yield)
- Clean, reproducible infra (IaC + Grafana-as-code dashboard JSON)
- Beginner-friendly entry point that scales to a serious product

### Suggested Repo Structure
```
04-soilmind/
├── README.md
├── firmware/
│   ├── micropython/
│   │   └── main.py             ← MicroPython ESP32 sensor + MQTT
│   └── arduino/
│       ├── platformio.ini
│       └── src/main.cpp        ← Arduino C++ alternative
├── cloud/
│   ├── iot_rule.json           ← AWS IoT Core rule (MQTT → InfluxDB)
│   └── infra/
│       └── main.tf             ← Terraform: IoT Core, IAM
├── dashboard/
│   └── grafana_dashboard.json  ← Export/import Grafana dashboard
├── docs/
│   ├── wiring_diagram.png
│   └── sensor_calibration.md
└── .github/
    └── workflows/
        └── validate_firmware.yml
```

---

## 🎯 Difficulty Level

**Beginner+** — MQTT and ESP32 basics are well documented. MicroPython makes the firmware very approachable. The cloud pipeline (IoT Core → InfluxDB → Grafana) is the most complex part and directly leverages your existing cloud skills.

---

## ⚡ Make It Stand Out

**"Predictive watering with a 3-day weather forecast"** — Call the Open-Meteo API (free, no key needed) from a Lambda function every morning. If rain is forecast in the next 24 hours, automatically suspend irrigation for that day. Log the "skipped watering" events with estimated litres saved. After a month you have a real water-saving report — a killer feature for any sustainability-minded buyer.
