$Params = @{ 
    "Path" 				        = '.\BleakKitchenSink\BleakKitchenSink.psd1' 
    "Author" 			        = 'TheBleak13' 
    "CompanyName" 			    = 'Codeholics.com' 
    "RootModule" 			    = 'BleakKitchenSink.psm1' 
    "CompatiblePSEditions" 		= @('Desktop','Core') 
    "FunctionsToExport" 		= @('Get-AskUserYNQuestion','Get-CSVFilePath','Convert-CSVtoHTML','Get-Folder','Install-CustomModule','Join-FunctionToPSM') 
    "CmdletsToExport" 		    = @('Get-AskUserYNQuestion','Get-CSVFilePath','Convert-CSVtoHTML','Get-Folder','Install-CustomModule','Join-FunctionToPSM') 
    "VariablesToExport" 		= '' 
    "AliasesToExport" 		    = @() 
    "Description"               = 'BleakKitchenSink' 
} 
New-ModuleManifest @Params