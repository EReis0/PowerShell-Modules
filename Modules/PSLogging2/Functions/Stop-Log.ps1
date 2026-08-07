function Stop-Log {
    # No parameters needed if using script scope, 
    # but kept for compatibility if you prefer passing the path explicitly.
    param(
        [string]$logPath = $script:currentLogPath
    )

    if (Test-Path -Path $logPath) {
        # Stop and calculate time
        $script:LogStopwatch.Stop()
        $elapsed = $script:LogStopwatch.Elapsed
        
        $endTime = Get-Date
        
        Add-Content -Path $logPath -Value "***************************************************************************************************"
        Add-Content -Path $logPath -Value "Finished at: $endTime"
        Add-Content -Path $logPath -Value "Total Execution Time: $($elapsed.Minutes)m $($elapsed.Seconds)s"
        Add-Content -Path $logPath -Value "***************************************************************************************************"
    }
}