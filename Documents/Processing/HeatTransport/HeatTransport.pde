import processing.serial.*;

Serial myPort;
Table dataTable = new Table(); // Constructor for Table class in Processing
dataTable.

int numReadings = 10; // Number of readings to take
int readingCount = 0;
boolean firstReadFlag = true; // Flags the first reading of the data

String fileName;

void setup() {
  String portName = Serial.list()[2]; // Arduino communicates thru port 2
  myPort = new Serial(this, portName, 9600);
  
  dataTable.addColumn("id"); // Initialize all data columns
  dataTable.addColumn("year");
  dataTable.addColumn("month");
  dataTable.addColumn("day");
  dataTable.addColumn("hour");
  dataTable.addColumn("minute");
  dataTable.addColumn("second");
  dataTable.addColumn("volt1");
  dataTable.addColumn("volt2");
  dataTable.addColumn("volt3");
  dataTable.addColumn("volt4");
  dataTable.addColumn("volt5");
  dataTable.addColumn("volt6");
  dataTable.addColumn("temp1");
  dataTable.addColumn("temp2");
  dataTable.addColumn("temp3");
  dataTable.addColumn("temp4");
  dataTable.addColumn("temp5");
  dataTable.addColumn("temp6");
}

void draw() {
  serialEvent(myPort); // Continously check the port for events
}

void serialEvent(Serial myPort) {
  String s = myPort.readStringUntil('\n');
  if (s != null) {
    println(s); // Print to Processing console
    float data[] = float(split(s,',')); // Parse the serial data into an array
   
    TableRow newRow = dataTable.addRow(); // Create a new row for new data
    newRow.setInt("id", dataTable.lastRowIndex());
    newRow.setInt("year", year());
    newRow.setInt("month", month());
    newRow.setInt("day", day());
    newRow.setInt("hour", hour());
    newRow.setInt("minute", minute());
    newRow.setInt("second", second());
    
    newRow.setFloat("volt1", data[0]);
    newRow.setFloat("volt2", data[1]);
    newRow.setFloat("volt3", data[2]);
    newRow.setFloat("volt4", data[3]);
    newRow.setFloat("volt5", data[4]);
    newRow.setFloat("volt6", data[5]);
    newRow.setFloat("temp1", data[6]);
    newRow.setFloat("temp2", data[7]);
    newRow.setFloat("temp3", data[8]);
    newRow.setFloat("temp4", data[9]);
    newRow.setFloat("temp5", data[10]);
    newRow.setFloat("temp6", data[11]);
   
    readingCount++; // Reads until specified number of readings
    if (readingCount % numReadings == 0) {
      fileName = "HeatTransport_"+str(year())+"_"+str(month())+"_"
                    +str(day())+"_"+str(hour())+".csv"; // Save to CSV
      saveTable(dataTable, fileName);
    }
  }
}