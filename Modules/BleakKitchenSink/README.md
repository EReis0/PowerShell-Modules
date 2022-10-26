- [BleakKitchenSink](#bleakkitchensink)
  - [Get-AskUserYNQuestion](#get-askuserynquestion)
  - [Get-Folder](#get-folder)
  - [Get-CSVFilePath](#get-csvfilepath)
  - [Convert-CSVtoHTML](#convert-csvtohtml)
- [Change Log](#change-log)
  - [Automated PSM Building | 10/25/2022](#automated-psm-building--10252022)
  - [New Functions | 10/12/2022](#new-functions--10122022)
  - [New Repo | 10/11/2022](#new-repo--10112022)

<br>

# BleakKitchenSink

## Get-AskUserYNQuestion

Purpose
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

Purpose
Prompt the user to select a folder in a file browser window

usage

```powershell
Get-Folder
```

## Get-CSVFilePath

Purpose
Prompt the user to select a csv file in a file browser.

Usage

```powershell
Get-CSVFilePath
```

## Convert-CSVtoHTML

Purpose
This function is a wrapper for PSWriteHTML. It will basically prompt the user with a file browser to select a CSV to convert into an HTML report.

Usage

```powershell
Convert-CSVtoHTML
```


<br>

# Change Log

<br>

## Automated PSM Building | 10/25/2022

- Created function `Join-SingleFunctionToPSM` which will import all single file functions into a single PSM file
- Added `Functions` folder under module root
- Added functions `Install-CustomModule` and `Join-SingleFunctionToPSM` into `BleakKitchenSink` Module
- Regenerated PSM file using new function
- Regenerated PSD to include new functions added

## New Functions | 10/12/2022

- Get-Folder

## New Repo | 10/11/2022

- Created Module "BleakKitchenSink"
  - Get-AskUserYNQuestion
  - Get-CSVFilePath
  - Convert-CSVtoHTML