<#
.SYNOPSIS
    Converts a CSV file to an HTML report using PSWriteHTML.
.DESCRIPTION
    This function converts a CSV file to an HTML report using PSWriteHTML and preferred parameters. The function is a wrapper for the `ConvertTo-HTMLTable` function in PSWriteHTML. When the function is executed, a file browser will open to select the CSV file to convert. In order to use this function, you must have PSWriteHTML installed.
.PARAMETER None
    This function does not accept any parameters.
.EXAMPLE
    Convert-CSVtoHTML
    This example converts a CSV file to an HTML report using PSWriteHTML and preferred parameters.
.NOTES
    Author: Codeholics - TheBleak
    Version: 1.0
    Date: 8/2023
.LINK
    https://github.com/thebleak13/PowerShell-Samples/blob/main/BleakKitchenSink/README.md
#>
Function Convert-CSVtoHTML {
    Import-Module -Name PSWriteHTML
    $DownloadsPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    $File = Get-CSVFilePath
    $importFile = @(Import-CSV -path $File)
    $FileNameRaw = (Get-ChildItem $file).Name
    $FileName = $FileNameRaw.Replace(".csv",'')
    $OutputPath = Join-Path -Path $DownloadsPath -ChildPath "$FileName.html"
    Write-Host "`n`r ---> Exported report to $OutputPath" -foregroundcolor 'black' -backgroundcolor 'green'
    New-HTML {
        New-HTMLTable -DataTable $importFile -Title $FileName -HideFooter -PagingLength 10 -Buttons excelHtml5,searchPanes
    } -ShowHTML -FilePath $OutputPath -Online
} #Convert-CSVtoHTML


<#
.SYNOPSIS
Converts a UTC timestamp to a readable format.

.DESCRIPTION
The Convert-UTCTimeStamp function converts a UTC timestamp to a readable format. It uses the Windows Time service (w32tm.exe) to convert the timestamp to a string, and then extracts the last part of the string to get the readable timestamp.

.PARAMETER timestamp
The UTC timestamp to convert.

.EXAMPLE
PS C:\> Convert-UTCTimeStamp -timestamp 128271382742968750
Converts the UTC timestamp 128271382742968750 to a readable format.

.NOTES
This function requires the Windows Time service (w32tm.exe) to be installed and running on the local computer.
#>
Function Convert-UTCTimeStamp {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$timestamp
    )
    $string = (w32tm /ntte $timestamp)
    $newstring = $string.split('-')[-1]
    return $newstring
} # Convert-UTCTimeStamp -timestamp 128271382742968750




<#
.SYNOPSIS
    Asks the user a yes or no question and returns the answer.
.DESCRIPTION
    This function asks the user a yes or no question and returns the answer. The function uses the PowerShell host's `PromptForChoice` method to display the question and choices. The question is specified using the `$Question` parameter.
.PARAMETER Question
    Specifies the question to ask the user.
.EXAMPLE
    Get-AskUserYNQuestion -Question 'Are you ready?'
    This example asks the user the question "Are you ready?" and returns the user's answer.
.NOTES
    Author: Codeholics - TheBleak
    Version: 1.0
    Date: 8/2023
.LINK
    https://github.com/thebleak13/PowerShell-Samples/blob/main/BleakKitchenSink/README.md
#>
Function Get-AskUserYNQuestion {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$Question
    )
    $caption = $Question
    $message = "Choices:"
    $choices = @("&Yes","&No")
    
    $choicedesc = New-Object System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription] 
    $choices | ForEach-Object  {$choicedesc.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList $_))} 
    
    $prompt = $Host.ui.PromptForChoice($caption, $message, $choicedesc, 0)
    
    $Answer = Switch ($prompt){
           0 {"Yes"}
           1 {"No"}
         }
         return $Answer
} #Get-AskUserYNQuestion -Question 'Are you ready?'


<#
.SYNOPSIS
    Prompts the user to select a CSV file using a file browser dialog.
.DESCRIPTION
    This function prompts the user to select a CSV file using a file browser dialog. The function uses the .NET Framework's `System.Windows.Forms.OpenFileDialog` class to display the dialog. The initial directory can be specified using the `$initialDirectory` parameter. The function only allows CSV files to be selected.
