# Automatic Program Downloader
When formatting the computer installing the programs again can be a hassle, this scripts aim to ease the process trough automation

# Usage
The usage is quite simple: 

If you run the **Install_All.ps1** script, it will download and install all programs inside the *Programs.json* file and also the VS Code extensions inside the *VSCode_Extensions.json*

You can also run the individual scripts, following the usage:

## > Download_Programs.ps1
```
> .\Scripts\Download_Programs.ps1 -path <The path where the .JSON file and the downloads will be (Defaults to the script's location)>
> .\Scripts\Download_Programs.ps1 -programJSON <The name of the .JSON with a '/' preffix (Defaults to '/Programs.json')>
> .\Scripts\Download_Programs.ps1 -program <A individual name of a program to download, if empty, will download all programs in the .JSON>
```

## > Install_Programs.ps1
```
> .\Scripts\Install_Programs.ps1 -path <The path of the folder containing the installers (Defaults to the scripts location + \Downloads)>
> .\Scripts\Install_Programs.ps1 -type <The type of the installer "exe or msi" (Defaults to 'all')>
```

## > Install_Code_Extensions.ps1
```
> .\Scripts\Install_Code_Extensions.ps1 -extensionsJSON <The path of the .JSON containing the extension names (Defaults to the location + VSCode_Extensions.json)>
> .\Scripts\Install_Code_Extensions.ps1 -extension <A single extension to install, if empty, will install all extensions in the .JSON>
```

# Programs.json Customization
The number of programs that the downloader can use is limited to the entries in the .JSON file.
I encourage you to make contributions to a new file called *Extra.json* on this repository, just make a pull request

The JSON file structure is just an array containing all the entries:

```JSON
[
    {
        "Name":"<Program name here, no spaces>",
        "Link":"<The download link of the program>",
        "Pattern":"A PowerShell code that returns the actual download link of the program"
    }
]
```

The pattern can be any code that returns a download link for that program. It is used when a file doesn't have a fixed download link. The script will try to retrieve the HTML code of the *Link* field and execute the *Pattern* to find the matching download link of the program in question.

You can view the already made entries for examples of patterns. But here a basic example:
```PowerShell
# The $link variable is the HTML code of the Link field of the program's entry (Downloaded with -UseBasicParsing for greater speed)
$link.links | ? href -match '.exe$' | select -First 1 -expand href
# In this pattern is used a RegEx pattern matching to select the first link in the page ending in '.exe'
```

Still a simple one:
```PowerShell
# The $link variable is the HTML code of the Link field of the program's entry (Downloaded with -UseBasicParsing for greater speed)
'https://github.com' + ($link.links | ? href -match '.exe$' | select -First 1 -expand href)"
# In this pattern is used a RegEx pattern matching to select the first link in the page ending in '.exe' and appends to the GitHub download link
```

And here is a more advanced one:
```PowerShell
# The $link variable is the HTML code of the Link field of the program's entry (Downloaded with -UseBasicParsing for greater speed)
($link.RawContent -match 'resources/yed/demo/yEd.{1,10}\\.zip') ; $link = 'https://www.yworks.com/' + $Matches[0]
# In this pattern is used a RegEx pattern matching to see if in the HTML exists a '.zip' file containing any number from 1 to 10 and selecting the first match of the RegEx
```

As I said, you can use any PowerShell code inside the *Pattern* field, as long it returns a single string containing the actual download link for the program

# Licence
Keep in mind that I do not own any of the software downloaded using the scripts, and all of them are property of their actual creators downloaded only using official sources. If one of those programs are paid, you will need to buy it to use.
I do not provide any support for those scripts in terms of damage, but feel free to ask any questions about the usage and improvement and I will gladly answer. Also feel free to make contributions to this repository, expanding the list of capable programs and improving the code.