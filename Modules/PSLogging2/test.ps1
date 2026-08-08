$CPScriptRoot = "E:\Code\Repos\PowerShell-Modules\Modules\PSLogging2"
import-module (Join-Path -Path $CPScriptRoot -ChildPath "PSLogging2.psm1")

Start-Log `
    -Style "Standard" `
    -Title "Sample Logging Test" `
    -LogDir (Join-Path -Path $CPScriptRoot -ChildPath "log") `
    -ToScreen `
    -Version "1.0"

Write-LogInfo -Message "This was a test" -ToScreen
Write-LogInfo -Message "Another test message" -ToScreen -DateTime
Write-LogInfo -Message "Another test message" -ToScreen -Date
Write-LogInfo -Message "Another test message" -ToScreen -Time

Write-LogError -message "hello" -DateTime -ToScreen
Write-LogError -message "hello" -Date -ToScreen
Write-LogError -message "hello" -Time -ToScreen


#Write-LogError -message "Wrong Input" -Date -Exit
#Write-LogError -message "Wrong Input" -DateTime -Exit

Stop-Log