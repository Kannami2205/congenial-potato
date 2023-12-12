#include <IRremote.h>
#include <Servo.h>

// Pin configuration
const int IR_RECEIVER_PIN = 2;
const int SERVO_PIN = 9;

// set up IR receiver and servo 
IRrecv irrecv(IR_RECEIVER_PIN);
Servo myservo;

// Servo position (0-180 degrees)
int pos = 0;

void setup() {
  // Start the IR receiver
  irrecv.enableIRIn();
  
  // Attach the servo to the SERVO_PIN
  myservo.attach(SERVO_PIN);
  myservo.write(pos);
}

void loop() {
  // Check IR signal received
  if (irrecv.decode()) {
    // Handle the received IR code
    switch (irrecv.decodedIRData.decodedRawData) {
      case 0xF30CFF00: // Button '1' (move servo to 0 degrees)
        pos = 0;
        break;
      case 0xE718FF00: // Button '2' (move servo to 90 degrees)
        pos = 90;
        break;
      case 0xA15EFF00: // Button '3' (move servo to 180 degrees)
        pos = 180;
        break;
      default:
        // If the button is not recognized, do nothing
        break;
    }

    // Move the servo to the new position
    myservo.write(pos);

    // Wait for the servo to reach the position
    delay(15);

    // Resume IR reception
    irrecv.resume();
  }
}
