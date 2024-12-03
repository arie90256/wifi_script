Dim WSH, FSO, RunIPConfig, TempDir, CMD, OpenFile, AllText, IntStr1, IntCounter
Dim FileExist, IPText, IntStr2, IPStart, IPEnd, IPDiff, IPAddress, StartPos, IntStr3, IPAddress1
Dim strComputerName, FinalIP

Set WSH = WScript.CreateObject("WScript.Shell")
Set WshNtwk = WScript.CreateObject("WScript.Network")
Set FSO = CreateObject("Scripting.FileSystemObject")

TempDir = WSH.ExpandEnvironmentStrings("%TEMP%")
CMD = WSH.ExpandEnvironmentStrings("%Comspec% /C")

' Silently run ipconfig; output to temporary file
RunIPConfig = WSH.run(CMD & " Ipconfig > %TEMP%\000001.tmp", 0, True)
WScript.Sleep 200

FileExist = FSO.FileExists(TempDir & "\000001.tmp")

' Read through ipconfig output in temp file; strip the IP address from the text
StartPos = 1
For IntCounter = 1 to 6
    If FileExist = True Then
        Set OpenFile = FSO.OpenTextFile(TempDir & "\000001.tmp", 1, False, 0)
        OpenFile.Skip(StartPos)
        Do While NOT OpenFile.AtEndOfStream
            AllText = OpenFile.ReadAll
        Loop
        IntStr1 = Instr(StartPos, AllText, "IPv4 Address", 1)
        IntStr2 = InStr(IntStr1, AllText, ": ", 1)
        IPStart = IntStr2 + 2
        IPEnd = IPStart + 15
        IPDiff = IPEnd - IPStart
        IPAddress = Mid(AllText, IPStart, IPDiff)
        IntStr3 = InStr(1, IPAddress, "0.0.0.0", 1)
        If IntStr3 = "1" Then StartPos = IPEnd
        If NOT IntStr3 = "1" Then IntCounter = 6
    End If
Next

' Remove spacings and carriage returns
IPAddress1 = Trim(IPAddress)
FinalIP = Replace(IPAddress1, vbCr, "")

' Display the IP address and computer name in user-friendly message box
MsgBox "Computer Name:" & vbTab & UCase(WshNtwk.ComputerName) & vbCrLf & "IP Address:" & vbTab & FinalIP, vbOkOnly, "Computer Details"

On Error Goto 0
WScript.Quit