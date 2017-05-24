#include <Time.h>
#include <TimeLib.h>

// ENPH 257 - Heat Transport

int sensorPins[] = {A0, A1, A2, A3, A4, A5}; // Initialize pins
float voltageReadings[6]; // Stores voltage readings
float tempReadings[6]; // Stores temperature readings

void setup() {
  Serial.begin(9600); // Start serial @ 9600 bauds 
  Serial.println("ENPH 257 - Heat Transport Lab");
  Serial.println("-----------------------------");
  Serial.println(" ");
}

void loop() {
  for (int i = 0; i < 1; i++) { // Read from all pins
    voltageReadings[i] = analogRead(sensorPins[i]) * 5.0/1024.0;
    tempReadings[i] = (voltageReadings[i]) * 100.0; // Convert from 10mV/˚C
  }
  time_t t = now();
  Serial.print("Elapsed Time: ");
  Serial.print(hour(t)); Serial.print(":");
  Serial.print(minute(t)); Serial.print(":");
  Serial.println(second(t));
  Serial.print("Voltages: ");
  for (int i = 0; i < 1; i++) {
    Serial.print(voltageReadings[i]);
    Serial.print(" V ");
  }
  Serial.println();
  Serial.print("Temperatures: ");
  for (int i = 0; i < 1; i++) {
    Serial.print(tempReadings[i]);
    Serial.print(" C ");
  }
  Serial.println();
  Serial.println();
  delay(1000);
}
