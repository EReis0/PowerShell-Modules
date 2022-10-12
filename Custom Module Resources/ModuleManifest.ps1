$Params = @{ 
    "Path" 				        = '.\BleakKitchenSink\BleakKitchenSink.psd1' 
    "Author" 			        = 'TheBleak13' 
    "CompanyName" 			    = 'Codeholics.com' 
    "RootModule" 			    = 'BleakKitchenSink.psm1' 
    "CompatiblePSEditions" 		= @('Desktop','Core') 
    "FunctionsToExport" 		= @('Get-AskUserYNQuestion','Get-CSVFilePath','Convert-CSVtoHTML','Get-Folder') 
    "CmdletsToExport" 		    = @('Get-AskUserYNQuestion','Get-CSVFilePath','Convert-CSVtoHTML','Get-Folder') 
    "VariablesToExport" 		= '' 
    "AliasesToExport" 		    = @() 
    "Description"               = 'BleakKitchenSink' 
} 
New-ModuleManifest @Params

