- [BleakKitchenSink](#bleakkitchensink)
  - [Get-AskUserYNQuestion](#get-askuserynquestion)
  - [Get-Folder](#get-folder)
  - [Get-CSVFilePath](#get-csvfilepath)
  - [Convert-CSVtoHTML](#convert-csvtohtml)
  - [Install-CustomModule](#install-custommodule)
  - [Join-SingleFunctionsToPSM](#join-singlefunctionstopsm)
- [CheckSums (SHA256Sum)](#checksums-sha256sum)
- [Change Log](#change-log)
  - [Automated PSM Building | 10/25/2022](#automated-psm-building--10252022)
  - [New Functions | 10/12/2022](#new-functions--10122022)
  - [New Repo | 10/11/2022](#new-repo--10112022)

<br>

# BleakKitchenSink

## Get-AskUserYNQuestion

Purpose <br>
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

Purpose <br>
Prompt the user to select a folder in a file browser window

usage

```powershell
Get-Folder
```

## Get-CSVFilePath

Purpose <br>
Prompt the user to select a csv file in a file browser to obtain a path to a csv file

Usage

```powershell
Get-CSVFilePath
```

## Convert-CSVtoHTML

Purpose <br>
This function is a wrapper for [PSWriteHTML](https://www.powershellgallery.com/packages/PSWriteHTML/0.0.158). It will basically prompt the user with a file browser to select a CSV to convert into an HTML report.

Usage

```powershell
Convert-CSVtoHTML
```

## Install-CustomModule

Purpose <br>
Install custom modules automatically into the current users PowerShell module path.

```powershell
Install-CustomModule -ModuleName BleaksKitchenSink
```

## Join-SingleFunctionsToPSM

Purpose <br>
Takes a folder that contains .ps1 files for all module functions and automatically builds a single PSM1 file (Not dot sourced).
Makes the process of updating and adding new functions to the module with ease and fewer steps to finish.

```powershell
Join-SingleFunctionsToPSM -RootFolder "C:\Github\ProjectSample" -FunctionFolderName "Functions"
```

<br>

# CheckSums (SHA256Sum)

- BleakKitchenSink.psm1 `9fda5b6f6e67c394a1ac448c8fb1be488d2d75236d2656d0a42014cf1c0bd3b1`
- BleakKitchenSink.psd1 `2b1ca2ed0a8775ee951874196e59efed22998f96472546235bdc3d9fca2a441e`

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