function Write-LogError {
    param(
        [string]$Message,
        [switch]$DateTime,
        [switch]$Date,
        [switch]$Exit
    )

    if ($DateTime) {
        $Message = "$(Get-Date -f "(yyyy-MM-dd @ HH:mm)")[Error]: $Message"
    } elseif ($Date) {
        $Message = "$(Get-Date -f "(yyyy-MM-dd)")[Error]: $Message"
    } else {
        $Message = "[Error]: $Message"
    }

    if ($Exit) {
        write-host $message
        write-host "exit"
        #Add-Content -Path $logPath -Value "[Error]: $Message"
        #Exit 1
    } else {
        write-host $message
        #Add-Content -Path $logPath -Value "[Error]: $Message"
    }
}