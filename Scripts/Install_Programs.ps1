# Script for installing all programs in a folder slilentily
# Author: Helton Reis

# Change before running, or use the params
param (
    [string]$path = $PSScriptRoot + "\Downloads",
    [string]$type = "all"
)

# Install each of the .MSI files quietly and logs the output to a file of the same name with the DateStamp of the execution
function InstallMSI($file) {
    $DataStamp = get-date -Format yyyyMMddTHHmmss
    $logFile = '{0}-{1}.log' -f $file.fullname, $DataStamp
    $MSIArguments = @(
        "/i"
        ('"{0}"' -f $file.fullname)
        "/qn"
        "/norestart"
        "/L*v"
        $logFile
    )
    Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow 
}

# Run each of the .EXE files with the arguments /S /v /qn and PassTrhu
function InstallEXE($file) {
    Start-Process -Wait -FilePath $file.fullname -ArgumentList "/S /v /qn" -PassThru
}

switch ($type) {
    "msi" { 
        Get-ChildItem $path -Filter *.msi | 
            Foreach-Object {
                InstallMSI($_)
            } 
    }

    "exe" {
        Get-ChildItem $path -Filter *.exe | 
            Foreach-Object {
                InstallEXE($_)
            }
    }
    Default { 
        Get-ChildItem $path -Filter *.msi | 
            Foreach-Object {
                InstallMSI($_)
            } 

        Get-ChildItem $path -Filter *.exe | 
            Foreach-Object {
                InstallEXE($_)
            }
    }
}