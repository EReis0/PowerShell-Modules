<#
.SYNOPSIS
    Converts a CSV file to an HTML report using PSWriteHTML.
.DESCRIPTION
    This function converts a CSV file to an HTML report using PSWriteHTML and preferred parameters. The function is a wrapper for the `ConvertTo-HTMLTable` function in PSWriteHTML. When the function is executed, a file browser will open to select the CSV file to convert. In order to use this function, you must have PSWriteHTML installed.
.PARAMETER None
    This function does not accept any parameters.
.EXAMPLE
    Convert-CSVtoHTML
    This example converts a CSV file to an HTML report using PSWriteHTML and preferred parameters.
.NOTES
    Author: Codeholics - TheBleak
    Version: 1.0
    Date: 8/2023
.LINK
    https://github.com/thebleak13/PowerShell-Samples/blob/main/BleakKitchenSink/README.md
#>
Function Convert-CSVtoHTML {

    #Requires -Module PSWriteHTML
    
    Import-Module -Name PSWriteHTML
    $DownloadsPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    $File = Get-CSVFilePath
    $importFile = @(Import-CSV -path $File)
    $FileNameRaw = (Get-ChildItem $file).Name
    $FileName = $FileNameRaw.Replace(".csv",'')
    Write-Host "`n`r ---> Exported report to $DownloadsPath\$FileName.html" -foregroundcolor 'black' -backgroundcolor 'green'
    New-HTML {
        New-HTMLTable -DataTable $importFile -Title $FileName -HideFooter -PagingLength 10 -Buttons excelHtml5,searchPanes
    } -ShowHTML -FilePath "$DownloadsPath\$FileName.html" -Online
} #Convert-CSVtoHTML