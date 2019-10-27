# Script for downloading a batch of programs
# Author: Helton Reis

# Modify those variables before running
param (
    [string]$path = $PSScriptRoot,
    [string]$programJSON = "\Programs.json",
    [string]$program = ""
)

# Do not touch those ones
$json = $null;
$link = $null;

Write-Host "Attempting to locate JSON"

# Checks if JSON file exists
if ([System.IO.File]::Exists($path + $programJSON)) {
    Write-Host "Found file, procceding"
    Write-Host "======================"
    $json = (Get-Content ($path + $programJSON) -Raw) | ConvertFrom-Json
}
else {
    Write-Host "File not found, aborting"
    Write-Host "========================"
    Exit-PSHostProcess
}

function DownloadProgram($jsonProgram){
    Write-Host "Downloading" $jsonProgram.Name "..."

    # If the jsonProgram doesn't have a pattern, then just download the file, if it have, parse the pattern to get the download link
    # Useful when the page don't have a static link 
    if ( $jsonProgram.Pattern -ne "") {
        Write-Host "Searching download link..."
        # Gets the HTML of the page
        $link = Invoke-WebRequest -Uri $jsonProgram.Link -UseBasicParsing
        $link = Invoke-expression $jsonProgram.Pattern
    }
    else {
        $link = $jsonProgram.Link
    }

    # If the the link doesn't contain the file name redirects one time to get the actual download link
    if( $link -match ".exe$" -or $link -match ".msi$" -or $link -match ".zip$"){
        Write-Host "Found file at:" $link ":"
        $Filename = $link.SubString($link.LastIndexOf('/') + 1)
    }else{
        $Filename = (Invoke-WebRequest -Uri $link -MaximumRedirection 0 -ErrorAction Ignore).Headers.Location
        Write-Host "Found file at:" $Filename ":"
        $Filename = $Filename.SubString($Filename.LastIndexOf('/') + 1)
    }

    (New-Object System.Net.WebClient).DownloadFile($link, $path + "\Downloads\" + $Filename)
    $Filename = ""

    Write-Host ""
}

# If JSON is not null, then procceds
if ($null -ne $json) {
    # Checks for a downloads folder, if it don't exists, create one
    if(Test-Path -Path ($path + "\Downloads")){
        Write-Host "Downloads folder found..."
    }else{
        Write-Host "Downloads folder not found, creating one..."
        New-Item -ItemType Directory -Force -Path ($path + "\Downloads")
    }

    if($program -eq ""){
        # For each item in the JSON array, execute the download code
        foreach ($item in $json) {
            DownloadProgram($item)
        }

        Write-Host "Download Complete"
    }else{
        DownloadProgram( $json | Where-Object { $_.Name -eq $program } )
        Write-Host "Download Complete"
    }
    
}