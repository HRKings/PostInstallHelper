# Script for installing a batch of VSCode Extensions
# Author: Helton Reis

# Modify those variables before running
param (
    [string]$extensionJSON = $PSScriptRoot + "\VSCode_Extensions.json",
    [string]$extension = ""
)


if ($extension -eq "") {
    # Checks if JSON file exists
    if ([System.IO.File]::Exists($extensionJSON)) {
        Write-Host "Found file, procceding"
        Write-Host "======================"
        $json = (Get-Content ($extensionJSON) -Raw) | ConvertFrom-Json
    }
    else {
        Write-Host "File not found, aborting"
        Write-Host "========================"
        Exit-PSHostProcess
    }

    if ($null -ne $json) {
        # For each item in the JSON array, execute the download code
        foreach ($item in $json) {
            code --install-extension $item
        }

        Write-Host "Installlation Complete"
    }
}
else {
    code --install-extension $extension
    Write-Host "Download Complete"
}
