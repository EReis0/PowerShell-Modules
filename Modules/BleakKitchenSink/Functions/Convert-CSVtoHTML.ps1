Function Convert-CSVtoHTML {
    <#
    .SYNOPSIS
        Convert-CSVtoHTML
    .DESCRIPTION
        Convert a CSV file to an HTML report using PSWriteHTML and preferred params.

        - This function is a wrapper for the ConvertTo-HTMLTable function in PSWriteHTML. 
        When the function is executed, a file browser will open to select the CSV file to convert. 

        In order to use this, you must have PSWriteHTML installed.
    .NOTES
        - Could include the code from Get-CSVFilePath to reduce the lines of code for this feature.
    .LINK
        https://github.com/thebleak13/PowerShell-Samples/blob/main/BleakKitchenSink/README.md
    #>
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