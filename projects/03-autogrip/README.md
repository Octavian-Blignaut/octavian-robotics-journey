# 🦾 AutoGrip — Computer Vision Pick-and-Place Arm

> **ROI Rank: #3** | Difficulty: Intermediate | Est. build time: 2–3 days (MVP)

---

## 🧠 What Problem It Solves

Manual sorting and pick-and-place is one of the most common automation targets in manufacturing and logistics. AutoGrip is a desktop robotic arm that uses a camera + OpenCV to **detect, classify, and sort objects** by colour or shape — the same fundamental task used in real factory lines, but built for under $60.

**Commercial angle:** Industrial vision-guided robotics is a multi-billion-dollar market. Demonstrating this skill set (even on a desktop scale) is a direct ticket into automation consulting, systems integration, and robotics product development.

---

## 🛠️ Core Skills You'll Learn

| Category | Specifics |
|----------|-----------|
| Computer vision | OpenCV contour detection, colour segmentation (HSV), perspective transform, calibration |
| Kinematics | Inverse kinematics for a 4-DOF arm, coordinate frame transforms (camera → robot) |
| Servo control | PWM via PCA9685 I2C servo driver, smooth trajectory interpolation |
| Python | asyncio pipeline: capture → detect → plan → execute |
| Hardware | I2C bus, Raspberry Pi GPIO, camera module |

---

## 🧱 Tech Stack

### Hardware
| Component | Purpose | Approx. Cost |
|-----------|---------|-------------|
| Raspberry Pi 4 (2 GB) | Vision + control compute | $35–$45 |
| 4-DOF desktop robot arm kit (MeArm or clone) | Physical manipulator | $15–$25 |
| PCA9685 16-channel PWM driver | Servo control via I2C | $5 |
| Raspberry Pi Camera Module v2 (or USB webcam) | Object detection | $15–$25 |
| SG90 micro servos (×4, usually included in kit) | Joint actuation | included |

**Total hardware budget: ~$60–$90**

### Software
- **Vision:** Python 3 + OpenCV 4, NumPy
- **Kinematics:** custom inverse kinematics module (analytical, 4-DOF planar)
- **Servo driver:** `adafruit-circuitpython-pca9685`
- **Optional ML upgrade:** TensorFlow Lite (`efficientdet_lite`) for shape/object classification
- **API layer (optional):** FastAPI REST endpoint to trigger pick-and-place remotely
- **Logging:** CSV + optional InfluxDB for cycle-time analytics

---

## 🚀 Build Scope

### MVP (2–3 days)
- [ ] Mount camera above workspace with clear overhead view
- [ ] OpenCV pipeline: capture frame → HSV threshold → find contours → compute centroid
- [ ] Map pixel centroid to robot coordinate frame (homography with 4-point calibration)
- [ ] Inverse kinematics function: (x, y, z) → (θ1, θ2, θ3, θ4)
- [ ] Pick-place loop: move to object, close gripper, move to sort bin, open gripper
- [ ] Two bins: red objects → left bin, blue objects → right bin

### Upgrade Path
- [ ] Replace HSV colour filter with TensorFlow Lite model — classify 10+ object categories
- [ ] Add depth estimation: use stereo camera or time-of-flight sensor for true 3D picking
- [ ] Trajectory smoothing: cubic spline interpolation between waypoints (eliminates jerky motion)
- [ ] FastAPI endpoint: `POST /pick?x=100&y=200` for remote command
- [ ] Web UI: live camera feed + pick history dashboard
- [ ] ROS 2 port: wrap nodes as ROS 2 nodes (`MoveIt 2` integration path)
- [ ] Conveyor belt: add a small belt driven by a stepper motor for continuous sorting demo

---

## 💰 Monetization Potential

### Freelance Use Cases
- Vision-guided robotics consulting for small manufacturers — $3,000–$15,000 projects
- "Automate our manual sorting station" — tangible ROI pitch
- Robotics integration with existing PLCs — $100–$150/hour

### Product Ideas
- **Kit:** "Build Your Own Vision Robot Arm" kit with pre-calibrated arm + tutorial — $60–$120 on Tindie
- **Course:** "Computer Vision Robotics: From Pixels to Picks" — $79–$149
- **Demo product:** Commission a custom pick-and-place station for a local business as a showcase project

---

## 📦 GitHub Portfolio Angle

**Why employers/clients care:**
- Computer vision + physical actuation is the "holy grail" demo for robotics roles
- Shows mathematical depth (IK, coordinate transforms, homography)
- Directly applicable to industrial automation, medical device assembly, e-commerce fulfilment
- Clean Python architecture with separation of concerns (vision / kinematics / control)

### Suggested Repo Structure
```
03-autogrip/
├── README.md
├── src/
│   ├── vision/
│   │   ├── detector.py         ← OpenCV colour/shape detection
│   │   ├── calibration.py      ← homography camera-to-robot mapping
│   │   └── tflite_classifier.py ← (upgrade) TFLite object classifier
│   ├── kinematics/
│   │   └── inverse_kinematics.py ← analytical 4-DOF IK solver
│   ├── control/
│   │   ├── servo_driver.py     ← PCA9685 PWM wrapper
│   │   └── arm_controller.py   ← high-level move/pick/place API
│   ├── api/
│   │   └── server.py           ← FastAPI REST endpoint (optional)
│   └── main.py                 ← orchestration loop
├── config/
│   └── arm_config.yaml         ← servo limits, link lengths, HSV ranges
├── tests/
│   ├── test_ik.py
│   └── test_detector.py
├── docs/
│   ├── wiring_diagram.png
│   └── calibration_guide.md
└── requirements.txt
```

---

## 🎯 Difficulty Level

**Intermediate** — The IK math is the trickiest part; a 4-DOF planar arm has a closed-form solution that is well documented. OpenCV colour detection is beginner-friendly. Your Python skills make this very achievable in a weekend.

---

## ⚡ Make It Stand Out

**"Teach by demonstration"** — Add a "record mode": move the arm by hand while the Pi records joint angles at 10 Hz. Press a button to play back the recorded trajectory. This is a simplified version of the programming technique used on real industrial cobots (collaborative robots) from Universal Robots and FANUC — and it makes for an *extremely* impressive demo video.