.PARAMETER initialDirectory
    Specifies the initial directory to display in the file browser dialog.
.EXAMPLE
    Get-CSVFilePath -initialDirectory "C:\Users\UserName\Documents"
    This example displays the file browser dialog with the initial directory set to "C:\Users\UserName\Documents", and only allows CSV files to be selected.
.NOTES
    Author: Codeholics - TheBleak
    Version: 1.0
    Date: 8/2023
.LINK
    https://github.com/thebleak13/PowerShell-Samples/blob/main/BleakKitchenSink/README.md
#>
Function Get-CSVFilePath($initialDirectory) {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.Filter = "CSV UTF-8 (Comma Delimited) (*.csv)| *.csv"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}


<#
.SYNOPSIS
    Displays a folder browser dialog and returns the selected folder.
.DESCRIPTION
    This function displays a folder browser dialog and returns the selected folder. The function uses the .NET Framework's `System.Windows.Forms.FolderBrowserDialog` class to display the dialog. The initial directory can be specified using the `$initialDirectory` parameter.
.PARAMETER initialDirectory
    Specifies the initial directory to display in the folder browser dialog.
.EXAMPLE
    Get-Folder -initialDirectory "C:\Users\UserName\Documents"
    This example displays the folder browser dialog with the initial directory set to "C:\Users\UserName\Documents".
.NOTES
    Author: Codeholics - TheBleak
    Version: 1.0
    Date: 8/2023
.LINK
    https://github.com/thebleak13/PowerShell-Samples/blob/main/BleakKitchenSink/README.md
