<#
.SYNOPSIS
Launches and minimizes specified applications on system startup.

.DESCRIPTION
This script reads application details from an external text file and manages the startup and minimization of each application. Designed to reduce desktop clutter, this approach is beneficial for systems where specific applications need to run in the background from startup.

.PARAMETER None
This script operates based on a configuration file specifying application paths and window titles. Adjustments for the timing and retries are parameterized for flexibility.

.EXAMPLE
.\StartAppsMinimized.ps1
Runs the script to start and minimize applications based on the entries in the configuration file.

.NOTES
- Modify the 'applications.txt' file to update paths and titles. Each entry should be formatted as "Full_Path_To_Application,Window_Title".
- Detailed execution steps and errors are logged to 'C:\temp\appMinimizeLog.txt'.
- The script attempts multiple times to handle applications if they are not ready to minimize on the first try.
- Customizable Parameters:
  - $applicationFilePath: Update this variable to change where the script looks for the configuration file.
  - $logPath: Change this variable if logs should be written to a different location.
  - $initialDelay and $maxAttempts: Adjust these parameters in the function calls to change how long the script waits before the first attempt and how many attempts it makes.

.AUTHOR
Turtlemonks
Written on: May 4, 2024

.LICENSE
-This script is released under the MIT License.
-See the LICENSE file at the root of this repository for full license text.

#>

function Start-MinimizeApp($path, $windowTitle, $initialDelay, $maxAttempts) {
    $logPath = "C:\temp\appMinimizeLog.txt"  # Specify the path for the log file. This can be modified as needed.
    $attempts = 0
    do {
        try {
            "Attempting to start $path" | Out-File $logPath -Append
            $process = Start-Process -FilePath $path -PassThru
            Start-Sleep -Seconds $initialDelay

            "Looking for window title containing: $windowTitle" | Out-File $logPath -Append
            $appProcess = Get-Process | Where-Object { $_.Id -eq $process.Id -and $_.MainWindowTitle -like "*$windowTitle*" }
            if ($appProcess) {
                Add-Type @"
                using System;
                using System.Runtime.InteropServices;
                public class Win32 {
                    [DllImport("user32.dll")]
                    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
                }
"@
                [Win32]::ShowWindow($appProcess.MainWindowHandle, 2) # SW_MINIMIZE corresponds to 2
                "Successfully minimized window for $path" | Out-File $logPath -Append
                return
            }
            else {
                "Window not found, retrying..." | Out-File $logPath -Append
                $initialDelay += 2
                $attempts++
            }
        }
        catch {
            "Error encountered with path $($path): $($_.Exception.Message)" | Out-File $logPath -Append
            Write-Host "Error encountered with path ${path}: $($_.Exception.Message)" -ForegroundColor Red
            $attempts++
            Start-Sleep - 2
        }
    } while ($attempts -lt $maxAttempts)

    "Failed to minimize $path after $maxAttempts attempts." | Out-File $logPath -Append
}

# Main Script Execution
$applicationFilePath = "C:\Path\To\applications.txt"  # Modify this path to where your applications.txt is located.
$logPath = "C:\temp\appMinimizeLog.txt"  # Modify this path if you wish to change the log file location.
$maxAttempts = 3  # Define maxAttempts here if you want a script-wide consistent setting

if (Test-Path $applicationFilePath) {
    $applications = Get-Content $applicationFilePath
    foreach ($line in $applications) {
        $details = $line -split ','
        $appPath = $details[0].Trim()
        $appTitle = $details[1].Trim()
        Start-MinimizeApp -path $appPath -windowTitle $appTitle -initialDelay 5 -maxAttempts $maxAttempts
    }
}
else {
    "Configuration file not found at $applicationFilePath" | Out-File $logPath -Append
}
