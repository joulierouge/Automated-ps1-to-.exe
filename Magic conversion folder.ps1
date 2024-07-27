# Define the folder to monitor
$folderPath = "C:\Scripts\Magic turn into Executables Folder"

# Define the folder for logs
$logFolderPath = "C:\Scripts\logs\Magic conversion logs"

# Ensure the log folder exists
if (-not (Test-Path -Path $logFolderPath)) {
    New-Item -ItemType Directory -Path $logFolderPath
}

# Define a function to log actions
function Log-Action {
    param (
        [string]$message
    )
    $logFilePath = Join-Path -Path $logFolderPath -ChildPath "MagicConversionLog.txt"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Add-Content -Path $logFilePath -Value $logMessage
}

# Define a function to convert files to .exe
function Convert-ToExe {
    param (
        [string]$filePath
    )
    $outputPath = [System.IO.Path]::ChangeExtension($filePath, '.exe')
    Invoke-PS2EXE $filePath $outputPath
    Log-Action "Converted $filePath to $outputPath"
    Write-Host "Converted $filePath to $outputPath"
}

# Monitor the folder for new .txt and .ps1 files
while ($true) {
    $txtFiles = Get-ChildItem -Path $folderPath -Filter *.txt -File
    $ps1Files = Get-ChildItem -Path $folderPath -Filter *.ps1 -File
    
    # Convert .txt files to .exe
    foreach ($file in $txtFiles) {
        Convert-ToExe -filePath $file.FullName
        Remove-Item -Path $file.FullName -Force
        Log-Action "Deleted original file $($file.FullName)"
    }
    
    # Convert .ps1 files to .exe
    foreach ($file in $ps1Files) {
        Convert-ToExe -filePath $file.FullName
        Remove-Item -Path $file.FullName -Force
        Log-Action "Deleted original file $($file.FullName)"
    }
    
    # Wait for 10 seconds before checking again
    Start-Sleep -Seconds 10
}