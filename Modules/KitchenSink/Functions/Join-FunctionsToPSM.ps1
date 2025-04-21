<#
.SYNOPSIS
    Combines multiple PowerShell function files into a single module file (.psm1).

.DESCRIPTION
    The `Join-FunctionsToPSM` function creates a single PowerShell module file (.psm1) by combining all `.ps1` files from a specified folder. 
    The resulting `.psm1` file will have the same name as the root folder and will include all the functions from the specified folder. 
    Each function definition in the `.psm1` file will be separated by two blank lines for readability.

    If a `.psm1` file with the same name already exists, the function creates a backup of the existing file with a `.bak` extension before overwriting it. 
    If a `.bak` file already exists, it will be removed and replaced with the latest backup.

.PARAMETER RootDir
    Specifies the root folder path of the module/project. This is the folder where the `.psm1` file will be created.
    The name of the `.psm1` file will match the name of this folder.

.PARAMETER FunctionsDir
    Specifies the name of the folder within the root directory that contains the `.ps1` function files.
    The default value is "Functions". This parameter can be a relative or absolute path.

.EXAMPLE
    Join-FunctionsToPSM -RootDir "C:\Github\ProjectSample" -FunctionsDir "Functions"
    This example creates a `.psm1` file in the `C:\Github\ProjectSample` folder by combining all `.ps1` files in the `Functions` subfolder.

.EXAMPLE
    Join-FunctionsToPSM -RootDir "C:\Modules\MyModule"
    This example creates a `.psm1` file in the `C:\Modules\MyModule` folder by combining all `.ps1` files in the default `Functions` subfolder.

.EXAMPLE
    Join-FunctionsToPSM -RootDir "D:\Projects\MyModule" -FunctionsDir "CustomFunctions" -Verbose
    This example creates a `.psm1` file in the `D:\Projects\MyModule` folder by combining all `.ps1` files in the `CustomFunctions` subfolder.
    The `-Verbose` switch provides detailed output during the function's execution.

.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.2
    Date: 4/21/2025

.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
function Join-FunctionsToPSM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$RootDir,

        [Parameter(Mandatory = $false)]
        [string]$FunctionsDir = "Functions"
    )

    # Validate Parameter $RootDir
    try {
        $RootDir = Resolve-Path -Path $RootDir -ErrorAction Stop
        $RootDirName = (Get-Item -Path $RootDir).Name
        Write-Verbose "Resolved root directory: $RootDir"
    } catch {
        throw "Invalid path: $RootDir. Error: $($_.Exception.Message)"
    }
    
    # Validate Parameter $FunctionsDir
    $FunctionsDir = Join-Path -Path $RootDir -ChildPath $FunctionsDir
    if (-not (Test-Path $FunctionsDir)) {
        throw "Functions directory does not exist: $FunctionsDir"
    }
    Write-Verbose "Resolved functions directory: $FunctionsDir"

    # Create PSM file path
    $FullPSMPath = Join-Path -Path $RootDir -ChildPath "$RootDirName.psm1"
    Write-Verbose "Output PSM file path: $FullPSMPath"

    # Check if the PSM file already exists and back it up if it does
    if (Test-Path $FullPSMPath) {
        $BackupPath = "$FullPSMPath.bak"
        if (Test-Path $BackupPath) {
            Remove-Item -Path $BackupPath -Force
            Write-Verbose "Existing backup file removed: $BackupPath"
        }
        Copy-Item -Path $FullPSMPath -Destination $BackupPath -Force
        Write-Verbose "Existing PSM file backed up to: $BackupPath"
    }

    # Initialize StringBuilder to store function content
    $ResultBuilder = [System.Text.StringBuilder]::new()

    # Get all .ps1 files in the functions directory
    $Ps1Files = Get-ChildItem -Path $FunctionsDir -Recurse -Filter *.ps1 -File | Sort-Object Name
    if (-not $Ps1Files) {
        throw "No .ps1 files found in the functions directory: $FunctionsDir. Ensure the directory contains valid PowerShell function files."
    }
    
    # Read the content of each .ps1 file and append it to the StringBuilder
    foreach ($File in $Ps1Files) {
        $FileContent = Get-Content $File.FullName -Raw
        $null = $ResultBuilder.AppendLine($FileContent) # Append the file content
        $null = $ResultBuilder.AppendLine() # Add a blank line
        $null = $ResultBuilder.AppendLine() # Add another blank line
    }

    # Export the functions to the PSM file
    try {
        Set-Content -Value $ResultBuilder.ToString() -Path $FullPSMPath -Encoding UTF8
    } catch {
        throw "Failed to write to file: $FullPSMPath. Error: $($_.Exception.Message)"
    }
    Write-Host "PSM file created successfully: $FullPSMPath" -ForegroundColor Green
} # Join-FunctionsToPSM -RootDir "D:\Code\Repos\PowerShell-Modules\Modules\KitchenSink"