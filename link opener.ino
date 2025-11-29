#include "Keyboard.h"

void setup() {
NEW SKETCH
1615141112139107865432
#include "Keyboard.h"

void setup() {
  // Begin keyboard communication
  Keyboard.begin();

  // Give some time for the computer to recognize the device
  delay(2000);
  // Open Microsoft Edge
  openBrowser("msedge");


  // Begin keyboard communication
  Keyboard.begin();

  // Give some time for the computer to recognize the device
  delay(2000);
  // Open Microsoft Edge
  openBrowser("msedge");
}

// Function to open a browser and access its history
void openBrowser(const char* browser) {
  // Open the Run dialog
  Keyboard.press(KEY_LEFT_GUI);
  Keyboard.press('r');
  Keyboard.release('r');
  Keyboard.release(KEY_LEFT_GUI);
  delay(500); // Wait for the Run dialog to open

  // Type the browser name
  Keyboard.print(browser); // Type 'msedge'
  Keyboard.press(KEY_RETURN); // Press Enter to open the browser
  Keyboard.release(KEY_RETURN);
  delay(3000); // Wait for the browser to open

  // Open the browser's History (Ctrl + H)
  Keyboard.press(KEY_LEFT_CTRL); // Press and hold Ctrl
  Keyboard.press('h');            // Press 'H'
  delay(100);                     // Small delay
  Keyboard.release('h');          // Release 'H'
  Keyboard.release(KEY_LEFT_CTRL); // Release Ctrl

  // Wait for the history to load
  delay(2000); // Adjust the delay as needed

  // Search DuckDuckGo
  searchDuckDuckGo();
}

// Function to search DuckDuckGo
void searchDuckDuckGo() {
  // Press Ctrl + L to focus on the address bar (or Alt + D)
  Keyboard.press(KEY_LEFT_CTRL);
  Keyboard.press('l'); // For focusing the address bar
  delay(100);
  Keyboard.release('l');
  Keyboard.release(KEY_LEFT_CTRL);

  // Type the pornhub URL
  Keyboard.print("https://your link"); 
  delay(100); // Small delay before pressing enter

  // Press Enter to go to pornhub
  Keyboard.press(KEY_RETURN);
  Keyboard.release(KEY_RETURN);
}

void loop() {
  // No repeated actions needed
}
