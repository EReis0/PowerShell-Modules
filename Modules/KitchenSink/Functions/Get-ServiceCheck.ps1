
<#
.SYNOPSIS
    Checks if a service is running and starts it if it's not.
.DESCRIPTION
    The Get-ServiceCheck function checks if a service is running and starts it if it's not. 
    It takes an array of service names as input and checks each service in the array.
.PARAMETER ServiceName
    Specifies an array of service names to check.
.EXAMPLE
    Get-ServiceCheck -ServiceName @('PlexUpdateService', 'Spooler')
    This example checks if the 'PlexUpdateService' and 'Spooler' services are running and starts them if they're not
.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 10/2023
.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
function Get-ServiceCheck {
    [cmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$ServiceName
    )

    foreach ($Service in $ServiceName) {
        # Check if service is running
        try{
            $ServiceCheck = Get-Service -Name $Service -ErrorAction SilentlyContinue
        } catch {
            Write-Warning "[$(Get-Date)] Ran into an unexpected error trying to locate $Service. Failed running Get-Service. "
            $_.Exception.Message
        }

        if ($null -eq $ServiceCheck) {
            Write-Warning "[$(Get-Date)]  $Service service not found."
        } else {
            if ($ServiceCheck.Status -ne 'Running') {

                try {
                    Start-Service $Service -ErrorAction SilentlyContinue
                } catch {
                    Write-Warning "[$(Get-Date)] Ran into an unexpected error when trying to start $Service. Failed running Start-Service. "
                    $_.Exception.Message
                }

                Start-Sleep -Seconds 5
                $ServiceCheck.Refresh()
                if ($ServiceCheck.Status -ne 'Running') {
                    Write-Warning "[$(Get-Date)] $Service service failed to start."
                } else {
                    Write-Host "[$(Get-Date)] $Service service started."
                }
            } else {
                Write-Host "[$(Get-Date)] $Service service is already running."
            }
        }
    }
} # Get-ServiceCheck -ServiceName @('PlexUpdateService')