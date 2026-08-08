function Write-LogError {
    param(
        [string]$Message,
        [switch]$DateTime,
        [switch]$Date,
        [switch]$Time,
        [switch]$Exit,
        [Switch]$ToScreen
    )

    # Use the script scope variable established in Start-Log.ps1
    $targetPath = $script:currentLogPath

    if ($DateTime) {
        $Message = "/-> $(Get-Date -f "(yyyy-MM-dd @ HH:mm:ss)")[Error]: $Message"
    } elseif ($Date) {
        $Message = "/-> $(Get-Date -f "(yyyy-MM-dd)")[Error]: $Message"
    } elseif ($Time) {
        $Message = "/-> $(Get-Date -f "(HH:mm:ss)")[Error]: $Message"
    } else {
        # If no date flag is passed, we ensure the [Error] prefix exists.
        # Note: If you already added a date above, this block won't run 
        # but it's good to have as a fallback.
        $Message = "/-> [Error]: $Message"
    }

    if ($Exit) {
        if ($ToScreen) {
            Write-Host $Message -ForegroundColor Red
        }

        # Use $targetPath instead of $logPath
        Add-Content -Path $targetPath -Value $Message
        # Exit 1
    } else {
        if ($ToScreen) {
            Write-Host $Message -ForegroundColor Red
        }

        # Use $targetPath instead of $logPath
        Add-Content -Path $targetPath -Value $Message
    }
}