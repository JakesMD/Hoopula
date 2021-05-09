#include "BluetoothSerial.h"

#define IR1_PIN 23 // Top IR sensor
#define IR2_PIN 22 // Bottom IR sensor

bool ballAbove = false;
bool isConnected = false;

int irStatus = HIGH;
long millisSinceDetected = 0;

BluetoothSerial SerialBT;

// Called when the ESP32 boots.
void setup() {
  // Setups Bluetooth.
  Serial.begin(115200);
  SerialBT.begin("Hoopula");
  SerialBT.register_callback(bt_callback);

  // Setups IR Sensors.
  pinMode (IR1_PIN, INPUT);
  pinMode (IR2_PIN, INPUT);
}

// Called when the Bluetooth state changes or an event occurs.
void bt_callback(esp_spp_cb_event_t event, esp_spp_cb_param_t *param) {
  // True if the Bluetooth has connected.
  if (event == ESP_SPP_SRV_OPEN_EVT) {
    isConnected = true;
    Serial.println("Client Connected.");
  }

  // True if the Bluetooth has lost connection.
  else if (event == ESP_SPP_CLOSE_EVT) {
    // Resets everything.
    isConnected = false;
    ballAbove = false;
    millisSinceDetected = 0;
    Serial.println("Client Disconnected. Waiting for client to connect...");
  }
}

// Called indefinitely after the setup.
void loop() {
  // True if the Bluetooth is connected.
  if (isConnected) {
    // True if the ball has NOT been detected above the hoop by IR1.
    if (!ballAbove) {
      // Checks if the ball is under the hoop.
      irStatus = digitalRead(IR2_PIN);
      // True if the ball has been detected under the hoop by IR2.
      if (irStatus == LOW) {
        SerialBT.print("missed"); // Sends "missed" to the Android app.
        delay(1000);
      }

      // True if the ball has NOT been detected under the hoop by IR2.
      else {
        // Checks if the ball is above the hoop.
        irStatus = digitalRead(IR1_PIN);
        // True if the ball has been detected above the hoop by IR1.
        if (irStatus == LOW) {
          Serial.println("ball detected above the hoop.");
          ballAbove = true;
          millisSinceDetected = 0;
        }
      }
    }

    // True if the ball has been detected above the hoop by IR1.
    else {
      // Checks if the ball is going through the hoop.
      irStatus = digitalRead(IR2_PIN);
      // True if the ball has been detected in the hoop by IR2.
      if (irStatus == LOW) {
        Serial.println("ball detected in the hoop. Score!.");
        SerialBT.print("scored"); // Sends "scored" to the Android app.
        ballAbove = false;
        delay(1000);
      }

      // True if the ball has NOT been detected under/in the hoop by IR2.
      else {
        millisSinceDetected += 10; // Counts time elapsed.
        // True if the ball has not been detected in the hoop within 2 seconds.
        if (millisSinceDetected > 2000) {
          SerialBT.print("missed"); // Sends "missed" to the Android app.
          delay(1000);
          ballAbove = false;
        }
      }
    }
  }

  delay(5);

}
