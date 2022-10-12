- [BleakKitchenSink](#bleakkitchensink)
  - [Get-AskUserYNQuestion](#get-askuserynquestion)
  - [Get-CSVFilePath](#get-csvfilepath)
  - [Convert-CSVtoHTML](#convert-csvtohtml)
- [Change Log](#change-log)
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

## New Repo | 10/11/2022

- Created Module "BleakKitchenSink"
  - Get-AskUserYNQuestion
  - Get-CSVFilePath
  - Convert-CSVtoHTML