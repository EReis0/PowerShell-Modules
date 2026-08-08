function Start-Log {
    Param(
        [string]$LogDir = (Join-Path -Path $PSScriptRoot -ChildPath "log"),
        [Parameter(Mandatory=$true)]
        [ValidateSet("Standard", "Simple", "Daily")]
        [string]$Style, # Accepts "Standard" or "Simple"
        [string]$Title = "Script Log",
        [switch]$ToScreen,
        [string]$Version
    )

    # Initialize Timer
    $script:LogStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $DateStamp = Get-Date

    if ($Style -eq "Standard") {
        # Use a single date object to construct the path string for cleaner code
        $pathParts = @(
            $DateStamp.ToString("yyyy"), 
            $DateStamp.ToString("yyyy-MM"), 
            $DateStamp.ToString("yyyy-MM-dd_HHmmss")
        )
        $script:currentLogPath = Join-Path -Path $logDir -ChildPath "$($pathParts[0])\$($pathParts[1])\$($pathParts[2]).log"
    } elseif ($Style -eq "Simple") {
        $script:currentLogPath = Join-Path -Path $logDir -ChildPath "$($DateStamp.ToString('yyyy-MM-dd_HHmmss')).log"
    } elseif ($Style -eq "Daily") {
            $pathParts = @(
            $DateStamp.ToString("yyyy"), 
            $DateStamp.ToString("yyyy-MM"),
            $DateStamp.ToString("yyyy-MM-dd")
        )
        $script:currentLogPath = Join-Path -Path $logDir -ChildPath "$($pathParts[0])\$($pathParts[1])\$($pathParts[2]).log"
    } else {
        if ($Style -eq "Standard" -and $Style -eq "Simple" -and $Style -eq "Daily") { throw "Invalid Selection (Must choose style as standard, Simple, or Daily)" }
        throw "Invalid Selection (Must choose style as standard, Simple, or Daily)"
    }

    # We use one consistent variable: currentLogPath
    $logPath = $script:currentLogPath

    try {
        $parentDir = Split-Path -Path $logPath -Parent
        if (-not (Test-Path -Path $parentDir)) {
            New-Item -Path $parentDir -ItemType Directory | Out-Null
            #Write-host "Created directory: $parentDir"
        }
        if (-not (Test-Path -Path $logPath)) {
            New-Item -Path $logPath -ItemType File | Out-Null
            #Write-host "Created file: $logPath"
        }
    } catch {
        Write-Error "Failed to initialize log path at $logPath. Error: $($_.Exception.Message)"
    }

    try {
        ## Start Log Header
        if ($null -eq $Version) {
            $HeaderTItle = "$Title - [$DateStamp])"
        } elseif ($null -ne $Version) {
            $HeaderTItle = "$Title ($($Version)) - [$DateStamp]"
        }
        
        $header = @"
***************************************************************************************************
$HeaderTItle
***************************************************************************************************
"@
        Add-Content -Path $logPath -Value $header
        Add-Content -Path $logPath -Value `n`r
    } catch {
        Write-Error "Failed to write initial headers: $($_.Exception.Message)"
    }

    if ($ToScreen) {
        Write-Host "Log Created: [$($logPath)] | Date: [$($DateStamp)]" -ForegroundColor Cyan
    }
}