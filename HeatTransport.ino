
// ENPH 257 - Heat Transport

int numPins = 6;
int sensorPins[] = {A0, A1, A2, A3, A4, A5}; // Initialize pins

void setup() {
  Serial.begin(9600); // Start serial @ 9600 bauds 
  analogReference(EXTERNAL); // Reference voltage set by AREF pin
}

void loop() {
  float voltageReadings[numPins]; // Temporarily store readings
  float tempReadings[numPins];
  for (int i = 0; i < numPins; i++) { // Read from all pins
    voltageReadings[i] = analogRead(sensorPins[i]) * 3.3/1023.0; // Convert 10 bit to V
    tempReadings[i] = (voltageReadings[i]) * 100.0; // Convert 10mV/˚C
  } // Print data to serial for reading
  for (int i = 0; i < numPins; i++) {
    Serial.print(voltageReadings[i]);
    Serial.print(",");
  }
  for (int i = 0; i < numPins; i++) {
    Serial.print(tempReadings[i]);
    Serial.print(",");
  }
  Serial.print(millis() / 1000); // Print the elapsed time
  Serial.println();
  delay(1000); // Run every 0.1 s
}
