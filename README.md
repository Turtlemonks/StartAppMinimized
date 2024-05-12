
# StartAppsMinimized PowerShell Script

## Overview
The `StartAppsMinimized` script is designed to automatically launch and minimize specified applications at system startup. It's ideal for setting up a clean desktop environment by running necessary background applications without cluttering the desktop.

## Features
- **Automated Launch and Minimize**: Automatically starts and minimizes specified applications.
- **Retry Mechanism**: Tries multiple times to handle applications that are not ready to minimize on the first attempt.
- **Flexible Configuration**: Uses an external text file to manage application paths and window titles for customization.

## Requirements
- Windows Operating System with PowerShell.
- Administrative rights may be required depending on the application and script setup location.

## Setup Instructions

### 1. Script Installation
Download the `StartAppsMinimized.ps1` script and place it in a suitable directory, for example:
```
C:\Scripts\
```

### 2. Configuration File Setup
Create a text file named `applications.txt` in the same directory as the script or another specified directory. This file should contain the paths and window titles of the applications you wish to manage.

#### Format of `applications.txt`
Each line should contain the application's executable path and the main window title, separated by a comma:
```
Full_Path_To_Application,Window_Title
```
Example:
```
C:\Program Files\Google\Chrome\Application\chrome.exe,New Tab - Google Chrome
```

### 3. Customize Script Parameters
Modify the following parameters within the script as needed:
- `$applicationFilePath`: Path to the `applications.txt` file.
- `$logPath`: Path to where the log file will be stored.
- `$initialDelay` and `$maxAttempts`: Control the timing and number of retries for minimizing the application windows.

### 4. Schedule the Script
Set up the script to run at system startup using Windows Task Scheduler:
- Open Task Scheduler and create a new task.
- Set the trigger to 'At system start'.
- Set the action to run `powershell.exe` with arguments `-ExecutionPolicy Bypass -File "C:\Scripts\StartAppsMinimized.ps1"`.

## Usage
Once configured, the script will run automatically based on the Task Scheduler settings, or it can be run manually via PowerShell for testing:
```
powershell.exe -ExecutionPolicy Bypass -File "C:\Scripts\StartAppsMinimized.ps1"
```

## Troubleshooting
- Ensure paths in `applications.txt` are correct and accessible.
- Check the log file at `$logPath` for any error messages or issues during execution.
- Verify that all applications have correct and consistent window titles as expected.

## License
This script is released under the MIT License.

## Author
Turtlemonks
