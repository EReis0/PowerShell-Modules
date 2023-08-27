<#
.SYNOPSIS
    Installs a custom module from the downloads folder to the module directory.
.DESCRIPTION
    This function installs a custom module from the downloads folder to the module directory. The function copies the module folder from the downloads folder to the module directory, and removes any existing module with the same name. If an Anti-Virus is running, it may flag this script as a virus. You will have to exclude powershell.exe from your AV during the installation.
.PARAMETER ModuleName
    Specifies the name of the module to install.
.EXAMPLE
    Install-CustomModule -ModuleName "MyModule"
    This example installs the "MyModule" module from the downloads folder to the module directory.
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
        $WindowsPowerShellModulePath = "C:\Program Files\WindowsPowerShell\Modules"
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
        New-Item -ItemType File -Path $ProfilePath -Force
    }

    # Check if the Import-Module command already exists in the profile
    $ProfileContent = Get-Content -Path $ProfilePath
    $ImportModuleCommand = "Import-Module -Name $ModuleName"
    $CommandExists = $ProfileContent -like "*$ImportModuleCommand*"

    # If the command does not exist, add it to the profile
    if (-not $CommandExists) {
    Add-Content -Path $ProfilePath -Value "`n$ImportModuleCommand`n"
    }

    Import-Module -Name $ModuleName

    Get-Module -Name $ModuleName
} # Install-CustomModule -InputDir 'C:\Users\thebl\Downloads\BleakKitchenSink' -UserLevel 'All'