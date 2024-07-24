<#
.SYNOPSIS
Executes all PowerShell script files found in a specified directory and its subdirectories.

.DESCRIPTION
This script searches for all `.ps1` files in a given directory and its subdirectories and executes them sequentially. It logs the output of each script and handles any errors encountered during execution.

.PARAMETER Directory
The root directory where the search for PowerShell scripts will begin. This parameter is mandatory.

.EXAMPLE
.\ExecuteAllPowerShellScripts.ps1 -Directory "C:\Scripts"

This example demonstrates how to run the script, which will search for and execute all `.ps1` files within the "C:\Scripts" directory and its subdirectories.

.NOTES
- Ensure you have the necessary permissions to execute scripts in the specified directory.
- The script handles errors gracefully and continues executing subsequent scripts even if one fails.
- You may customize the logging mechanism as needed.
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$Directory
)

# Validate if the provided directory exists
if (-Not (Test-Path -Path $Directory)) {
    Write-Error "The specified directory does not exist: $Directory"
    exit 1
}

# Find all PowerShell script files (.ps1) in the directory and its subdirectories
$scriptFiles = Get-ChildItem -Path $Directory -Recurse -Filter *.ps1

if ($scriptFiles.Count -eq 0) {
    Write-Output "No PowerShell scripts found in the directory: $Directory"
    exit 0
}

foreach ($scriptFile in $scriptFiles) {
    Write-Output "Executing script: $($scriptFile.FullName)"

    try {
        # Execute the script
        & $scriptFile.FullName

        # Check if the script executed successfully
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Script $($scriptFile.FullName) failed with exit code $LASTEXITCODE."
        } else {
            Write-Output "Script $($scriptFile.FullName) executed successfully."
        }
    } catch {
        # Catch any errors that occur during script execution
        Write-Error "An error occurred while executing script $($scriptFile.FullName): $_"
    }
}
