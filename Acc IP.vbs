Dim WSH, FSO, TempDir, CMD, OpenFile, AllText, IPStart, IPEnd, IPAddress
Dim WshNtwk, FinalIP

Set WSH = WScript.CreateObject("WScript.Shell")
Set WshNtwk = WScript.CreateObject("WScript.Network")
Set FSO = CreateObject("Scripting.FileSystemObject")

TempDir = WSH.ExpandEnvironmentStrings("%TEMP%")
CMD = WSH.ExpandEnvironmentStrings("%Comspec% /C")

' Silently run ipconfig; output to temporary file
WSH.run CMD & " ipconfig > " & TempDir & "\000001.tmp", 0, True
WScript.Sleep 200

If FSO.FileExists(TempDir & "\000001.tmp") Then
    Set OpenFile = FSO.OpenTextFile(TempDir & "\000001.tmp", 1, False, 0)
    AllText = OpenFile.ReadAll
    OpenFile.Close

    IPStart = InStr(AllText, "IPv4 Address") + Len("IPv4 Address") + 2
    IPEnd = InStr(IPStart, AllText, vbCrLf)
    IPAddress = Mid(AllText, IPStart, IPEnd - IPStart)
    FinalIP = Trim(Replace(IPAddress, vbCr, ""))
    
    ' Display the IP address and computer name in user-friendly message box
    MsgBox "Computer Name:" & vbTab & UCase(WshNtwk.ComputerName) & vbCrLf & "IP Address:" & vbTab & FinalIP, vbOkOnly, "Computer Details"
End If

WScript.Quit
