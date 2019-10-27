# This is just a test file for the Patterns, you can try your patterns here before adding them to the .JSON files

$url = "http://downloads.corsair.com/Files/Corsair-Link/Corsair-LINK-Installer-v4.9.7.35.zip"
#$link = (Invoke-WebRequest -Uri $url -UseBasicParsing).links | ? href -match '.zip$' | select -First 1 -expand href
$link = ((Invoke-WebRequest -Uri $url -UseBasicParsing).RawContent -match 'resources/yed/demo/yEd.{1,10}\.zip') ; $link = "https://www.yworks.com/" + $Matches[0]
#$link = 'https://github.com' + $link
#$link = (Invoke-WebRequest -Uri $url -MaximumRedirection 0 -ErrorAction Ignore)
Write-Host $link