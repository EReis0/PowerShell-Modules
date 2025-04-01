<#
.SYNOPSIS
    Formats a phone number string to a standard format, including handling extensions.

.DESCRIPTION
    The Format-PhoneNumber function takes a phone number string as input and formats it to a standard format (e.g., (123) 456-7890). It also handles extensions, appending them to the formatted phone number if present.

.PARAMETER phoneNumber
    The phone number string that needs to be formatted.

.EXAMPLE
    $phoneNumber = "(602) 755-0405 EXT 250405"
    $formattedPhoneNumber = Format-PhoneNumber -phoneNumber $phoneNumber
    Write-Output $formattedPhoneNumber
    # Output: "(602) 755-0405 x250405"

.EXAMPLE
    $phoneNumber = "623-294-8427"
    $formattedPhoneNumber = Format-PhoneNumber -phoneNumber $phoneNumber
    Write-Output $formattedPhoneNumber
    # Output: "(623) 294-8427"

.EXAMPLE
    $phoneNumber = "3144943670"
    $formattedPhoneNumber = Format-PhoneNumber -phoneNumber $phoneNumber
    Write-Output $formattedPhoneNumber
    # Output: "(314) 494-3670"

.EXAMPLE
    $phoneNumber = "(972) 499-6799x556799"
    $formattedPhoneNumber = Format-PhoneNumber -phoneNumber $phoneNumber
    Write-Output $formattedPhoneNumber
    # Output: "(972) 499-6799 x556799"

.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 12/13/2024

.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
function Format-PhoneNumber {
    param (
        [string]$phoneNumber
    )
    # Remove any non-digit characters except for 'x' and 'X' for extensions
    $cleanPhoneNumber = $phoneNumber -replace '[^\dXx]', ''
    
    # Check if the phone number has an extension
    if ($cleanPhoneNumber -match '(\d{10})([Xx]\d+)?') {
        $mainNumber = $matches[1]
        $extension = $matches[2]

        # Format the main number
        $formattedNumber = $mainNumber -replace '(\d{3})(\d{3})(\d{4})', '($1) $2-$3'

        # Append the extension if it exists
        if ($extension) {
            $formattedNumber += " x" + $extension.Substring(1)
        }

        return $formattedNumber
    } else {
        return $phoneNumber
    }
}