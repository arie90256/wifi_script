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

WScript.Echo "System information has been saved to D:\SystemInfo.txt"