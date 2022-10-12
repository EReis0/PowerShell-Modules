<#
Purpose: Copy module folder from downloads to C:\Program Files\WindowsPowerShell\Modules
Warning: If you're running a Anti-Virus, it may flag this script as a virus. You will have to exclude powershell.exe from your AV during the installation.
         Just make sure to remove the AV exception because leaving it in place is very risky.

You don't really need this script, you can technically just copy the folder and paste it to the module directory 'C:\Program Files\WindowsPowerShell\Modules'.
This will also avoid the issues with AV.

#>
$WindowsPowerShellModulePath = $env:PSModulePath.Split(';')[0]
$ModulePath = "$WindowsPowerShellModulePath\BleakKitchenSink"

$DownloadsPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
$InstallCustomModulePath = "$DownloadsPath\BleakKitchenSink\"

$filecheck = test-path $ModulePath
if ($filecheck) {
    Remove-Item -LiteralPath $ModulePath -Force -Recurse
}

try{
Copy-Item -LiteralPath $InstallCustomModulePath -Destination $ModulePath -PassThru -Recurse
}catch{
    $_.Exception.Message
}