#>
Function Get-Folder($initialDirectory){

        [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
        $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
        $foldername.Description = "Select a folder"
        $foldername.rootfolder = "MyComputer"
        $foldername.SelectedPath = $initialDirectory
    
        if($foldername.ShowDialog() -eq "OK"){
        $folder += $foldername.SelectedPath
        }
        
        return $folder
} 


<#
.SYNOPSIS
Checks for updates to PowerShell modules installed from the PowerShell Gallery.

.DESCRIPTION
The Get-ModuleUpdates function checks for updates to PowerShell modules installed from the PowerShell Gallery. 
It compares the installed version of each module to the latest version available in the gallery and reports any modules
that have updates available.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
PS C:\> Get-ModuleUpdates
Checks for updates to PowerShell modules installed from the PowerShell Gallery and reports any modules that have updates available.

.EXAMPLE
$test = Get-ModuleUpdates
clear-host
Write-Host $test -ForegroundColor Green

.NOTES
This function requires PowerShell 5.0 or later and an internet connection to access the PowerShell Gallery.

- Author: TheBleak13@2023
- Version: 1.0

#>
function Get-ModuleUpdates {
    $InstalledModules = Get-InstalledModule
    $BaseUri = "https://www.powershellgallery.com/packages/"

    $Data = @()
    foreach ($item in $InstalledModules) {
        Try{
        $PSGallery = Find-Module -Name $item.Name -Repository PSGallery | 
            Select-Object -Property Name, Version, PublishedDate, @{Name = "InstalledVersion"; Expression = {$item.Version}}
        } Catch {
            
        }
        $Row = New-Object -TypeName PSObject -Property @{
            Name = $PSGallery.Name
            Version = $PSGallery.Version
            PublishedDate = $PSGallery.PublishedDate
            InstalledVersion = $PSGallery.InstalledVersion
            UpdateAvailable = $PSGallery.Version -gt $PSGallery.InstalledVersion
            Link = $BaseUri + $PSGallery.Name
        }
        $Data += $Row
    }

    $UpdateAvailable = $Data | Where-Object -Property UpdateAvailable -eq $true

    return $UpdateAvailable | Select-Object Name,UpdateAvailable,InstalledVersion,Version,PublishedDate,Link | Sort-Object -Property Name
}


<#
.SYNOPSIS
    Installs a custom module from the downloads folder to the module directory.
.DESCRIPTION
    This function installs a custom module from the downloads folder to the module directory. The function copies the module folder from the downloads folder to the module directory, and removes any existing module with the same name. If an Anti-Virus is running, it may flag this script as a virus. You will have to exclude powershell.exe from your AV during the installation.
.PARAMETER InputDir
    Specifies the path of the module to install. This parameter is mandatory. It should be the path to your module folder.
.PARAMETER UserLevel
    Specifies the level of the user for which the module should be installed. This parameter is optional and can be set to either 'Single' or 'All'. If not specified, the default value is 'All'.
.EXAMPLE
    Install-CustomModule -InputDir "C:\Users\thebl\Downloads\KitchenSink" -UserLevel "All"
    This example installs the "KitchenSink" module from the -InputDir  to the module directory for all users.

    Install-CustomModule -InputDir "C:\Users\thebl\Downloads\KitchenSink" -UserLevel "Single"
    This example installs the "KitchenSink" module from the -InputDir  to the module directory for the current user.
.NOTES
    Author: Team Codeholics - TheBleak13 https://github.com/thebleak13
    Version: 1.0
    Date: 8/2023
    Warning: If you're running an Anti-Virus, it may flag this script as a virus. You will have to exclude powershell.exe from your AV during the installation. Just make sure to remove the AV exception because leaving it in place is very risky.

    You don't really need this script, you can technically just copy the folder and paste it to the module directory 'C:\Program Files\WindowsPowerShell\Modules'. This will also avoid the issues with AV.
    Installing the module is useful but you can also just import-module with the path to use it for a script.
.LINK
    https://github.com/thebleak13/PowerShell-Samples/blob/main/Modules/KitchenSink/README.md
#>
Function Install-CustomModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $InputDir,
        [Parameter(Mandatory=$false)]
        $UserLevel = 'All'
    )

    # Get the module name from the input directory
    $ModuleName = $InputDir.Split('\')[-1]

    # Get the module path for single or all users
    if ($UserLevel -eq 'Single') {
        $WindowsPowerShellModulePath = $env:PSModulePath.Split(';')[0]
    } elseif ($UserLevel -eq 'ALL') {
        $WindowsPowerShellModulePath = $env:PSModulePath.Split(';')[1]
    } else {
        Write-Warning "UserLevel must be 'Single' or 'All'"
    }

    $ModuleOutputPath = "$WindowsPowerShellModulePath\$ModuleName"
    
    Write-Host "This script will install the $ModuleName module to the module directory." -ForegroundColor Black -BackgroundColor white
    Write-Host "Copy module from $InputDir to $WindowsPowerShellModulePath" -ForegroundColor Black -BackgroundColor white
    Write-Host "If you have an Anti-Virus, it may flag this script as a virus. You will have to exclude powershell.exe from your AV during the installation." -ForegroundColor Black -BackgroundColor Yellow

    # Check if the module is already installed
    $filecheck = test-path $ModuleOutputPath
    if ($filecheck) {
        Write-Host "Removing existing $ModuleName module from $WindowsPowerShellModulePath" -ForegroundColor Black -BackgroundColor Yellow
        Remove-Item -Path $ModuleOutputPath -Force -Recurse
    }

    # Copy the module to the module directory
    try{
    Copy-Item -Path $InputDir -Destination $ModuleOutputPath -PassThru -Recurse -ErrorAction Stop
    Write-Host "$ModuleName Was successfully installed to $WindowsPowerShellModulePath" -ForegroundColor Black -BackgroundColor Green
    }catch{
        $CatchError = $_.Exception.Message
        $ErrorType = $CatchError[0].Exception.GetType().FullName
        Write-Host $CatchError -ForegroundColor Black -BackgroundColor Red
        Write-Host $ErrorType -ForegroundColor Black -BackgroundColor Red
    }


    # Run this to create the profile
    $ProfilePath = "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
    $CheckProfile = Test-Path -Path $ProfilePath
    if ($CheckProfile -eq $false) {
        Write-Host "Creating profile at $ProfilePath" -ForegroundColor Black -BackgroundColor Yellow
        New-Item -ItemType File -Path $ProfilePath -Force
    }

    # Check if the Import-Module command already exists in the profile
    Write-Host "Checking if $ModuleName is already imported in the profile" -ForegroundColor Black -BackgroundColor Yellow
    $ProfileContent = Get-Content -Path $ProfilePath
    $ImportModuleCommand = "Import-Module -Name $ModuleName"
    $CommandExists = $ProfileContent -like "*$ImportModuleCommand*"

    # If the command does not exist, add it to the profile
    if (-not $CommandExists) {
        Write-Host "Adding $ModuleName to the profile" -ForegroundColor Black -BackgroundColor Yellow
        Add-Content -Path $ProfilePath -Value "`n$ImportModuleCommand`n"
    }

    #clear-host
    Start-Sleep 2

    Write-host "Validating Installation..." -ForegroundColor Yellow
    Import-Module -Name $ModuleName

    $check1 = Get-Module -Name $ModuleName

    $check2 = Get-Command -Module $ModuleName | format-table -AutoSize

    if ($check1 -and $check2) {
        Write-Host "Installation was successful!" -ForegroundColor Green
        $check2
    } else {
        Write-Host "Installation failed!" -ForegroundColor Red
    }
}  # Install-CustomModule -InputDir 'D:\Code\Repos\PowerShell-Modules\Modules\KitchenSink' -UserLevel 'All'


