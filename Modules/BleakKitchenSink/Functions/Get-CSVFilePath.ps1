Function Get-CSVFilePath($initialDirectory){
    <#
    .SYNOPSIS
        Get-CSVFilePath
    .DESCRIPTION
        Prompt the user with a filebrowser to select a CSV file. Provides path to selected CSV.
    .NOTES
        - Could build this out to have a parameter for file type.
    .LINK
        https://github.com/thebleak13/PowerShell-Samples/blob/main/BleakKitchenSink/README.md
    #>
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.Filter = "CSV UTF-8 (Comma Delimited) (*.csv)| *.csv"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}