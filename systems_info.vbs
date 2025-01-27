Dim objFSO, objFile, objWMIService, colItems, objItem
Dim output

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile("D:\SystemInfo.txt", True)

' Get WMI service
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")

' Retrieve Operating System information
Set colItems = objWMIService.ExecQuery("Select * from Win32_OperatingSystem")
For Each objItem in colItems
    output = output & "OS Name: " & objItem.Name & vbCrLf
    output = output & "Version: " & objItem.Version & vbCrLf
    output = output & "Manufacturer: " & objItem.Manufacturer & vbCrLf
    output = output & "Windows Directory: " & objItem.WindowsDirectory & vbCrLf
    output = output & "Locale: " & objItem.Locale & vbCrLf
    output = output & "Available Physical Memory: " & objItem.FreePhysicalMemory & vbCrLf
    output = output & "Total Virtual Memory: " & objItem.TotalVirtualMemorySize & vbCrLf
    output = output & "Available Virtual Memory: " & objItem.FreeVirtualMemory & vbCrLf
Next

' Retrieve Computer System information
Set colItems = objWMIService.ExecQuery("Select * from Win32_ComputerSystem")
For Each objItem in colItems
    output = output & "System Name: " & objItem.Name & vbCrLf
    output = output & "Manufacturer: " & objItem.Manufacturer & vbCrLf
    output = output & "Model: " & objItem.Model & vbCrLf
    output = output & "Total Physical Memory: " & objItem.TotalPhysicalMemory & vbCrLf
Next

' Retrieve Processor information
Set colItems = objWMIService.ExecQuery("Select * from Win32_Processor")
For Each objItem in colItems
    output = output & "Processor: " & objItem.Name & vbCrLf
    output = output & "Architecture: " & objItem.Architecture & vbCrLf
Next

' Retrieve BIOS information
Set colItems = objWMIService.ExecQuery("Select * from Win32_BIOS")
For Each objItem in colItems
    output = output & "BIOS Version: " & objItem.Version & vbCrLf
Next

' Write all collected information to the file
objFile.Write output
objFile.Close

WScript.Echo "System information has been saved to D:\SystemInfo.txt"
