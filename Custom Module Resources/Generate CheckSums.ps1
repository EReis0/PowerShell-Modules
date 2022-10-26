$PSMFile = '.\PowerShell-Samples\Modules\BleakKitchenSink\BleakKitchenSink.psm1'
$PSDFile = '.\PowerShell-Samples\Modules\BleakKitchenSink\BleakKitchenSink.psd1'
$Date = Get-Date -format 'yyyy-MM-dd'
$OutFile = ".\PowerShell-Samples\Checksums\$ModuleFolderName($Date).txt"
$ModuleFolderName = (Get-Item $PSMFile).Directory.Name

$PSMHash = (Get-FileHash -Path $PSMFile).Hash
$PSDHash = (Get-FileHash -Path $PSDFile).Hash

$PSMPath = (Get-FileHash -Path $PSMFile).path
$PSM = $PSMPath.split('\')[-1]

$PSDPath = (Get-FileHash -Path $PSDFile).path
$PSD = $PSDPath.split('\')[-1];

[PSCustomObject]$Results=@{
    PSM = [PSCustomObject]@{
        Name = $PSM
        Checksum = $PSMHash.tolower()
    }
    PSD = [PSCustomObject]@{
        Name = $PSD
        Checksum = $PSDHash.tolower()
    }
}

$ResultsPSM = "$($Results.PSM.Name) : $($Results.PSM.Checksum)" | Out-File -FilePath $OutFile -Append
$ResultsPSD = "$($Results.PSD.Name) : $($Results.PSD.Checksum)" | Out-File -FilePath $OutFile -Append