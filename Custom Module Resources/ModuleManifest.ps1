$Params = @{ 
    "Path" 				        = '.\BleakKitchenSink\BleakKitchenSink.psd1' 
    "Author" 			        = 'TheBleak13' 
    "CompanyName" 			    = 'Codeholics.com' 
    "RootModule" 			    = 'BleakKitchenSink.psm1' 
    "CompatiblePSEditions" 		= @('Desktop','Core') 
    "FunctionsToExport" 		= @('Get-AskUserYNQuestion','Get-FileName','Convert-CSVtoHTML') 
    "CmdletsToExport" 		    = @('Get-AskUserYNQuestion','Get-FileName','Convert-CSVtoHTML') 
    "VariablesToExport" 		= '' 
    "AliasesToExport" 		    = @() 
    "Description"               = 'BleakKitchenSink' 
} 
New-ModuleManifest @Params