<#
.SYNOPSIS
    Creates a single PowerShell module (PSM) file from a folder of functions.
.DESCRIPTION
    This function creates a single PowerShell module (PSM) file from a folder of functions. The resulting PSM file will have the same name as the root folder and will contain all of the functions in the specified folder. Each function definition will be separated by two blank lines.
.PARAMETER RootFolder
    Specifies the root folder path of the module/project.
.PARAMETER FunctionsDir
    Specifies the name of the folder that contains the functions. The default value is "Functions".
.EXAMPLE
    Join-FunctionsToPSM -RootFolder "C:\Github\ProjectSample" -FunctionsDir "Functions"
    This example creates a PSM file with all of the functions in the root folder. The resulting PSM file will have the same name as the root folder.
.NOTES
    Author: Codeholics - TheBleak
    Version: 1.1
    Date: 8/24/2023
#>
function Join-FunctionsToPSM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$RootFolder,

        [Parameter(Mandatory = $false)]
        [string]$FunctionsDir = "Functions"
    )

    $RootFolderName = Get-Item $RootFolder | Select-Object -ExpandProperty Name
    $FunctionFolder = Join-Path -Path $RootFolder -ChildPath $FunctionsDir
    $FullPSMPath = Join-Path -Path $RootFolder -ChildPath "$RootFolderName.psm1"

    $Validation_root = Test-Path $RootFolder
    if ($validation_root -eq $false) {
        Write-Error "Root folder does not exist"
        return
    }

    $Validation_Functions = Test-Path $FunctionFolder
    if ($validation_Functions -eq $false) {
        Write-Error "Functions folder does not exist"
        return
    }

    $ResultBuilder = [System.Text.StringBuilder]::new()

    foreach ($File in Get-ChildItem -Path $FunctionFolder -Filter *.ps1 -File) {
        $FileContent = Get-Content $File.FullName -Raw
        $null = $ResultBuilder.AppendLine($FileContent)
        $null = $ResultBuilder.AppendLine()
        $null = $ResultBuilder.AppendLine()
    }

    Set-Content -Value $ResultBuilder.ToString() -Path $FullPSMPath
} # Join-FunctionsToPSM -RootFolder "D:\Code\Repos\PowerShell-Modules\Modules\KitchenSink" -FunctionsDir "Functions"


<#
.SYNOPSIS
    Exports a password to a file in UTF8 encoding and validates the file.
.DESCRIPTION
    Exports a password to a file in UTF8 encoding and validates the file. The function converts the password to a secure string and then to an encrypted standard string using the ConvertTo-SecureString and ConvertFrom-SecureString cmdlets. The encrypted string is then written to a file using the Out-File cmdlet. The function also validates the file by comparing the decrypted password to the original password.
.PARAMETER Filepath
    Specifies the path and filename of the file to export the password to.
.PARAMETER Password
    Specifies the password to export.
.PARAMETER ValidateOnly
    Specifies whether to validate the password file. If this parameter is specified, the password will not be exported.
