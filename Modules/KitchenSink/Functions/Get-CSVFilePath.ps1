<#
.SYNOPSIS
    Prompts the user to select a CSV file using a file browser dialog.
.DESCRIPTION
    This function prompts the user to select a CSV file using a file browser dialog. The function uses the .NET Framework's `System.Windows.Forms.OpenFileDialog` class to display the dialog. The initial directory can be specified using the `$initialDirectory` parameter. The function only allows CSV files to be selected.
.PARAMETER initialDirectory
    Specifies the initial directory to display in the file browser dialog.
.EXAMPLE
    Get-CSVFilePath -initialDirectory "C:\Users\UserName\Documents"
    This example displays the file browser dialog with the initial directory set to "C:\Users\UserName\Documents", and only allows CSV files to be selected.
.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 8/2023
.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
Function Get-CSVFilePath($initialDirectory) {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.Filter = "CSV UTF-8 (Comma Delimited) (*.csv)| *.csv"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}