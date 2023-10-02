<#
.SYNOPSIS
Converts a UTC timestamp to a readable format.

.DESCRIPTION
The Convert-UTCTimeStamp function converts a UTC timestamp to a readable format. It uses the Windows Time service (w32tm.exe) to convert the timestamp to a string, and then extracts the last part of the string to get the readable timestamp.

.PARAMETER timestamp
The UTC timestamp to convert.

.EXAMPLE
PS C:\> Convert-UTCTimeStamp -timestamp 128271382742968750
Converts the UTC timestamp 128271382742968750 to a readable format.

.NOTES
This function requires the Windows Time service (w32tm.exe) to be installed and running on the local computer.
#>
Function Convert-UTCTimeStamp {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$timestamp
    )
    $string = (w32tm /ntte $timestamp)
    $newstring = $string.split('-')[-1]
    return $newstring
} # Convert-UTCTimeStamp -timestamp 128271382742968750

