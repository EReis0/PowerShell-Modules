function Start-Log {
    Param(
        [string]$logDir = (Join-Path -Path $PSScriptRoot -ChildPath "log"),
        [switch]$Standard,
        [switch]$Simple,
        [string]$Title = "Script Log",
        [switch]$Verbose
    )

    # Initialize Timer
    $script:LogStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $DateStamp = Get-Date # Capture

    if ($Standard) {
        # Use a single date object to construct the path string for cleaner code
        $pathParts = @(
            $DateStamp.ToString("yyyy"), 
            $DateStamp.ToString("yyyy-MM"), 
            $DateStamp.ToString("yyyy-MM-dd_HHmmss")
        )
        $script:currentLogPath = Join-Path -Path $logDir -ChildPath "$($pathParts[0])\$($pathParts[1])\$($pathParts[2]).log"
    } elseif ($Simple) {
        $script:currentLogPath = Join-Path -Path $logDir -ChildPath "$($DateStamp.ToString('yyyy-MM-dd_HHmmss')).log"
    } else {
        if ($Standard -and $Simple) { throw "Invalid Selection (Must only select one ('-Simple', '-Standard'))" }
        throw "Invalid Selection (Must choose -standard or -Simple)"
    }

    # We use one consistent variable: currentLogPath
    $logPath = $script:currentLogPath

    try {
        $parentDir = Split-Path -Path $logPath -Parent
        if (-not (Test-Path -Path $parentDir)) {
            New-Item -Path $parentDir -ItemType Directory | Out-Null
            Write-Verbose "Created directory: $parentDir"
        }
        if (-not (Test-Path -Path $logPath)) {
            New-Item -Path $logPath -ItemType File | Out-Null
            Write-Verbose "Created file: $logPath"
        }
    } catch {
        Write-Error "Failed to initialize log path at $logPath. Error: $($_.Exception.Message)"
    }

    try {
        ## Start Log Header
        $header = @"
***************************************************************************************************
$Title - [$DateStamp]
***************************************************************************************************
"@
        Add-Content -Path $logPath -Value $header
    } catch {
        Write-Error "Failed to write initial headers: $($_.Exception.Message)"
    }

    if ($Verbose) {
        Write-Host "Log Created: [$($logPath)] | Date: [$($DateStamp)]" -ForegroundColor Yellow
    }
}