.EXAMPLE
    PS C:\> New-CredsTxtFile -Filepath "C:\Temp\password.txt" -Password "MyPassword123"
    Exports the password "MyPassword123" to the file "C:\Temp\password.txt" in UTF8 encoding and validates the file.
.EXAMPLE
    PS C:\> New-CredsTxtFile -Filepath "C:\Temp\password.txt" -Password "MyPassword123" -ValidateOnly
    Validates the file "C:\Temp\password.txt" by comparing the decrypted password to the original password.
.NOTES
    This function exports a password to a file in UTF8 encoding and validates the file. The function converts the password to a secure string and then to an encrypted standard string using the ConvertTo-SecureString and ConvertFrom-SecureString cmdlets. The encrypted string is then written to a file using the Out-File cmdlet. The function also validates the file by comparing the decrypted password to the original password.
    
    Author: Codeholics - TheBleak
    Version: 1.0
    Date: 8/24/2023

    This function is not really needed but a good way to create and validate a password file in a consistent manner.

#>
function New-CredsTxtFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Filepath,
        [Parameter(Mandatory=$true)]
        [string]$Password,
        [Parameter(Mandatory=$false)]
        [bool]$ValidateOnly
    )
    
    if (!$ValidateOnly) {
    # Save the password
    Write-Host "Exporting Password to $Filepath"
    ConvertTo-SecureString -String $Password -AsPlainText -Force | ConvertFrom-SecureString | Out-File $Filepath -Encoding UTF8
    }

    # Verify password file
    $SecureString = ConvertTo-SecureString -String (Get-Content $Filepath)
    $Pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
    $SecretContent = [Runtime.InteropServices.Marshal]::PtrToStringAuto($Pointer)

    # Display the password in plain text
    # $SecretContent

    # Compare the password for a match
    if ($SecretContent -eq $Password) {
        Write-Host "Password MATCHED decrypted password." - foregroundcolor green
    } else {
        Write-Warning "Password DID NOT MATCH decrypted password."
    }
}  # New-CredsTxtFile -Filepath "C:\creds\creds.txt" -Password "P@ssw0rd"





<#
.SYNOPSIS
Creates a new JSON file containing secure data.

.DESCRIPTION
The New-SecuredJSON function creates a new JSON file containing secure data. The function encrypts the secure data and saves it to the specified file path.

.PARAMETER Filepath
Specifies the path to the JSON file to create.

.PARAMETER Password
Specifies the password to include in the JSON object.

.PARAMETER Username
Specifies the username to include in the JSON object.

.PARAMETER URL
Specifies the URL to include in the JSON object.

.PARAMETER IP
Specifies the IP address to include in the JSON object.

.PARAMETER Email
Specifies the email address to include in the JSON object.

.PARAMETER Token
Specifies the token to include in the JSON object.

.PARAMETER ClientID
Specifies the client ID to include in the JSON object.

.PARAMETER ClientSecret
Specifies the client secret to include in the JSON object.

.EXAMPLE
PS C:\> New-SecuredJSON -Filepath "D:\Code\test4.json" -Password "P@ssw0rd" -Username "MyUsername" -Email "jdoe@sample.com"

This example creates a new JSON file at the specified file path with the specified key-value pairs.

.NOTES
Author: thebleak13@2023
Version: 1.0
#>
function New-SecuredJSON {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Filepath,
        [Parameter(Mandatory=$true)]
        [string]$Password,
        [Parameter(Mandatory=$false)]
        [string]$Username,
        [Parameter(Mandatory=$false)]
        [string]$URL,
        [Parameter(Mandatory=$false)]
        [string]$IP,
        [Parameter(Mandatory=$false)]
        [string]$Email,
        [Parameter(Mandatory=$false)]
        [string]$Token,
        [Parameter(Mandatory=$false)]
        [string]$ClientID,
        [Parameter(Mandatory=$false)]
        [string]$ClientSecret
    )
    
    # Create JSON object
    $Json = @{}
    foreach ($param in "Password", "Username", "URL", "IP", "Email", "Token", "ClientID", "ClientSecret") {
        if ($PSBoundParameters.$param) {
            $Json.$param = (ConvertTo-SecureString -String $PSBoundParameters.$param -AsPlainText -Force) | ConvertFrom-SecureString
        }
    }

    # Convert the JSON object to a string
    $JsonString = $Json | ConvertTo-Json

    # Write JSON object to file
    $JsonString | Out-File -FilePath $Filepath
    Write-Host "Exported JSON to $Filepath" -ForegroundColor Green
} # New-SecuredJSON -Filepath "D:\Code\Repos\LD\PowerShell LD\WolfPack\Dev\test4.json" -Password "P@ssw0rd" -Username "MyUsername" -Email "EReis@loandepot.com"


