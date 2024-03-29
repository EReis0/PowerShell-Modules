- [KitchenSink](#kitchensink)
  - [Get-AskUserYNQuestion](#get-askuserynquestion)
    - [Usage](#usage)
    - [Example Output](#example-output)
  - [Get-Folder](#get-folder)
    - [usage](#usage-1)
  - [Get-CSVFilePath](#get-csvfilepath)
    - [Usage](#usage-2)
  - [Convert-CSVtoHTML](#convert-csvtohtml)
    - [Usage](#usage-3)
  - [Install-CustomModule](#install-custommodule)
    - [Usage](#usage-4)
  - [Join-FunctionsToPSM](#join-functionstopsm)
    - [Usage](#usage-5)
  - [New-CredsTxtFile](#new-credstxtfile)
    - [Usage](#usage-6)
    - [Example](#example)
  - [Get-ModuleUpdates](#get-moduleupdates)
    - [Usage](#usage-7)
    - [Example Output](#example-output-1)
  - [Convert-Timestamp](#convert-timestamp)
    - [Usage](#usage-8)
    - [Example Output](#example-output-2)
  - [New-SecuredJSONStatic](#new-securedjsonstatic)
    - [Example Output](#example-output-3)
  - [New-SecuredJSON](#new-securedjson)
    - [Example Output](#example-output-4)
  - [Read-SecuredJSON](#read-securedjson)
    - [Usage](#usage-9)
      - [Plain text values](#plain-text-values)
      - [Convert plain text values to secure strings](#convert-plain-text-values-to-secure-strings)
  - [Invoke-Speech](#invoke-speech)
    - [Usage](#usage-10)
  - [Get-GithubProject](#get-githubproject)
    - [Usage](#usage-11)
- [Change Log](#change-log)
  - [Updates | 2/2024](#updates--22024)
  - [Updates | 10/2023](#updates--102023)
  - [Updates | 9/2023](#updates--92023)
  - [Updates | 08/2023](#updates--082023)
  - [Automated PSM Building | 10/25/2022](#automated-psm-building--10252022)
  - [New Functions | 10/12/2022](#new-functions--10122022)
  - [New Repo | 10/11/2022](#new-repo--10112022)

<br>

# KitchenSink

Custom functions created that has helped me along the way.

<br>

## Get-AskUserYNQuestion

Just a simple way to toss a system controlled yes/no question to the user.

### Usage

```powershell
Get-AskUserYNQuestion -Question 'Are you ready?
```

### Example Output

```
Are you ready?
Choices:
[Y] Yes  [N] No  [?] Help (default is "Y"): y
Yes
```

<br>

## Get-Folder

Prompt the user to select a folder in a file browser window

### usage

```powershell
Get-Folder
```

<br>

## Get-CSVFilePath

Prompt the user to select a CSV file in a file browser to obtain a path to a csv file

### Usage

```powershell
Get-CSVFilePath
```

<br>

## Convert-CSVtoHTML

This function is a wrapper for [PSWriteHTML](https://www.powershellgallery.com/packages/PSWriteHTML/). It will basically prompt the user with a file browser to select a CSV to convert into an HTML report.

### Usage

```powershell
Convert-CSVtoHTML
```

<br>

## Install-CustomModule

> Must be executed in PowerShell administrator mode.

Installing custom modules can be a little tricky, so this function was created to assist. It takes the module and copies it to the PowerShell module directory. Then it creates a PowerShell profile if one does not already exist. Next it will check the PowerShell profile for the specific module and updates the profile if it's missing. 

Once it is completed you can use commands like `get-module` and `get-command` without needing to import the module in a script first.

### Usage

```powershell
Install-CustomModule -ModuleName KitchenSink
```

<br>

## Join-FunctionsToPSM

Takes a folder that contains .ps1 files for all module functions and automatically builds a single PSM1 file (Not dot sourced).
Makes the process of updating and adding new functions to the module with ease and fewer steps to finish.

### Usage

```powershell
Join-FunctionsToPSM -RootFolder "C:\Github\ProjectSample" -FunctionDir "Functions"
```

<br>

## New-CredsTxtFile

The `New-CredsTxtFile` is a PowerShell function that is used to create a secure password file or validate a password against an existing file.

### Usage

To create a new password file, use the `-Filepath` parameter to specify the path where the password file will be saved. 
The function will prompt you to enter a password which will then be saved to the specified file.

```powershell
New-CredsTxtFile -Filepath "C:\creds\creds.txt"
```

To validate a password against an existing file, use the `-Filepath` parameter to specify the path of the password file and the `-ValidateOnly` parameter set to `$true`. The function will prompt you to enter a password which will then be compared to the password in the specified file.

```powershell
New-CredsTxtFile -Filepath "C:\creds\creds.txt" -ValidateOnly $true
```

### Example

- `New-CredsTxtFile -Filepath "C:\creds\creds.txt"` = New credential file created
- `New-CredsTxtFile -Filepath "C:\creds\creds.txt" -ValidateOnly $true` = No new file created, validate the password provided to the encrypted password on the file.

<br>

## Get-ModuleUpdates

Check your [PSGallery](https://www.powershellgallery.com/) Installed-Modules for updates. Return modules that are outdated with links.

### Usage

```powershell
Get-ModuleUpdates
```

### Example Output

```
Name             : Carbon
UpdateAvailable  : True
InstalledVersion : 2.13.0
Version          : 2.15.1
PublishedDate    : 8/18/2023 6:53:24 PM
Link             : https://www.powershellgallery.com/packages/Carbon       

Name             : PSSharedGoods
UpdateAvailable  : True
InstalledVersion : 0.0.264
Version          : 0.0.266
PublishedDate    : 9/18/2023 6:20:41 AM
Link             : https://www.powershellgallery.com/packages/PSSharedGoods
```

<br>

## Convert-Timestamp

Convert timestamps from `Windows Time File` or `UNIX` into a readable format. 

### Usage

```powershell
Convert-TimeStamp -timestamp 128271382742968750
```

### Example Output

```
6/23/2007 10:57:54 PM
```

<br>

## New-SecuredJSONStatic

This function will take each parameter value and encrypt it and export the key, value pairs into a JSON file to the `-FilePath` location.
It also has static parameter values that can be selected. If custom values are needed, use the [New-SecuredJSONDynamic](#new-securedjson) version. 

```powershell
New-SecuredJSONStatic -Filepath "D:\Code\test5.json" -Password "P@ssw0rd" -Username "MyUsername" -Email "jdoe@sample.com"
```

### Example Output

Will output a JSON file like this. I replaced the encrypted value with `"<Encrypted>"`.

```json
{
    "Username": "<Encrypted>",
    "Email": "<Encrypted>",
    "Password": "<Encrypted>"
}
```

<br>

## New-SecuredJSON

This function has dynamic parameters, in order to execute this function you need to pass it the `-FilePath` and at least one `-Params`.
It will then encrypt the values to the parameters defined and output the results into a JSON file. 

```powershell
$params = @{
    "Password" = "P@ssw0rd"
    "Username" = "MyUsername"
    "StudentID" = "568566"
}

New-SecuredJSON -Filepath "D:\Code\test4.json" -Params $params
```

### Example Output

Will output a JSON file like this. I replaced the encrypted value with `"<Encrypted>"`.

```json
{
    "Username": "<Encrypted>",
    "Password": "<Encrypted>",
    "StudentID": "<Encrypted>"
}
```

<br>

## Read-SecuredJSON

Reads the Secured JSON file which was created with [New-SecuredJSONStatic](#new-securedjsonstatic) or [New-SecuredJSON](#new-securedjsondynamic)
and converts the encrypted values into plan text. 

### Usage

#### Plain text values

```powershell
$data = Read-SecuredJSON -Path "D:\Code\test4.json"
$Password = $data.Password
```

#### Convert plain text values to secure strings

```powershell
$Data = Read-SecuredJSON -Path "D:\Code\test4.json"
$Password = $data.Password | ConvertTo-SecureString -AsPlainText -Force
```

<br>

## Invoke-Speech

The Invoke-Speech function speaks the specified text using the default system settings. You can specify the speed, volume, and voice of the speech, and you can generate a PowerShell script that reproduces the speech settings.

### Usage

```powershell
# This example speaks the text "Hello, world!" using the default system settings.
Invoke-Speech -Text "Hello, world!"
```

```powershell
# This example speaks the text "Hello, world!" using the Microsoft David Desktop voice, at a speed of 200 words per minute and a volume of 50%.
Invoke-Speech -Text "Hello, world!" -Speed 200 -Volume 50 -Voice "Microsoft David Desktop"
```

```powershell
# This example speaks the text "Hello, world!" and generates a PowerShell script that reproduces the speech settings.
Invoke-Speech -Text "Hello, world!" -Generate
```

```powershell
# This example speaks the text "Hello, world!" and returns a hash table of the speech settings.
Invoke-Speech -Text "Hello, world!" -Resume
```

<br>

## Get-GithubProject

Download a GitHub project as a .zip and decompress the files to a specific path.

### Usage

```powershell
Get-GithubProject -url "https://github.com/EReis0/PowerShell-Modules/archive/refs/heads/main.zip" -output "C:\Users\jdoe\Documents\"
```

<br>

# Change Log

<br>

## Updates | 2/2024

- `Convert-Timestamp`
  - Retired function `Convert-UTCTimestamp` and recreated the vision as a new function.
  - Added logic to convert timestamps for windows (active directory). Stopped converting time to Windows NT and started converting the time based on "Windows Time File". 
  - Included logic that would convert Unix time stamps
  - Switch added to automatically detect if windows time file or Unix timestamp is being used and convert to readable format.
- `New-CredsTxtFile`
  - Fixed bug where sometimes validation only was overwriting the file instead of validating only
  - Instead of passing the password in plan text, it will prompt using get-credential instead. Username is not required.
  - Updated Get-help comments to better explain how the -validationOnly works in the function.
- `Test-WebsiteStatus`
  - Fixed bug where function would return a site is offline when it was online. Now it should reflect properly.

## Updates | 10/2023

- New Functions
  - `New-SecuredJSON` that takes static parameters, encrypts the values and exports a secured JSON File.
  - `New-SecuredJSONDynamic` that takes Dynamic parameters, encrypts the values and exports a secured JSON File.
  - `Read-SecuredJSON` that reads the JSON file from `New-SecuredJSON` or `New-SecuredJSONDynamic` and converts values into plain text.
  - `Get-GitHubProject` Download a GitHub project as a .zip and decompress it to a specified directory.
- Generated new PSM, PSD, Checksum. Updated Readme.md to include the new functions

## Updates | 9/2023

- Created a new function `Get-ModuleUpdates` that will check PSGallery Modules for updates available.
- Created a new function `Convert-UTCTimeStamp` that converts UTC time into a readable format.
- Generated new PSM, PSD, Checksum. Updated Readme.md to include the new functions

## Updates | 08/2023

- Changed function name `Join-SingleFunctionToPSM` to `Join-FunctionsToPSM`.
- Updated `Join-FunctionsToPSM` logic to 
  - Include get-help comments that are located above or within the function.
  - Add 2 new lines after each function added to the psm1 file.
- Cleaned up Get-Help comments on almost all functions.
- Renamed Module from `BleakKitchenSink` to `KitchenSink`
- Update to `Install-CustomModule` to also create a PowerShell profile and include the custom module. This allows you to `Get-Module` and `Get-Command` and access the custom module. Works well, just need to suppress some console messages.
- Created `New-CredsTxtFile` to help with creating and validating secured credentials.

## Automated PSM Building | 10/25/2022

- Created function `Join-SingleFunctionToPSM` which will import all single file functions into a single PSM file
- Added `Functions` folder under module root
- Added functions `Install-CustomModule` and `Join-SingleFunctionToPSM` into `KitchenSink` Module
- Regenerated PSM file using new function
- Regenerated PSD to include new functions added

## New Functions | 10/12/2022

- Get-Folder

## New Repo | 10/11/2022

- Created Module "KitchenSink"
  - Get-AskUserYNQuestion
  - Get-CSVFilePath
  - Convert-CSVtoHTML