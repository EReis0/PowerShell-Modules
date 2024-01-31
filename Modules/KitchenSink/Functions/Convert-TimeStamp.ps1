<#
.SYNOPSIS
    Converts a Unix timestamp or a Windows File Time to a human-readable date and time.

.DESCRIPTION
    The Convert-Timestamp function takes a Unix timestamp (milliseconds since 1970-01-01 00:00:00 UTC) or a Windows File Time (100-nanosecond intervals since 1601-01-01 00:00:00 UTC) and converts it to a human-readable date and time in the format "MM/dd/yyyy hh:mm tt".

.PARAMETER timestamp
    The Unix timestamp or Windows File Time to convert. This is a mandatory parameter.

.EXAMPLE
    Convert-Timestamp -timestamp 1706381481000
    This will convert the Unix timestamp 1706381481000 to a human-readable date and time.

.EXAMPLE
    Convert-Timestamp -timestamp 133505150963768760
    This will convert the Windows File Time 133505150963768760 to a human-readable date and time.

.NOTES
    Unix timestamps are typically 13 digits long, while Windows File Times are typically 18 digits long. The function determines the type of the timestamp based on its length.

    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 01/2024

.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
function Convert-Timestamp {
    param(
        [Parameter(Mandatory=$true)]
        [int64]$timestamp
    )

    # Unix timestamp (milliseconds) is typically 13 digits
    # Windows File Time is typically 18 digits
    switch ($timestamp.ToString().Length) {
        { $_ -le 13 } {
            $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
            $TS = $origin.AddMilliseconds($timestamp).ToLocalTime()
            return $TS.ToString("MM/dd/yyyy hh:mm tt")
        }
        { $_ -gt 13 } {
            $TS = [DateTime]::FromFileTime($timestamp)
            return $TS.ToString("MM/dd/yyyy hh:mm tt")
        }
    }
}