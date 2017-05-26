
// ENPH 257 - Heat Transport

#include <Time.h>
#include <TimeLib.h>

int numPins = 6;
int sensorPins[] = {A0, A1, A2, A3, A4, A5}; // Initialize pins

void setup() {
  Serial.begin(9600); // Start serial @ 9600 bauds 
}

void loop() {
  float voltageReadings[numPins];
  float tempReadings[numPins];
  
  for (int i = 0; i < numPins; i++) { // Read from all pins
    voltageReadings[i] = analogRead(sensorPins[i]) * 5.0/1024.0;
    tempReadings[i] = (voltageReadings[i]) * 100.0; // Convert from 10mV/˚C
  }
  for (int i = 0; i < numPins; i++) {
    Serial.print(voltageReadings[i]);
    Serial.print(",");
  }
  for (int i = 0; i < numPins; i++) {
    Serial.print(tempReadings[i]);
    if (i < numPins-1) {
      Serial.print(",");
    }
  }
  Serial.println();
  delay(1000);
}
