$CPSScriptRoot = 'D:\Code\Repos\PowerShell-Modules\Modules'
$CheckSums = 'D:\Code\Repos\PowerShell-Modules\Checksums'
$ModuleName = 'KitchenSink'

$PSMFile = Join-Path -Path $CPSScriptRoot -ChildPath $ModuleName | Join-Path -ChildPath "$ModuleName.psm1"
$PSDFile = Join-Path -Path $CPSScriptRoot -ChildPath $ModuleName | Join-Path -ChildPath "$ModuleName.psd1"
$Date = Get-Date -format 'yyyy-MM-dd'

# D:\Code\Repos\PowerShell-Modules\Checksums
# D:\Code\Repos\PowerShell-Modules\Modules\Checksums\
$OutFile = Join-Path -Path $CheckSums -ChildPath "$ModuleName($Date).txt"

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

