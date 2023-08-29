$PSMFile = 'D:\Code\Repos\PowerShell-Modules\Modules\KitchenSink\KitchenSink.psm1'
$PSDFile = 'D:\Code\Repos\PowerShell-Modules\Modules\KitchenSink\KitchenSink.psd1'
$Date = Get-Date -format 'yyyy-MM-dd'
$ModuleFolderName = (Get-Item $PSMFile).Directory.Name
$OutFile = "D:\Code\Repos\PowerShell-Modules\Checksums\$ModuleFolderName($Date).txt"

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