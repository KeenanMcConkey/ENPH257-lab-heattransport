#include <Time.h>
#include <TimeLib.h>

// ENPH 257 - Heat Transport

int sensorPins[] = {A0, A1, A2, A3, A4, A5}; // Initialize pins
float voltageReadings[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
  float tempReadings[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
void setup() {
  Serial.begin(9600); // Start serial @ 9600 bauds 
}

void loop() {

  for (int i = 0; i < 6; i++) { // Read from all pins
    voltageReadings[i] = analogRead(sensorPins[i]) * 5.0/1024.0;
    tempReadings[i] = (voltageReadings[i]) * 100.0; // Convert from 10mV/˚C
  }
  for (int i = 0; i < 1; i++) {
    Serial.print(voltageReadings[i]);
    Serial.print(",");
  }
  Serial.println();
  for (int i = 0; i < 1; i++) {
    Serial.print(tempReadings[i]);
    Serial.print(",");
  }
  Serial.println();
  delay(1000);
}
