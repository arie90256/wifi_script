#include <Keyboard.h>

void setup() {
  // Start the keyboard library
  Keyboard.begin();
  
  // Give the computer some time to recognize the USB device
  delay(2000);
  
  // Open the Run dialog
  Keyboard.press(KEY_LEFT_GUI);
  Keyboard.press('r');
  delay(1000);
  Keyboard.releaseAll();
  
  // Type the path to the VBS file on the USB drive
  Keyboard.print("E:"); // Change "E:" to the correct drive letter
  delay(4000);
  // Press Enter to run the script
  Keyboard.press(KEY_RETURN);
  delay(1000);
  Keyboard.releaseAll();
  delay(1000);
  Keyboard.print("try.vbs");
  Keyboard.press(KEY_RETURN);
  delay(500);
  Keyboard.releaseAll();
  // End the keyboard library
  Keyboard.end();
}

void loop() {
  // Nothing to do here
}
