Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
Set objNetwork = CreateObject("WScript.Network")

' Get system information
strComputerName = objNetwork.ComputerName
strUserName = objNetwork.UserName
strOS = objShell.ExpandEnvironmentStrings("%OS%")
strProcessor = objShell.ExpandEnvironmentStrings("%PROCESSOR_IDENTIFIER%")

' Create a text file on the USB drive (assuming the USB drive is D:)
strFilePath = "D:\SystemInfo.txt"
Set objFile = objFSO.CreateTextFile(strFilePath, True)

' Write system information to the text file
objFile.WriteLine "Computer Name: " & strComputerName
objFile.WriteLine "User Name: " & strUserName
objFile.WriteLine "Operating System: " & strOS
objFile.WriteLine "Processor: " & strProcessor

objFile.Close

WScript.Echo "System information saved to " & strFilePath