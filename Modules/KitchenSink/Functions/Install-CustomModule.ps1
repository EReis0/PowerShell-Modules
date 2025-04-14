<#
.SYNOPSIS
    Installs a custom PowerShell module to the appropriate module directory.

.DESCRIPTION
    This function installs a custom PowerShell module by copying the module folder from the specified input directory 
    to the appropriate module directory based on the user level. It also ensures the module is imported into the user's 
    PowerShell profile for automatic loading in future sessions. Optionally, it can unblock unsigned scripts.

.PARAMETER InputDir
    Specifies the path of the module to install. This parameter is mandatory and should point to the folder containing 
    the module files.

.PARAMETER UserLevel
    Specifies the level of the user for which the module should be installed. 
    Valid values are:
        - 'Single': Installs the module for the current user only.
        - 'All': Installs the module for all users on the system.
    The default value is 'All'.

.PARAMETER Unblock
    Indicates whether to unblock the module script if it is not signed. This parameter is optional. 
    If specified, the script will check the signature status of the module and unblock it if necessary.

.EXAMPLE
    Install-CustomModule -InputDir "C:\Users\JohnDoe\Downloads\MyModule" -UserLevel "All"
    Installs the "MyModule" module from the specified input directory to the module directory for all users.

.EXAMPLE
    Install-CustomModule -InputDir "C:\Users\JohnDoe\Downloads\MyModule" -UserLevel "Single"
    Installs the "MyModule" module from the specified input directory to the module directory for the current user only.

.EXAMPLE
    Install-CustomModule -InputDir "C:\Users\JohnDoe\Downloads\MyModule" -UserLevel "All" -Unblock
    Installs the "MyModule" module for all users and unblocks the script if it is not signed.

.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.4
    Date: 04/2025

    This script simplifies the process of installing PowerShell modules by automating the following steps:
        - Copying the module to the appropriate module directory.
        - Adding the module to the user's PowerShell profile for automatic loading.
        - Unblocking unsigned scripts if requested.

    While this script is useful for automating module installation, you can also manually copy the module folder 
    to the module directory (e.g., 'C:\Program Files\WindowsPowerShell\Modules') and add the `Import-Module` command 
    to your profile.

