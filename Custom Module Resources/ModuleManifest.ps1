<#
.SYNOPSIS
    Generates a PSD1 file for a custom module
.DESCRIPTION
    Generates a PSD1 file for a custom module with dynamic package.
.NOTES
    Author: Codeholics - Eric Reis (https://github.com/EReis0)
    Version: 1.0
#>
$RootDir = "D:\Code\Repos\PowerShell-Modules\Modules\KitchenSink"
$FunctionDir = Join-Path -Path $RootDir -ChildPath "Functions"

# Get all functions in the Functions folder
$Functions = Get-ChildItem -Path $FunctionDir -Filter *.ps1 -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName
    foreach ($item in $content) {
        if ($item -match "^function\s+([a-z]+[\w-]*)") {
            $matches[1]
        }
    }
} | Select-Object -Unique

$ModuleName = $RootDir.Split("\")[-1]

# Create the module manifest
$ParmsModulePath = Join-Path -Path $RootDir -ChildPath "$ModuleName.psd1"
$Params = @{ 
    "Path" 				        = $ParmsModulePath
    "Author" 			        = 'Eric Reis https://github.com/EReis0' 
    "CompanyName" 			    = 'Codeholics.com (https://codeholics.com)' 
    "RootModule" 			    = "$ModuleName.psm1"
    "CompatiblePSEditions" 		= @('Desktop','Core') 
    "FunctionsToExport" 		= $Functions
    "CmdletsToExport" 		    = $Functions
    "VariablesToExport" 		= @() 
    "AliasesToExport" 		    = @() 
    "Description"               = "$ModuleName is a custom built module."
    "ModuleVersion"             = "1.0"
} 

New-ModuleManifest @Params