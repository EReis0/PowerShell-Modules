<#
.SYNOPSIS
Converts between hexadecimal and plain text formats.

.DESCRIPTION
The Convert-HexText function converts between hexadecimal and plain text formats. If the 'text' parameter is used, the provided text is returned in a hexadecimal format. If the 'hex' parameter is used, the provided hexadecimal value is read and returned in plain text format.

.PARAMETER hex
The hexadecimal value to convert to plain text format.

.PARAMETER text
The text value to convert to hexadecimal format.
Does not accept lists of values.

.EXAMPLE
Convert-HexText -text "Hello, world!"

This example converts the text "Hello, world!" to a hexadecimal format.

.EXAMPLE
Convert-HexText -hex "48656C6C6F2C20776F726C6421"

This example converts the hexadecimal value "48656C6C6F2C20776F726C6421" to plain text format.

.NOTES
Author: Codeholics - Eric Reis (https://github.com/EReis0/)
Date: 10/12/2023
Version: 1.0
#>
function Convert-HexText {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$hex,
        [Parameter(Mandatory=$false)]
        [string]$text
    )

    if ($hex -and $text) {
        Write-Error "Only one of the 'hex' and 'text' parameters can be specified."
        return
    }

    if ($hex) {
        # Convert the hexadecimal string to a byte array
        $bytes = [System.Text.RegularExpressions.Regex]::Matches($hex, '..').ForEach({[byte]::Parse($_.Value, 'HexNumber')})

        # Convert the byte array to a string using the UTF8 encoding
        $string = [System.Text.Encoding]::UTF8.GetString($bytes)

        # Output the string
        Write-Output $string
    }
    elseif ($text) {
        # Convert the text to a byte array using the UTF8 encoding
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)

        # Convert the byte array to a hexadecimal string
        $hex = [BitConverter]::ToString($bytes) -replace '-'

        # Output the hexadecimal string
        Write-Output $hex
    }
    else {
        Write-Error "One of the 'hex' and 'text' parameters must be specified."
    }
}  # Convert-HexText -text "Hello World!"