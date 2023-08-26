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
    Author: Codeholics - TheBleak
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
        [string]$ModuleName
    )

    $WindowsPowerShellModulePath = $env:PSModulePath.Split(';')[0]
    $ModulePath = "$WindowsPowerShellModulePath\$ModuleName"

    $DownloadsPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    $InstallCustomModulePath = "$DownloadsPath\$ModuleName\"

    Write-Host "This script will install the $ModuleName module from the downloads folder to the module directory." -ForegroundColor Black -BackgroundColor white
    Write-Host "Copy module from $ModulePath to $WindowsPowerShellModulePath" -ForegroundColor Black -BackgroundColor white
    Write-Host "If you have an Anti-Virus, it may flag this script as a virus. You will have to exclude powershell.exe from your AV during the installation." -ForegroundColor Black -BackgroundColor Yellow

    $filecheck = test-path $ModulePath
    if ($filecheck) {
        Remove-Item -Path $ModulePath -Force -Recurse
    }

    try{
    Copy-Item -Path $InstallCustomModulePath -Destination $ModulePath -PassThru -Recurse -ErrorAction Stop
    Write-Host $ModuleName Was successfully installed to $WindowsPowerShellModulePath -ForegroundColor Black -BackgroundColor Green
    }catch{
        $CatchError = $_.Exception.Message
        $ErrorType = $CatchError[0].Exception.GetType().FullName
        Write-Host $CatchError -ForegroundColor Black -BackgroundColor Red
        Write-Host $ErrorType -ForegroundColor Black -BackgroundColor Red
    }
}