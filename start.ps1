#Requires -RunAsAdministrator
Import-Module -Name KitchenSink

$CPSScriptRoot = "D:\Code\Repos\PowerShell-Modules"

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