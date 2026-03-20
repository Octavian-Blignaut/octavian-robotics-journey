# 🗣️ EdgeVoice — Offline Voice-Controlled Robot

> **ROI Rank: #5** | Difficulty: Intermediate | Est. build time: 2–3 days (MVP)

---

## 🧠 What Problem It Solves

Cloud-dependent voice assistants (Alexa, Google Home) fail in poor-connectivity environments — factories, warehouses, rural sites, or anywhere privacy matters. EdgeVoice processes **all speech on-device** using OpenAI Whisper, needs no internet for core operation, and gives operators a natural-language interface to control a robot in noisy, real-world environments.

**Commercial angle:** Edge AI for voice interfaces is in high demand in industrial settings where cloud connectivity is unreliable or where recording audio on cloud servers is a compliance risk (GDPR, HIPAA, ITAR).

---

## 🛠️ Core Skills You'll Learn

| Category | Specifics |
|----------|-----------|
| Edge AI | OpenAI Whisper (tiny/base model) on-device inference, quantisation, Faster-Whisper |
| Audio | PyAudio, Sounddevice, voice activity detection (Silero VAD), noise filtering |
| NLP | Intent extraction with a local rule-based parser or local Ollama LLM |
| Robot control | Differential drive via GPIO/PWM, speed ramping, non-blocking command queue |
| Python | asyncio, multiprocessing for parallel audio capture + inference |
| Optimisation | Benchmark inference latency; understand fp16 vs int8 trade-offs on ARM |

---

## 🧱 Tech Stack

### Hardware
| Component | Purpose | Approx. Cost |
|-----------|---------|-------------|
| Raspberry Pi 5 (4 GB) | Edge inference compute | $60 |
| USB microphone (or ReSpeaker 2-Mic Hat) | High-quality audio capture | $5–$25 |
| 2WD robot chassis | Mobility | $10–$15 |
| L298N motor driver | PWM control | $3 |
| Small USB speaker | Text-to-speech feedback | $8 |
| 5V 3A USB-C power bank | Portable power | $15 |

**Total hardware budget: ~$100–$125**  
*Raspberry Pi 4 works too — inference is ~2× slower but still real-time with Whisper tiny.*

### Software
- **STT:** Faster-Whisper (CTranslate2 optimised) — `tiny.en` model, ~200 ms latency on Pi 5
- **VAD:** Silero VAD (PyTorch, detects speech start/end, avoids processing silence)
- **Intent parsing:** Rule-based keyword extractor (MVP) → local Ollama `phi-3-mini` (upgrade)
- **TTS feedback:** piper-tts (offline, fast, high-quality voices)
- **Robot control:** RPi.GPIO + custom motor controller class
- **Optional cloud sync:** Log commands + execution results to AWS DynamoDB for analysis

---

## 🚀 Build Scope

### MVP (2–3 days)
- [ ] Capture audio with Silero VAD (only process when speech detected)
- [ ] Transcribe with Faster-Whisper `tiny.en`; benchmark latency
- [ ] Parse 10 commands: "forward", "back", "left", "right", "stop", "faster", "slower", "spin", "status", "shutdown"
- [ ] Execute motor commands via L298N GPIO
- [ ] Speak confirmation back via piper-tts: "Moving forward"

### Upgrade Path
- [ ] Wake word: add Porcupine wake-word detection ("Hey Sentry") so the robot only listens after activation
- [ ] Upgrade intent parser to local Ollama `phi-3-mini`: handle free-form commands like "Go to the door and wait"
- [ ] Waypoint memory: "Go to charging dock" triggers a saved GPS/odometry waypoint
- [ ] Multi-language: Whisper natively supports 99 languages — add a language-select config
- [ ] Noise robustness: add ReSpeaker array + beamforming for use in loud factory environments
- [ ] OTA config: push new command vocabulary via MQTT without reflashing
- [ ] Vision integration: combine with a camera so "pick up the red block" works end-to-end

---

## 💰 Monetization Potential

### Freelance Use Cases
- "Build us a voice interface for our warehouse robots" — $3,000–$12,000
- Privacy-first voice control for healthcare/industrial clients — premium rates due to compliance value
- Edge AI consulting: helping companies move cloud inference workloads to on-device — $100–$150/hour

### Product Ideas
- **Kit:** "EdgeVoice Starter" — Pi + mic + chassis + pre-loaded SD card + tutorial — $80–$150
- **Course:** "Offline AI Voice Control for Robots and IoT" — $79–$149
- **Product:** Standalone EdgeVoice module (custom PCB, mic array, speaker) that clips onto any robot — licensing play

---

## 📦 GitHub Portfolio Angle

**Why employers/clients care:**
- On-device AI is a hot hiring area (TinyML, embedded AI, edge inference)
- Whisper + VAD + TTS is a complete, production-relevant voice pipeline
- Privacy-first angle differentiates from cloud voice projects immediately
- Directly applicable to industrial HMI, assistive technology, home automation

### Suggested Repo Structure
```
05-edgevoice/
├── README.md
├── src/
│   ├── audio/
│   │   ├── capture.py          ← sounddevice async capture
│   │   └── vad.py              ← Silero VAD wrapper
│   ├── stt/
│   │   └── transcriber.py      ← Faster-Whisper inference
│   ├── nlu/
│   │   ├── rule_parser.py      ← keyword intent extractor (MVP)
│   │   └── llm_parser.py       ← Ollama phi-3-mini (upgrade)
│   ├── tts/
│   │   └── speaker.py          ← piper-tts wrapper
│   ├── robot/
│   │   └── motor_controller.py ← L298N GPIO driver
│   └── main.py                 ← async pipeline orchestrator
├── config/
│   └── commands.yaml           ← command vocabulary + motor mappings
├── models/
│   └── .gitkeep                ← Whisper + VAD models downloaded at runtime
├── benchmarks/
│   └── latency_test.py         ← measure end-to-end voice → action latency
├── tests/
│   ├── test_rule_parser.py
│   └── test_motor_controller.py
├── docs/
│   └── wiring_diagram.png
└── requirements.txt
```

---

## 🎯 Difficulty Level

**Intermediate** — The Python audio pipeline has real gotchas (buffer sizes, async timing, VAD tuning). Faster-Whisper installation on ARM is well documented. Motor control is straightforward. The hardest part is making it *feel responsive* — sub-300ms end-to-end latency requires profiling and tuning.

---

## ⚡ Make It Stand Out

**"Confidence-gated fallback"** — If Whisper's transcription confidence is below 0.7, instead of executing a wrong command, the robot says "I didn't catch that — did you mean forward or back?" and waits for confirmation. This is exactly the kind of safety mechanism that real industrial systems require and that sets your project apart from "I wired a mic to a Pi" demos. Log all low-confidence events to DynamoDB to continuously improve your command vocabulary over time.
