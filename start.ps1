#Requires -RunAsAdministrator

<# 
    You can run this after you have already installed the module. See Modules > KitcheSink > Install-Module.ps1
#>

Import-Module -Name KitchenSink

$CPSScriptRoot = "C:\Code\PowerShell-Modules"

# psd1
$psd1 = Join-Path -Path $CPSScriptRoot -ChildPath "Custom Module Resources" | Join-Path -ChildPath "ModuleManifest.ps1"
& $psd1

# psm1
$RootFolder = Join-Path -Path $CPSScriptRoot -ChildPath "Modules" | Join-Path -ChildPath "KitchenSink"
Join-FunctionsToPSM -RootFolder $RootFolder

# Install
$InputDir = Join-Path -Path $CPSScriptRoot -ChildPath "Modules" | Join-Path -ChildPath "KitchenSink"
Install-CustomModule -InputDir $InputDir

# Checksums
$Checksums = Join-Path -Path $CPSScriptRoot -ChildPath "Custom Module Resources" | Join-Path -ChildPath "Generate CheckSums.ps1"
& $Checksums

# "C:\Code\PowerShell-Modules\Custom Module Resources\ModuleManifest.ps1"