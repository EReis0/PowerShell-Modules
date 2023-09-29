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