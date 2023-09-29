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
  - [Get-ModuleUpdates](#get-moduleupdates)
    - [Usage](#usage-7)
    - [Example Output](#example-output-1)
- [Change Log](#change-log)
  - [New function: Get-ModuleUpdates (9/2023)](#new-function-get-moduleupdates-92023)
  - [Updates | 08/2023](#updates--082023)
  - [Automated PSM Building | 10/25/2022](#automated-psm-building--10252022)
  - [New Functions | 10/12/2022](#new-functions--10122022)
  - [New Repo | 10/11/2022](#new-repo--10112022)

<br>

# KitchenSink

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

## Get-Folder

Prompt the user to select a folder in a file browser window

### usage

```powershell
Get-Folder
```

## Get-CSVFilePath

Prompt the user to select a CSV file in a file browser to obtain a path to a csv file

### Usage

```powershell
Get-CSVFilePath
```

## Convert-CSVtoHTML

This function is a wrapper for [PSWriteHTML](https://www.powershellgallery.com/packages/PSWriteHTML/0.0.158). It will basically prompt the user with a file browser to select a CSV to convert into an HTML report.

### Usage

```powershell
Convert-CSVtoHTML
```

## Install-CustomModule

> Must be executed in PowerShell administrator mode.

Installing custom modules can be a little tricky, so this function was created to assist. It takes the module and copies it to the PowerShell module directory. Then it creates a PowerShell profile if one does not already exist. Next it will check the PowerShell profile for the specific module and updates the profile if it's missing. 

Once it is completed you can use commands like `get-module` and `get-command` without needing to import the module in a script first.

### Usage

```powershell
Install-CustomModule -ModuleName KitchenSink
```

## Join-FunctionsToPSM

Takes a folder that contains .ps1 files for all module functions and automatically builds a single PSM1 file (Not dot sourced).
Makes the process of updating and adding new functions to the module with ease and fewer steps to finish.

### Usage

```powershell
Join-FunctionsToPSM -RootFolder "C:\Github\ProjectSample" -FunctionDir "Functions"
```

## New-CredsTxtFile

Use this to generate a new secure credential file but also verify the file was generated correctly. You can also use this to verify the password that is in the file. 

### Usage

This will create a new creds file and verify it once it's created

```powershell
New-CredsTxtFile -Filepath "C:\creds\creds.txt" -Password "P@ssw0rd"
```

This will not create a new creds file. It only validates the current file.

```powershell
New-CredsTxtFile -Filepath "C:\Temp\password.txt" -Password "MyPassword123" -ValidateOnly
```

## Get-ModuleUpdates

Check your PSGallery Installed-Modules for updates. Return modules that are outdated with links.

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

# Change Log

<br>

## New function: Get-ModuleUpdates (9/2023)

- Created a new function `Get-ModuleUpdates` that will check PSGallery Modules for updates available.
- Generated new PSM, PSD, Checksum.
- Updated Readme.md to include the new function


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