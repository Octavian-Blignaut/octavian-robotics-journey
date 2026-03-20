# 🚁 FleetPilot — Cloud-Connected Robot Fleet Dashboard

> **ROI Rank: #2** | Difficulty: Advanced | Est. build time: 3–5 days (MVP)

---

## 🧠 What Problem It Solves

Managing more than one robot means juggling multiple SSH sessions, ad-hoc scripts, and zero visibility into fleet health. FleetPilot gives you a **single pane of glass** — a real-time web dashboard to monitor status, stream telemetry, send commands, and trigger OTA updates across a fleet of ROS 2 robots through AWS IoT Core.

**Commercial angle:** Industrial robotics deployments (warehouses, agriculture, inspection) *all* need fleet management. This project maps directly to paid consulting work and product opportunities in a high-growth market.

---

## 🛠️ Core Skills You'll Learn

| Category | Specifics |
|----------|-----------|
| Robot middleware | ROS 2 (Humble) nodes, topics, services, actions, `ros2cli` |
| Cloud IoT | AWS IoT Core (MQTT), IoT Device Shadow, IoT Jobs (OTA) |
| Backend | Python FastAPI WebSocket bridge, JWT auth |
| Frontend | React + Recharts real-time telemetry charts, Leaflet.js GPS map |
| DevOps | Docker multi-stage builds, GitHub Actions CI/CD, AWS ECR/ECS |
| Networking | MQTT over TLS, WebSockets, REST |

---

## 🧱 Tech Stack

### Hardware (per robot)
| Component | Purpose | Approx. Cost |
|-----------|---------|-------------|
| Raspberry Pi 4 (4 GB) | ROS 2 compute node | $55 |
| Differential drive chassis kit | Locomotion | $20–$40 |
| L298N motor driver | PWM motor control | $3 |
| MPU-6050 (IMU) | Orientation / odometry | $2 |
| GPS module (NEO-6M) | Location tracking | $8 |
| USB webcam | Visual feed | $15 |

**Per-robot hardware budget: ~$100–$120**  
*You can simulate additional robots in Docker for zero extra cost.*

### Software
- **Robot:** ROS 2 Humble (Python nodes), `aws-iot-sdk-python-v2` bridge node
- **Cloud:** AWS IoT Core, IoT Device Shadow, IoT Jobs
- **Backend:** Python FastAPI + WebSockets (bridges MQTT ↔ browser)
- **Frontend:** React 18, Recharts, Leaflet.js, shadcn/ui
- **IaC:** AWS CDK (TypeScript)
- **CI/CD:** GitHub Actions → Docker build → ECR → ECS Fargate

### Architecture
```
ROS 2 Robot (Pi 4)
  ros_topics → aws_bridge_node
       │  (MQTT/TLS)
       ▼
AWS IoT Core
  Device Shadow  ──►  DynamoDB (history)
  IoT Jobs       ──►  Lambda  ──►  S3 (OTA bundles)
       │
       ▼ (WebSocket)
  FastAPI Server (ECS Fargate)
       │
       ▼ (HTTPS + WS)
  React Dashboard  ──►  Operator's Browser
```

---

## 🚀 Build Scope

### MVP (3–5 days)
- [ ] One ROS 2 robot (or simulated in Docker) publishing `/odom` and `/battery` topics
- [ ] AWS bridge node: subscribe to ROS topics, publish to IoT Core via MQTT
- [ ] FastAPI server: subscribe to IoT Core, forward to browser via WebSocket
- [ ] React dashboard: live battery %, velocity chart, connection status per robot

### Upgrade Path
- [ ] IoT Device Shadow: persist last-known state; dashboard shows robots that are offline
- [ ] GPS map: render each robot's position on a Leaflet.js map in real time
- [ ] Command channel: send `cmd_vel` (move forward/stop) from the dashboard
- [ ] IoT Jobs: trigger OTA firmware/software update from dashboard with progress tracking
- [ ] Multi-robot simulation: spawn 5 robot instances in Docker Compose for stress-testing
- [ ] Role-based access: admin can send commands, viewer can only watch
- [ ] Mobile app: React Native wrapper with push alerts for robot faults

---

## 💰 Monetization Potential

### Freelance Use Cases
- "Build us a fleet management system for our warehouse robots" — $5,000–$20,000 projects
- ROS 2 consulting (rare skill) — $80–$150/hour
- AWS IoT architecture design — $100–$200/hour

### Product Ideas
- **SaaS:** FleetPilot Cloud — $49–$199/month per fleet (up to N robots) with hosted dashboard, OTA, and alerting
- **Course:** "ROS 2 + AWS IoT Fleet Management from Zero" — $99–$199 on Udemy
- **White-label:** License the dashboard to robotics startups that don't want to build infra

---

## 📦 GitHub Portfolio Angle

**Why employers/clients care:**
- ROS 2 is the industry standard — few developers know it *and* AWS
- Demonstrates full-stack robotics: firmware, middleware, cloud, frontend
- Production-grade: Docker, CI/CD, IaC, JWT auth
- Directly applicable to warehouse automation, drone fleets, AGV systems

### Suggested Repo Structure
```
02-fleetpilot/
├── README.md
├── robot/
│   ├── ros2_ws/
│   │   └── src/
│   │       ├── fleetpilot_robot/     ← ROS 2 Python package
│   │       │   ├── aws_bridge_node.py
│   │       │   └── motor_controller_node.py
│   │       └── CMakeLists.txt
│   └── Dockerfile
├── backend/
│   ├── main.py                       ← FastAPI + WebSocket server
│   ├── requirements.txt
│   └── Dockerfile
├── frontend/
│   ├── src/
│   │   ├── App.tsx
│   │   ├── components/
│   │   │   ├── RobotCard.tsx
│   │   │   ├── TelemetryChart.tsx
│   │   │   └── FleetMap.tsx
│   │   └── hooks/useWebSocket.ts
│   └── package.json
├── infra/
│   └── cdk/
│       ├── lib/fleetpilot-stack.ts   ← IoT Core, ECS, DynamoDB, S3
│       └── bin/app.ts
├── docker-compose.yml                ← Local dev: robot sim + backend + frontend
└── .github/
    └── workflows/
        ├── ci.yml
        └── deploy.yml
```

---

## 🎯 Difficulty Level

**Advanced** — Requires comfort with ROS 2 concepts, AWS IoT services, and React. Your DevOps background handles the CI/CD and IaC with ease; the ROS 2 learning curve is the main investment.

---

## ⚡ Make It Stand Out

**"Anomaly-triggered snapshots"** — Train a lightweight LSTM model (15 minutes of training data) to detect abnormal telemetry patterns (e.g., motor current spike before a stall). When the model fires, the robot automatically captures a photo + sensor dump and attaches it to the IoT alert. Predictive maintenance on a $100 robot. Nobody else is doing this at the hobbyist level.
