import processing.serial.*;

Serial myPort;                       // The serial port
int[] serialInArray = new int[8];    // Where we'll put what we receive
int serialCount = 0;                 // A count of how many bytes we receive
boolean firstContact = false;        // Whether we've heard from the microcontroller

int joyX1, joyY1, button1, joyButton1;  // Variables for storing incoming sensor data
int joyX2, joyY2, button2, joyButton2; 

void startSerial() {
  // Print a list of the serial ports for debugging purposes
  printArray(Serial.list());
  
  // Open whatever port is the one you're using. 
  if (USE_JOYSTICK) {
    int portNumber = 5;
    String portName = Serial.list()[portNumber];
    myPort = new Serial(this, portName, 57600);
 }
}

// This gets called whenever the serial port gets new data
void serialEvent(Serial myPort) {
  int inByte = myPort.read();        // read a byte from the serial port...
  // if this is the first byte received, and it's an A, clear the serial
  // buffer and note that you've had first contact from the microcontroller.
  // Otherwise, add the incoming byte to the array of sensor values
  if (firstContact == false) {
    if (inByte == 'A') {
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      game.init();
      myPort.write('A');       // ask for more
    }
    
  // this piece of code captures the sensor data coming in  
  } else {
    serialInArray[serialCount] = inByte;    // Add the latest byte from the serial port to array
    serialCount++;                          // Increment count of how many data we've already received
   
    if (serialCount > 7) {        // If we have 3 bytes, that means we got everything and we are ready to act on it.      
      joyX1 = serialInArray[0];
      joyY1 = serialInArray[1];
      joyButton1 = serialInArray[2];
      button1 = serialInArray[3];
      joyX2 = serialInArray[4];
      joyY2 = serialInArray[5];
      joyButton2 = serialInArray[6];
      button2 = serialInArray[7];
      
      // Output to Processing console so we can see what incoming data looks like
      //printLog();
      
      executeJoystickInput(playerOne, joyX1, button1, joyButton1);
      executeJoystickInput(playerTwo, joyX2, button2, joyButton2);
      
      //check collisions directly after movement to prevent race conditions
      myPort.write('A');        // Send a capital A to request new sensor readings
      serialCount = 0;          // Reset serialCount, so we can get a new stream
    }
  }
}

void executeJoystickInput(Player _player, int _joyX, int _button, int joyButton) {
   if (joyButton == 1) {
     _player.jump();
   }
   if(_button == 1) {
     game.restart();
   }
   String _key = "";
   
   if((_joyX < 80)) {
     _key  = "LEFT";
   } else if((_joyX > 150)) {
      _key  = "RIGHT";
   }
   _player.applyKeys(_key);
}

void printLog() {
    println(joyX1 + "\t" + joyY1 + "\t" + joyButton1 + "\t" + button1);
    println(joyX2 + "\t" + joyY2 + "\t" + joyButton2 + "\t" + button2 + "\n");
}
