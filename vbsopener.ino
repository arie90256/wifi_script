#include <Keyboard.h>

void setup() {
  // Start the keyboard library
  Keyboard.begin();
  
  // Give the computer some time to recognize the USB device
  delay(1500);
  
  // Open the Run dialog
  Keyboard.press(KEY_LEFT_GUI);
  Keyboard.press('r');
  delay(500);
  Keyboard.releaseAll();
  
  // Type the path to the VBS file on the USB drive
  Keyboard.print("E:\\try.vbs"); // Change "E:" to the correct drive letter
  delay(1000);
  
  // Press Enter to run the script
  Keyboard.press(KEY_RETURN);
  delay(500);
  Keyboard.releaseAll();
  
  // End the keyboard library
  Keyboard.end();
}

void loop() {
  // Nothing to do here
}
