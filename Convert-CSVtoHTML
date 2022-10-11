Import-module -Name 'PSWriteHTML'

Function Get-FileName($initialDirectory)
{  
 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
 Out-Null

 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = $initialDirectory
 $OpenFileDialog.filter = "CSV UTF-8 (Comma Delimited) (*.csv)| *.csv"
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename
}

function Convert-CSVtoHTML {
    [cmdletbinding()]
    $DownloadsPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    $File = Get-FileName
    $importFile = @(import-csv -path $File)
    $FileNameRaw = (Get-childitem $file).name
    $FileName = $FileNameRaw.replace(".csv",'')
    write-host "`n`r ---> Exported report to $DownloadsPath\$FileName.html" -foregroundcolor 'black' -backgroundcolor 'green'
    New-HTML {
        New-HTMLTable -DataTable $importFile -Title $FileName -HideFooter -PagingLength 10 -Buttons excelHtml5,searchPanes
    } -ShowHTML -FilePath "$DownloadsPath\$FileName.html" -Online
} #Convert-CSVtoHTML
