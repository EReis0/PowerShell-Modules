<#
.SYNOPSIS
    Installs a custom module from the downloads folder to the module directory.
.DESCRIPTION
    This function installs a custom module from the downloads folder to the module directory. 
    The function copies the module folder from the downloads folder to the module directory, 
    and removes any existing module with the same name. If an Anti-Virus is running, it may flag this script as a virus. 
    You will have to exclude powershell.exe from your AV during the installation.
.PARAMETER InputDir
    Specifies the path of the module to install. This parameter is mandatory. It should be the path to your module folder.
.PARAMETER UserLevel
    Specifies the level of the user for which the module should be installed. 
    This parameter is optional and can be set to either 'Single' or 'All'. If not specified, the default value is 'All'.
.EXAMPLE
    Install-CustomModule -InputDir "C:\Users\thebl\Downloads\KitchenSink" -UserLevel "All"
    This example installs the "KitchenSink" module from the -InputDir  to the module directory for all users.

    Install-CustomModule -InputDir "C:\Users\thebl\Downloads\KitchenSink" -UserLevel "Single"
    This example installs the "KitchenSink" module from the -InputDir  to the module directory for the current user.
.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.2
    Date: 10/2023

    You don't really need this script, you can technically just copy the folder and paste it to the module directory 
    'C:\Program Files\WindowsPowerShell\Modules'. Then you will need to add the import-module command to your profile.
    
    Installing the module is useful but you can also just import-module with the path to use it for a script.
.LINK
    https://github.com/EReis0/PowerShell-Samples/
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

    $ModuleOutputPath = Join-Path -Path $WindowsPowerShellModulePath -ChildPath $ModuleName
    
    Write-Host "This script will install the $ModuleName module to the module directory." -ForegroundColor Black -BackgroundColor white
    Write-Host "Copy module from $InputDir to $WindowsPowerShellModulePath" -ForegroundColor Black -BackgroundColor white

    # Check if the module is already installed
    $filecheck = test-path $ModuleOutputPath
    if ($filecheck) {
        Write-Host "Removing existing $ModuleName module from $WindowsPowerShellModulePath" -ForegroundColor Black -BackgroundColor Yellow
        Remove-Item -Path $ModuleOutputPath -Force -Recurse
    }

    # Add the directory containing the module to the PSModulePath environment variable
    $env:PSModulePath += ";$InputDir"

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

    # If the command (for main module) does not exist, add it to the profile
    $ImportModuleCommand = "Import-Module -Name $ModuleName"
    $CommandExists = $ProfileContent -like "*$ImportModuleCommand*"
    if (-not $CommandExists) {
        Write-Host "Adding $ModuleName to the profile" -ForegroundColor Black -BackgroundColor Yellow
        Add-Content -Path $ProfilePath -Value "$ImportModuleCommand"
    }

    # Find Submodules
    $SubModules = @(Get-ChildItem -Path $ModuleOutputPath -Recurse -Filter '*.psm1' |
    Where-Object {$_.BaseName -ne $ModuleName} | Select-Object Name,BaseName,FullName)

    if ($SubModules) {
        # Add each submodule to the profile
        foreach ($SubModule in $SubModules) {
            $Name = $SubModule.Name
            $FullName = $SubModule.FullName
            $BaseName = $SubModule.BaseName
            $ImportSubModuleCommand = "Import-Module ""$FullName"""
            $ImportSubModuleCommand2 = Join-path -path $WindowsPowerShellModulePath -ChildPath $modulename | Join-Path -ChildPath "$($modulename).psm1"  
            $CommandExists = $ProfileContent -like "*$ImportSubModuleCommand*" -or $ProfileContent -like "*$ImportSubModuleCommand2*"

            # If the command (for submodules) does not exist, add it to the profile
            if (-not $CommandExists) {
                Write-Host "Adding $SubModule to the profile" -ForegroundColor Black -BackgroundColor Yellow
                Add-Content -Path $ProfilePath -Value "$ImportSubModuleCommand"
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
# Install-CustomModule -InputDir 'D:\Code\Repos\LD\PowerShell LD\WolfPack2' -UserLevel 'All'