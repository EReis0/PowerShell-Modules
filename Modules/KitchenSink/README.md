- [KitchenSink](#kitchensink)
  - [Get-AskUserYNQuestion](#get-askuserynquestion)
    - [Usage](#usage)
    - [Example Output](#example-output)
  - [Get-Folder](#get-folder)
    - [Usage](#usage-1)
  - [Get-CSVFilePath](#get-csvfilepath)
    - [Usage](#usage-2)
  - [Convert-CSVtoHTML](#convert-csvtohtml)
    - [Usage](#usage-3)
  - [Install-CustomModule](#install-custommodule)
    - [Parameters](#parameters)
    - [Usage](#usage-4)
    - [Additional Notes](#additional-notes)
  - [Join-FunctionsToPSM](#join-functionstopsm)
    - [Features](#features)
    - [Parameters](#parameters-1)
    - [Usage](#usage-5)
    - [Additional Notes](#additional-notes-1)
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
      - [Plain Text Values](#plain-text-values)
      - [Convert Plain Text Values to Secure Strings](#convert-plain-text-values-to-secure-strings)
  - [Invoke-Speech](#invoke-speech)
    - [Usage](#usage-10)
  - [Get-GithubProject](#get-githubproject)
    - [Usage](#usage-11)
  - [Convert-TOTPToMFA](#convert-totptomfa)
    - [Parameters](#parameters-2)
    - [Usage](#usage-12)
    - [Example Output](#example-output-5)
    - [Notes](#notes)

<br>

# KitchenSink

Custom functions created that have helped me along the way.

<br>

## Get-AskUserYNQuestion

Just a simple way to toss a system-controlled yes/no question to the user.

### Usage

```powershell
Get-AskUserYNQuestion -Question 'Are you ready?'
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

Prompt the user to select a folder in a file browser window.

### Usage

```powershell
Get-Folder
```

<br>

## Get-CSVFilePath

Prompt the user to select a CSV file in a file browser to obtain a path to a `CSV` file.

### Usage

```powershell
Get-CSVFilePath
```

<br>

## Convert-CSVtoHTML

This function is a wrapper for [PSWriteHTML](https://www.powershellgallery.com/packages/PSWriteHTML/). It will prompt the user with a file browser to select a CSV to convert into an HTML report.

### Usage

```powershell
Convert-CSVtoHTML
```

<br>

## Install-CustomModule

> Must be executed in PowerShell administrator mode.

The `Install-CustomModule` function simplifies the process of installing PowerShell modules by automating the following steps:
- Copying the module to the appropriate module directory based on the `UserLevel` parameter.
- Adding the module to the user's PowerShell profile for automatic loading in future sessions.
- Optionally unblocking unsigned scripts if the `-Unblock` parameter is specified.

### Parameters

- **`-InputDir`**: Specifies the path of the module to install. This is a mandatory parameter and should point to the folder containing the module files.
- **`-UserLevel`**: Specifies the level of the user for which the module should be installed. Valid values are:
  - `'Single'`: Installs the module for the current user only.
  - `'All'`: Installs the module for all users on the system.
  The default value is `'All'`.
- **`-Unblock`**: Optional switch to unblock the module script if it is not signed.

### Usage

```powershell
# Install the module for all users
Install-CustomModule -InputDir "C:\Path\To\Module" -UserLevel "All"

# Install the module for the current user only
Install-CustomModule -InputDir "C:\Path\To\Module" -UserLevel "Single"

# Install the module for all users and unblock unsigned scripts
Install-CustomModule -InputDir "C:\Path\To\Module" -UserLevel "All" -Unblock
```

### Additional Notes

- The function ensures the module is imported into the user's PowerShell profile for automatic loading in future sessions. If the profile does not exist, it will create one.
- If submodules (additional `.psm1` files) are found within the module directory, they will also be added to the profile and imported.
- The function validates the installation by checking if the module and its commands are successfully imported.
- If the `-Unblock` parameter is used, the function will check the script's signature and unblock it if it is not signed.

<br>

## Join-FunctionsToPSM

The `Join-FunctionsToPSM` function creates a single PowerShell module file (`.psm1`) by combining all `.ps1` files from a specified folder. It ensures that the resulting `.psm1` file is well-structured and includes all the functions from the specified folder. Each function definition in the `.psm1` file is separated by two blank lines for readability.

### Features

- Combines all `.ps1` files in the specified folder into a single `.psm1` file.
- Automatically creates a backup of an existing `.psm1` file with a `.bak` extension before overwriting it.
- Validates the existence of the root directory and functions directory.
- Ensures the `.psm1` file is encoded in UTF-8 for compatibility.

### Parameters

- **`-RootDir`**: Specifies the root folder path of the module/project. This is the folder where the `.psm1` file will be created. The name of the `.psm1` file will match the name of this folder.
- **`-FunctionsDir`**: Specifies the name of the folder within the root directory that contains the `.ps1` function files. The default value is `"Functions"`. This parameter can be a relative or absolute path.

### Usage

```powershell
# Combine all .ps1 files in the "Functions" folder into a single .psm1 file
Join-FunctionsToPSM -RootDir "C:\Github\ProjectSample" -FunctionsDir "Functions"

# Combine all .ps1 files in a custom folder into a single .psm1 file
Join-FunctionsToPSM -RootDir "D:\Projects\MyModule" -FunctionsDir "CustomFunctions"
```

### Additional Notes

- If no `.ps1` files are found in the specified functions directory, the function will throw an error.
- If a `.psm1` file with the same name already exists, it will be backed up with a `.bak` extension. If a `.bak` file already exists, it will be replaced with the latest backup.
- The resulting `.psm1` file will include all functions, separated by two blank lines for readability.
- The function validates the paths provided for the root directory and functions directory to ensure they exist.
- The `.psm1` file is written with UTF-8 encoding to ensure compatibility across systems.

<br>

## New-CredsTxtFile

The `New-CredsTxtFile` function is used to create a secure password file or validate a password against an existing file.

### Usage

To create a new password file, use the `-Filepath` parameter to specify the path where the password file will be saved. The function will prompt you to enter a password, which will then be saved to the specified file.

```powershell
New-CredsTxtFile -Filepath "C:\creds\creds.txt"
```

To validate a password against an existing file, use the `-Filepath` parameter to specify the path of the password file and the `-Validate` parameter. The function will prompt you to enter a password, which will then be compared to the password in the specified file.

```powershell
New-CredsTxtFile -Filepath "C:\creds\creds.txt" -Validate
```

### Example

- `New-CredsTxtFile -Filepath "C:\creds\creds.txt"`: New credential file created.
- `New-CredsTxtFile -Filepath "C:\creds\creds.txt" -Validate`: No new file created; validates the password provided against the encrypted password in the file.

<br>

## Get-ModuleUpdates

Check your [PSGallery](https://www.powershellgallery.com/) installed modules for updates. Returns modules that are outdated with links.

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
Convert-TimeStamp -Timestamp 128271382742968750
```

### Example Output

```
6/23/2007 10:57:54 PM
```

<br>

## New-SecuredJSONStatic

This function encrypts each parameter value and exports the key-value pairs into a JSON file at the `-FilePath` location. It also has static parameter values that can be selected. If custom values are needed, use the [New-SecuredJSON](#new-securedjson) version. 

```powershell
New-SecuredJSONStatic -Filepath "D:\Code\test5.json" -Password "P@ssw0rd" -Username "MyUsername" -Email "jdoe@sample.com"
```

### Example Output

Outputs a JSON file like this (encrypted values replaced with `"<Encrypted>"`):

```json
{
    "Username": "<Encrypted>",
    "Email": "<Encrypted>",
    "Password": "<Encrypted>"
}
```

<br>

## New-SecuredJSON

This function has dynamic parameters. To execute it, pass the `-FilePath` and at least one `-Params`. It encrypts the parameter values and outputs the results into a JSON file. 

```powershell
$params = @{
    "Password" = "P@ssw0rd"
    "Username" = "MyUsername"
    "StudentID" = "568566"
}

New-SecuredJSON -Filepath "D:\Code\test4.json" -Params $params
```

### Example Output

Outputs a JSON file like this (encrypted values replaced with `"<Encrypted>"`):

```json
{
    "Username": "<Encrypted>",
    "Password": "<Encrypted>",
    "StudentID": "<Encrypted>"
}
```

<br>

## Read-SecuredJSON

Reads the secured JSON file created with [New-SecuredJSONStatic](#new-securedjsonstatic) or [New-SecuredJSON](#new-securedjson) and converts the encrypted values into plain text. 

### Usage

#### Plain Text Values

```powershell
$data = Read-SecuredJSON -Path "D:\Code\test4.json"
$Password = $data.Password
```

#### Convert Plain Text Values to Secure Strings

```powershell
$Data = Read-SecuredJSON -Path "D:\Code\test4.json"
$Password = $data.Password | ConvertTo-SecureString -AsPlainText -Force
```

<br>

## Invoke-Speech

The `Invoke-Speech` function speaks the specified text using the default system settings. You can specify the speed, volume, and voice of the speech, and you can generate a PowerShell script that reproduces the speech settings.

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

Download a GitHub project as a `.zip` and decompress the files to a specific path.

### Usage

```powershell
Get-GithubProject -Url "https://github.com/EReis0/PowerShell-Modules/archive/refs/heads/main.zip" -Output "C:\Users\jdoe\Documents\"
```

<br>

## Convert-TOTPToMFA

The `Convert-TOTPToMFA` function generates a Time-based One-Time Password (TOTP) code based on the provided secret, period, number of digits, and algorithm. It is useful for generating MFA (Multi-Factor Authentication) codes.

### Parameters

- **`-Secret`**: The Base32 encoded TOTP secret. This parameter is mandatory.
- **`-Period`**: The time period in seconds for the TOTP code. The default is `30` seconds.
- **`-Digits`**: The number of digits for the TOTP code. The default is `6` digits.
- **`-Algorithm`**: The hashing algorithm to use for generating the HMAC hash. Supported algorithms are `"SHA1"`, `"SHA256"`, and `"SHA512"`. The default is `"SHA1"`.

### Usage

```powershell
# Generate a 6-digit TOTP code using the provided secret, a 30-second period, and the SHA1 algorithm
$TOTPSecret = "JBSWY3DPEHPK3PXP"
$MFA = Convert-TOTPToMFA -Secret $TOTPSecret -Period 30 -Digits 6 -Algorithm "SHA1"
Write-Host "Generated TOTP Code: $MFA"
```

### Example Output

```
Generated TOTP Code: 123456
```

### Notes

- If the generated MFA code is not valid, ensure your system clock is synchronized with an NTP server.
  - Check synchronization status: `w32tm /query /status`
  - Start the Windows Time service if not running: `Start-Service w32time`
  - Resynchronize the system clock: `w32tm /resync`
  - Verify synchronization status again: `w32tm /query /status`
- This function is based on the TOTP algorithm described in [RFC 6238](https://tools.ietf.org/html/rfc6238).
