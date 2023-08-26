<#
.SYNOPSIS
    Displays a folder browser dialog and returns the selected folder.
.DESCRIPTION
    This function displays a folder browser dialog and returns the selected folder. The function uses the .NET Framework's `System.Windows.Forms.FolderBrowserDialog` class to display the dialog. The initial directory can be specified using the `$initialDirectory` parameter.
.PARAMETER initialDirectory
    Specifies the initial directory to display in the folder browser dialog.
.EXAMPLE
    Get-Folder -initialDirectory "C:\Users\UserName\Documents"
    This example displays the folder browser dialog with the initial directory set to "C:\Users\UserName\Documents".
.NOTES
    Author: Codeholics - TheBleak
    Version: 1.0
    Date: 8/2023
.LINK
    https://github.com/thebleak13/PowerShell-Samples/blob/main/BleakKitchenSink/README.md
#>
Function Get-Folder($initialDirectory){

        [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
        $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
        $foldername.Description = "Select a folder"
        $foldername.rootfolder = "MyComputer"
        $foldername.SelectedPath = $initialDirectory
    
        if($foldername.ShowDialog() -eq "OK"){
        $folder += $foldername.SelectedPath
        }
        
        return $folder
} 