.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
Function Install-CustomModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $InputDir,
        [Parameter(Mandatory=$false)]
        $UserLevel = 'All',
        [Parameter(Mandatory=$false, HelpMessage="Unblock the script if it is not signed.")]
        [switch]$Unblock
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

    $ModuleOutputPath = Join-Path -Path $WindowsPowerShellModulePath -ChildPath $ModuleName
    
    Write-Host "Copy module from $InputDir to $WindowsPowerShellModulePath" -ForegroundColor Black -BackgroundColor white

    # Check if the module is already installed
    $filecheck = test-path $ModuleOutputPath
    if ($filecheck) {
        Write-Host "Removing existing $ModuleName module from $WindowsPowerShellModulePath" -ForegroundColor Black -BackgroundColor Yellow
        Remove-Item -Path $ModuleOutputPath -Force -Recurse
    }

    # Add the directory containing the module to the PSModulePath environment variable
    $env:PSModulePath += ";$InputDir"

    # Unblock the script if the -Unblock parameter is used
    if ($Unblock) {
        Write-Host "Checking script signature and unblocking if necessary..." -ForegroundColor Yellow

        # Replace with the path to your script file
        $scriptPath = Join-Path -Path $InputDir -ChildPath "$($ModuleName).psm1"

        # Check the signature status
        $signature = Get-AuthenticodeSignature -FilePath $scriptPath

        # Display the signature status and unblock if needed
        if ($signature.Status -eq 'Valid') {
            Write-Host "The script is signed and valid." -ForegroundColor Green
        } elseif ($signature.Status -eq 'NotSigned') {
            Write-Host "The script is not signed. Unblocking the file..." -ForegroundColor Yellow
            Unblock-File -Path $scriptPath
            Write-Host "The file has been unblocked." -ForegroundColor Green
        } else {
            Write-Host "The script is signed but the signature is invalid or unknown." -ForegroundColor Red
        }
    }

    # Validate InputDir
    if (-not (Test-Path -Path $InputDir -PathType Container)) {
        Write-Host "The specified InputDir '$InputDir' does not exist or is not a directory." -ForegroundColor Red
        return
    }

    # Copy the module to the module directory
    try{
        Copy-Item -Path $InputDir -Destination $ModuleOutputPath -PassThru -Recurse -ErrorAction Stop | Out-Null
        Write-Host "$ModuleName Was successfully installed to $WindowsPowerShellModulePath" -ForegroundColor Black -BackgroundColor Green
    }catch{
        $CatchError = $_.Exception.Message
        $ErrorType = $CatchError[0].Exception.GetType().FullName
        Write-Host $CatchError -ForegroundColor Black -BackgroundColor Red
        Write-Host $ErrorType -ForegroundColor Black -BackgroundColor Red
    }

    # Run this to create the profile
    $ProfilePath = $profile.CurrentUserCurrentHost # $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
    try {
        $CheckProfile = Test-Path -Path $ProfilePath
        if ($CheckProfile -eq $false) {
            Write-Host "Creating profile at $ProfilePath" -ForegroundColor Black -BackgroundColor Yellow
            New-Item -ItemType File -Path $ProfilePath -Force
        }
    } catch {
        Write-Host "Error creating profile: $($_.Exception.Message)" -ForegroundColor Red
        return
    }

    # Check if the Import-Module command already exists in the profile
    Write-Host "Checking if $ModuleName is already imported in the profile" -ForegroundColor Black -BackgroundColor Yellow

    # If the command (for main module) does not exist, add it to the profile
    $ImportModuleCommand = "Import-Module -Name $ModuleName"
    $EscapedPattern = [regex]::Escape($ImportModuleCommand) # Escape special characters in the command
    if (-not (Select-String -Path $ProfilePath -Pattern $EscapedPattern -Quiet)) {
        Write-Host "Adding $ModuleName to the profile" -ForegroundColor Black -BackgroundColor Yellow
        Add-Content -Path $ProfilePath -Value "$ImportModuleCommand"
    }

    # Find Submodules
    $SubModules = @(Get-ChildItem -Path $ModuleOutputPath -Recurse -Filter '*.psm1' |
    Where-Object {$_.BaseName -ne $ModuleName} | Select-Object Name,BaseName,FullName | Out-Null)

    # Add submodules to the profile
    if ($SubModules) {
        foreach ($SubModule in $SubModules) {
            $ImportSubModuleCommand = "Import-Module -Name '$($SubModule.FullName)'"
            if (-not (Select-String -Path $ProfilePath -Pattern [regex]::Escape($ImportSubModuleCommand) -Quiet)) {
                Write-Host "Adding submodule $($SubModule.BaseName) to the profile" -ForegroundColor Black -BackgroundColor Yellow
                Add-Content -Path $ProfilePath -Value $ImportSubModuleCommand
            }
        }
    }

    Write-host "Validating Installation..." -ForegroundColor Yellow

    # Import the main module
    Import-Module -Name $ModuleName

    # main module installation verification
    $check1 = Get-Module -Name $ModuleName
    $check2 = Get-Command -Module $ModuleName | format-table -AutoSize

    # based on the checks, was installation successful?
    if ($check1 -and $check2) {
        Write-Host "Module Installation was successful!" -ForegroundColor Green
        $check2
    } else {
        Write-Host "Module Installation failed!" -ForegroundColor Red
    }


    if ($SubModules){
        # Import the submodules
        foreach ($item in $SubModules) {
            Import-Module -Name $($item.BaseName)
            $check3 = Get-Module -Name $($item.BaseName)
            $check4 = Get-Command -Module $($item.BaseName) | format-table -AutoSize
            $AllCommands = Get-Command -Module $($item.BaseName), $ModuleName

            if ($check3 -and $check4) {
                Write-Host "SubModule [$($item.BaseName)] was successfully installed!" -ForegroundColor Green
                $AllCommands
            } else {
                Write-Host "SubModule [$($item.BaseName)] was not installed!" -ForegroundColor Red
            }
        }

        if ($SubModules){
            $AllCommands
        } else {
            $check2
        }
    }
}  # Install-CustomModule -InputDir 'D:\Code\Repos\PowerShell-Modules\Modules\KitchenSink' -UserLevel 'All' 
# Install-CustomModule -InputDir 'D:\Code\Repos\LD\PowerShell LD\WolfPack2' -UserLevel 'All' -unblock