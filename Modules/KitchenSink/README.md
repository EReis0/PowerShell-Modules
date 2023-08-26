- [KitchenSink](#kitchensink)
  - [Get-AskUserYNQuestion](#get-askuserynquestion)
  - [Get-Folder](#get-folder)
  - [Get-CSVFilePath](#get-csvfilepath)
  - [Convert-CSVtoHTML](#convert-csvtohtml)
  - [Install-CustomModule](#install-custommodule)
  - [Join-FunctionsToPSM](#join-functionstopsm)
- [Change Log](#change-log)
  - [Updates | 08/2023](#updates--082023)
  - [Automated PSM Building | 10/25/2022](#automated-psm-building--10252022)
  - [New Functions | 10/12/2022](#new-functions--10122022)
  - [New Repo | 10/11/2022](#new-repo--10112022)

<br>

# KitchenSink

## Get-AskUserYNQuestion

Just a simple way to toss a system controlled yes/no question to the user.

Usage

```powershell
Get-AskUserYNQuestion -Question 'Are you ready?
```

Example Output
```
Are you ready?
Choices:
[Y] Yes  [N] No  [?] Help (default is "Y"): y
Yes
```

## Get-Folder

Prompt the user to select a folder in a file browser window

usage

```powershell
Get-Folder
```

## Get-CSVFilePath

Prompt the user to select a csv file in a file browser to obtain a path to a csv file

Usage

```powershell
Get-CSVFilePath
```

## Convert-CSVtoHTML

This function is a wrapper for [PSWriteHTML](https://www.powershellgallery.com/packages/PSWriteHTML/0.0.158). It will basically prompt the user with a file browser to select a CSV to convert into an HTML report.

Usage

```powershell
Convert-CSVtoHTML
```

## Install-CustomModule

Install custom modules automatically into the current users PowerShell module path.

```powershell
Install-CustomModule -ModuleName KitchenSink
```

## Join-FunctionsToPSM

Takes a folder that contains .ps1 files for all module functions and automatically builds a single PSM1 file (Not dot sourced).
Makes the process of updating and adding new functions to the module with ease and fewer steps to finish.

```powershell
Join-FunctionsToPSM -RootFolder "C:\Github\ProjectSample" -FunctionDir "Functions"
```

<br>

# Change Log

<br>

## Updates | 08/2023

- Changed function name `Join-SingleFunctionToPSM` to `Join-FunctionToPSM`.
- Updated `Join-FunctionToPSM` logic to 
  - Include get-help comments that are located above or within the function.
  - Add 2 new lines after each function added to the psm1 file.
- Cleaned up Get-Help comments on almost all functions.
- Renamed Module from `BleakKitchenSink` to `KitchenSink`

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