/**
 * main.cpp — SmartSentry ESP32-CAM firmware
 *
 * Captures a JPEG frame and publishes it to AWS IoT Core over MQTT/TLS every
 * CAPTURE_INTERVAL_MS milliseconds (or on a PIR interrupt — see upgrade path
 * comments below).
 *
 * Secrets (WiFi SSID/password, AWS IoT certs) live in secrets.h which is
 * listed in .gitignore.  Copy secrets.h.example → secrets.h and fill it in.
 */

#include <Arduino.h>
#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include "esp_camera.h"
#include "secrets.h"  // ← never commit this file

// ── Camera pin map (AI Thinker ESP32-CAM) ───────────────────────────────────
#define PWDN_GPIO_NUM  32
#define RESET_GPIO_NUM -1
#define XCLK_GPIO_NUM   0
#define SIOD_GPIO_NUM  26
#define SIOC_GPIO_NUM  27
#define Y9_GPIO_NUM    35
#define Y8_GPIO_NUM    34
#define Y7_GPIO_NUM    39
#define Y6_GPIO_NUM    36
#define Y5_GPIO_NUM    21
#define Y4_GPIO_NUM    19
#define Y3_GPIO_NUM    18
#define Y2_GPIO_NUM     5
#define VSYNC_GPIO_NUM 25
#define HREF_GPIO_NUM  23
#define PCLK_GPIO_NUM  22

// ── MQTT topics ──────────────────────────────────────────────────────────────
#define MQTT_TOPIC_IMAGE  "smartsentry/camera/snapshot"
#define MQTT_TOPIC_STATUS "smartsentry/camera/status"
#define DEVICE_ID         "esp32cam-01"

// ── Capture interval (ms) — replace with PIR interrupt for upgrade path ──────
#define CAPTURE_INTERVAL_MS 5000

WiFiClientSecure net;
PubSubClient     mqttClient(net);

// ── Camera initialisation ────────────────────────────────────────────────────
static bool initCamera() {
    camera_config_t cfg = {};
    cfg.ledc_channel = LEDC_CHANNEL_0;
    cfg.ledc_timer   = LEDC_TIMER_0;
    cfg.pin_d0       = Y2_GPIO_NUM;
    cfg.pin_d1       = Y3_GPIO_NUM;
    cfg.pin_d2       = Y4_GPIO_NUM;
    cfg.pin_d3       = Y5_GPIO_NUM;
    cfg.pin_d4       = Y6_GPIO_NUM;
    cfg.pin_d5       = Y7_GPIO_NUM;
    cfg.pin_d6       = Y8_GPIO_NUM;
    cfg.pin_d7       = Y9_GPIO_NUM;
    cfg.pin_xclk     = XCLK_GPIO_NUM;
    cfg.pin_pclk     = PCLK_GPIO_NUM;
    cfg.pin_vsync    = VSYNC_GPIO_NUM;
    cfg.pin_href     = HREF_GPIO_NUM;
    cfg.pin_sscb_sda = SIOD_GPIO_NUM;
    cfg.pin_sscb_scl = SIOC_GPIO_NUM;
    cfg.pin_pwdn     = PWDN_GPIO_NUM;
    cfg.pin_reset    = RESET_GPIO_NUM;
    cfg.xclk_freq_hz = 20000000;
    cfg.pixel_format = PIXFORMAT_JPEG;
    cfg.frame_size   = FRAMESIZE_VGA;   // 640×480 — good balance for MQTT
    cfg.jpeg_quality = 12;              // 0 (best) – 63 (worst)
    cfg.fb_count     = 1;
    return esp_camera_init(&cfg) == ESP_OK;
}

// ── WiFi ─────────────────────────────────────────────────────────────────────
static void connectWifi() {
    Serial.printf("\nConnecting to %s", WIFI_SSID);
    WiFi.begin(WIFI_SSID, WIFI_PASS);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.printf("\nWiFi connected — IP: %s\n", WiFi.localIP().toString().c_str());
}

// ── MQTT over TLS ────────────────────────────────────────────────────────────
static void connectMqtt() {
    net.setCACert(AWS_CERT_CA);
    net.setCertificate(AWS_CERT_CRT);
    net.setPrivateKey(AWS_CERT_PRIVATE);

    mqttClient.setServer(AWS_IOT_ENDPOINT, 8883);
    mqttClient.setBufferSize(40000);  // must fit a VGA JPEG (~20–30 KB)

    Serial.print("Connecting to AWS IoT Core");
    while (!mqttClient.connect(DEVICE_ID)) {
        Serial.print(".");
        delay(1000);
    }
    Serial.println("\nMQTT connected");
    mqttClient.publish(MQTT_TOPIC_STATUS, "{\"status\":\"online\"}");
}

// ── Capture one frame and publish ────────────────────────────────────────────
static void captureAndPublish() {
    camera_fb_t* fb = esp_camera_fb_get();
    if (!fb) {
        Serial.println("Camera capture failed");
        return;
    }

    bool ok = mqttClient.publish(MQTT_TOPIC_IMAGE, fb->buf, fb->len, /*retain=*/false);
    Serial.printf("Frame %u bytes — publish %s\n", fb->len, ok ? "OK" : "FAILED (buffer too small?)");

    esp_camera_fb_return(fb);
}

// ── Arduino entry points ─────────────────────────────────────────────────────
void setup() {
    Serial.begin(115200);

    if (!initCamera()) {
        Serial.println("Camera init FAILED — check wiring and halt");
        while (true) delay(1000);
    }

    connectWifi();
    connectMqtt();
}

void loop() {
    if (!mqttClient.connected()) {
        Serial.println("MQTT disconnected — reconnecting");
        connectMqtt();
    }
    mqttClient.loop();

    // TODO (upgrade path): replace this with a PIR interrupt on GPIO 13 so the
    // device deep-sleeps between motion events — drastically reduces power use.
    captureAndPublish();
    delay(CAPTURE_INTERVAL_MS);
}
