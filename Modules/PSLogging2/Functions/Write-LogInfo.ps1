function Write-LogInfo {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [switch]$DateTime,
        [switch]$Date,
        [switch]$Time,
        [switch]$ToScreen
    )

    # Use the script scope variable that was established in Start-Log.ps1
    $targetPath = $script:currentLogPath

    if ($DateTime) {
        $Message = "$(Get-Date -f "(yyyy-MM-dd @ HH:mm:ss)"): $($Message)"
    } elseif ($Date) {
        $Message = "$(Get-Date -f "(yyyy-MM-dd)"): $($Message)"
    } elseif ($Time) {
        $Message = "$(Get-Date -f "(HH:mm:ss)"): $($Message)"
    } else {
        $Message = "$($Message)"
    }
    
    if ($ToScreen) {
        Write-Host $Message -ForegroundColor Cyan
    }

    if ($null -ne $targetPath -and (Test-Path $targetPath)) {
        Add-Content -Path $targetPath -Value "- $($Message)"
    } else {
        Write-Warning "Cannot write to log. Path is null or file does not exist."
    }
}