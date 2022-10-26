Function Get-Folder($initialDirectory){
    <#
    .SYNOPSIS
        Get-Folder
    .DESCRIPTION
        Opens a folder browser dialog and returns the selected folder.
    .NOTES
        N/A
    .LINK
        https://github.com/thebleak13/PowerShell-Samples/blob/main/BleakKitchenSink/README.md
    #>
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