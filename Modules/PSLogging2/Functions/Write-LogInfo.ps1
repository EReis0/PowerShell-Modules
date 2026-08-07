function Write-LogInfo {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    # Use the script scope variable that was established in Start-Log.ps1
    $targetPath = $script:currentLogPath

    if ($null -ne $targetPath -and (Test-Path $targetPath)) {
        Add-Content -Path $targetPath -Value $Message
    } else {
        Write-Warning "Cannot write to log. Path is null or file does not exist."
    }
}