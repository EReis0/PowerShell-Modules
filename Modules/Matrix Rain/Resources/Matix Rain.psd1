<#
.SYNOPSIS
    Generates a PSD1 file for a custom module
.DESCRIPTION
    Generates a PSD1 file for a custom module with dynamic package.
.NOTES
    Author: Codeholics - Eric Reis (https://github.com/EReis0)
    Version: 1.0
#>
$RootDir = "C:\Code\PowerShell-Modules\Modules\Matrix Rain"

$ModuleName = $RootDir.Split("\")[-1]

# Create the module manifest
$ParmsModulePath = Join-Path -Path $RootDir -ChildPath "$ModuleName.psd1"
$Params = @{ 
    "Path" 				        = $ParmsModulePath
    "Author" 			        = 'Eric Reis https://github.com/EReis0' 
    "CompanyName" 			    = 'Codeholics.com (https://codeholics.com)' 
    "RootModule" 			    = "$ModuleName.psm1"
    "CompatiblePSEditions" 		= @('Desktop','Core') 
    "FunctionsToExport" 		= @('Invoke-MatrixRain')
    "CmdletsToExport" 		    = @()
    "VariablesToExport" 		= @() 
    "AliasesToExport" 		    = @() 
    "Description"               = "$ModuleName is a custom built module."
    "ModuleVersion"             = "1.0.0"
    "PowerShellVersion"         = '5.1'
    "Copyright"                 = "(c) $(Get-Date -Format yyyy) Eric Reis. Licensed under the MIT License."
} 

New-ModuleManifest @Params