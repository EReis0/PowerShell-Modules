# Every Script include this
#$modulePath = "C:\Program Files\WindowsPowerShell\Modules\KitchenSink"
#$env:PSModulePath = "C:\Users\thebl\Documents\WindowsPowerShell\Modules;C:\Program Files\WindowsPowerShell\Modules;C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules;c:\Users\thebl\.vscode\extensions\ms-vscode.powershell-2023.6.0\modules;"



# Run this to create the profile
$ProfilePath = "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
$CheckProfile = Test-Path -Path $ProfilePath
if ($CheckProfile -eq $false) {
    New-Item -ItemType File -Path $ProfilePath -Force
}

# Check if the Import-Module command already exists in the profile
$ProfileContent = Get-Content -Path $ProfilePath
$ImportModuleCommand = "Import-Module -Name KitchenSink"
$CommandExists = $ProfileContent -like "*$ImportModuleCommand*"

# If the command does not exist, add it to the profile
if (-not $CommandExists) {
    Add-Content -Path $ProfilePath -Value "`n$ImportModuleCommand`n"
}

# Add this to the profile
# Import-Module -Name KitchenSink

Import-Module -Name KitchenSink

Get-Module -Name KitchenSink

Get-Command -Module KitchenSink