<#
.SYNOPSIS
Creates a new JSON file containing secure data.

.DESCRIPTION
The New-SecuredJSONDynamic function creates a new JSON file containing secure data. 
The function encrypts the secure data and saves it to the specified file path.

.PARAMETER Filepath
Specifies the path to the JSON file to create.

.PARAMETER Params
Specifies a hashtable of key-value pairs to include in the JSON object. 
The keys in the hashtable will be used as the property names in the JSON object.

.EXAMPLE
PS C:\> $params = @{
    "Password" = "P@ssw0rd"
    "Username" = "MyUsername"
    "StudentID" = "568566"
}
PS C:\> New-SecuredJSONDynamic -Filepath "D:\Code\Repos\LD\PowerShell LD\WolfPack\Dev\test4.json" -Params $params

This example creates a new JSON file at the specified file path with the specified key-value pairs.

.NOTES
Author: thebleak@2023
Version: 1.0
#>
function New-SecuredJSONDynamic {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Filepath,
        [Parameter(Mandatory=$true)]
        [hashtable]$Params
    )
    
    # Create JSON object
    $Json = @{}
    foreach ($key in $Params.Keys) {
        if ($Params[$key]) {
            $Json.$key = (ConvertTo-SecureString -String $Params[$key] -AsPlainText -Force) | ConvertFrom-SecureString
        }
    }

    # Convert the JSON object to a string
    $JsonString = $Json | ConvertTo-Json

    # Write JSON object to file
    $JsonString | Out-File -FilePath $Filepath
    Write-Host "Exported JSON to $Filepath"
}

$params = @{
    "Password" = "P@ssw0rd"
    "Username" = "MyUsername"
    "StudentID" = "568566"
}


# $params = @{"Password" = "P@ssw0rd"}

New-SecuredJSONDynamic -Filepath "D:\Code\Repos\LD\PowerShell LD\WolfPack\Dev\test4.json" -Params $params


<#
.SYNOPSIS
Reads a JSON file containing secure data and returns an object with decrypted properties.

.DESCRIPTION
The Read-SecuredJSON function reads a JSON file containing secure data and returns an object with decrypted properties. 
The function decrypts the secure data in the JSON file and returns the decrypted values as plain text.

.PARAMETER Path
Specifies the path to the JSON file containing the secure data. The file must have a .json extension.

.EXAMPLE
Plain text values
PS C:\> $data = Read-SecuredJSON -Path "D:\Code\test4.json"
PS C:\> $Password = $data.Password

Convert plain text values to secure strings
$Data = Read-SecuredJSON -Path "D:\Code\test4.json"
$Password = $data.Password | ConvertTo-SecureString -AsPlainText -Force

This example reads the secure data from the "test4.json" file and sets the `$Password` variable to the decrypted value of the "Password" property.

.NOTES
Author: thebleak@2023
Version: 1.0
#>
function Read-SecuredJSON {
    [cmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ -PathType Leaf -Include "*.json" })]
        [string]$Path
    )

    $json = get-content $Path | ConvertFrom-Json

    $SecuredData = [PSCustomObject]@{}
    foreach ($property in $json.PSObject.Properties) {
        if ([string]::IsNullOrWhiteSpace($property.Value) -eq $false) {
            $SecuredData | Add-Member -MemberType NoteProperty -Name $property.Name -Value ([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR(($property.Value | ConvertTo-SecureString))))
        }
    }
    return $SecuredData
} # $Data = Read-SecuredJSON -Path "D:\Code\test4.json"







