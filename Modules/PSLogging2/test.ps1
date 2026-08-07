import-module "C:\Code\PowerShell-Modules\Modules\PSLogging2\PSLogging2.psm1"

Start-Log -Simple -Title "Sample Logging Test" -logDir "C:\Code\PowerShell-Modules\Modules\PSLogging2\log"

Write-LogInfo -Message "This was a test"

Write-LogError -message "hello" -Date

#Write-LogError -message "hello" -Date -Exit

Stop-Log