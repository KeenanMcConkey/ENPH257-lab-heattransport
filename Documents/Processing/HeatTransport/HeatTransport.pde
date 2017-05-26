import processing.serial.*;

Serial myPort;
Table table = new Table();

int numReadings = 10;
int readingCount = 0;

String fileName;

void setup() {
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  
  table.addColumn("id");
  table.addColumn("month");
  table.addColumn("day");
  table.addColumn("hour");
  table.addColumn("minute");
  table.addColumn("second");
  table.addColumn("temp1");
  table.addColumn("temp2");
  table.addColumn("temp3");
  table.addColumn("temp4");
  table.addColumn("temp5");
  table.addColumn("temp6");
}

void draw() {
  serialEvent(myPort);
}
void serialEvent(Serial myPort) {
  String tempS = myPort.readStringUntil('\n');
  if (tempS != null) {
    tempS = trim(tempS);
    println(tempS);
    float temps[] = float(split(tempS, ','));
    TableRow newRow = table.addRow();
    newRow.setInt("id", table.lastRowIndex());
    
    newRow.setInt("year", year());
    newRow.setInt("month", month());
    newRow.setInt("day", day());
    newRow.setInt("hour", hour());
    newRow.setInt("minute", minute());
    newRow.setInt("second", second());
    
    newRow.setFloat("temp1", temps[1]);
    newRow.setFloat("temp2", temps[2]);
    newRow.setFloat("temp3", temps[3]);
    newRow.setFloat("temp4", temps[4]);
    newRow.setFloat("temp5", temps[5]);
    newRow.setFloat("temp6", temps[6]);
    
    readingCount++;
    
    if (readingCount % numReadings == 0) {
      fileName = "HeatTransport" + str(year()) + str(month()) + str(day());
      saveTable(table, fileName);
    }
  }
}