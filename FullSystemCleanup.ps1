# ============================================
# UNIVERSAL-SAFE WINDOWS DEEP CLEANUP SCRIPT
# Logs saved to user's Desktop (clean output)
# ============================================

# Get Desktop path (works with OneDrive or local)
$Desktop = [Environment]::GetFolderPath("Desktop")

# Create log folder on Desktop
$LogFolder = "$Desktop\WindowsCleanupLogs"
if (!(Test-Path $LogFolder)) {
    New-Item -ItemType Directory -Path $LogFolder | Out-Null
}

# Create timestamped log file
$Timestamp = (Get-Date).ToString("yyyy-MM-dd_HH-mm-ss")
$LogFile = "$LogFolder\Cleanup_$Timestamp.log"

# Logging function
function Log {
    param([string]$Message)
    $Time = (Get-Date).ToString("HH:mm:ss")
    $Entry = "[$Time] $Message"
    Add-Content -Path $LogFile -Value $Entry
    Write-Host $Entry
}

Log "===== Windows Deep Cleanup Started ====="

# Disable Hibernation
Log "Disabling hibernation..."
powercfg -h off | Out-Null

# Stop Windows Update services (clean logging)
Log "Stopping Windows Update services..."

# BITS
$bits = Get-Service -Name bits
if ($bits.Status -eq "Running") {
    cmd /c "net stop bits >nul 2>&1"
    Log "BITS stopped successfully."
} else {
    Log "BITS was already stopped."
}

# WUAUSERV
$wua = Get-Service -Name wuauserv
if ($wua.Status -eq "Running") {
    cmd /c "net stop wuauserv >nul 2>&1"
    Log "Windows Update service stopped."
} else {
    Log "Windows Update service was already stopped."
}

# Delete SoftwareDistribution
Log "Cleaning SoftwareDistribution..."
Remove-Item "C:\Windows\SoftwareDistribution" -Recurse -Force -ErrorAction SilentlyContinue

# Restart services (clean logging)
Log "Restarting Windows Update services..."

cmd /c "net start bits >nul 2>&1"
Log "BITS started."

cmd /c "net start wuauserv >nul 2>&1"
Log "Windows Update service started."

# Temp folders
Log "Cleaning temp folders..."
Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\System32\config\systemprofile\AppData\Local\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\ServiceProfiles\LocalService\AppData\Local\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# WER logs
Log "Cleaning WER logs..."
Remove-Item "C:\ProgramData\Microsoft\Windows\WER\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft\Windows\WER\*" -Recurse -Force -ErrorAction SilentlyContinue

# Delivery Optimization
Log "Cleaning Delivery Optimization..."
Remove-Item "C:\Windows\SoftwareDistribution\DeliveryOptimization\*" -Recurse -Force -ErrorAction SilentlyContinue

# Windows Update logs
Log "Cleaning Windows Update logs..."
Remove-Item "C:\Windows\Logs\WindowsUpdate\*" -Recurse -Force -ErrorAction SilentlyContinue

# CBS logs
Log "Cleaning CBS logs..."
Remove-Item "C:\Windows\Logs\CBS\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\Logs\CBS\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# OneDrive logs
Log "Cleaning OneDrive logs..."
Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive\logs\*" -Recurse -Force -ErrorAction SilentlyContinue

# VS Code cache
Log "Cleaning VS Code cache..."
Remove-Item "$env:APPDATA\Code\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue

# Prefetch
Log "Cleaning Prefetch..."
Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue

# Panther logs
Log "Cleaning Panther logs..."
Remove-Item "C:\Windows\Panther\*" -Recurse -Force -ErrorAction SilentlyContinue

# Diagnosis logs
Log "Cleaning Diagnosis logs..."
Remove-Item "C:\ProgramData\Microsoft\Diagnosis\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\*" -Recurse -Force -ErrorAction SilentlyContinue

# Component Store Cleanup
Log "Running DISM StartComponentCleanup..."
Dism.exe /Online /Cleanup-Image /StartComponentCleanup | Add-Content $LogFile

Log "Running DISM ResetBase..."
Dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase | Add-Content $LogFile

# Shadow copies
Log "Deleting shadow copies..."
vssadmin delete shadows /all /quiet | Out-Null

# Final free space
$Drive = Get-PSDrive -Name C
Log "Final Free Space: $($Drive.Free) bytes"

Log "===== Cleanup Completed Successfully ====="
