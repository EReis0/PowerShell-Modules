<#
.SYNOPSIS
    Generates a Time-based One-Time Password (TOTP) code.

.DESCRIPTION
    The Convert-TOTPToMFA function generates a TOTP code based on the provided secret, period, number of digits, and algorithm. 
    It decodes the Base32 TOTP secret, calculates the time step, generates the HMAC hash, extracts the dynamic offset, and calculates the TOTP code.

.PARAMETER Secret
    The Base32 encoded TOTP secret.

.PARAMETER Period
    The time period in seconds for the TOTP code. The default is 30 seconds.

.PARAMETER Digits
    The number of digits for the TOTP code. The default is 6 digits.

.PARAMETER Algorithm
    The hashing algorithm to use for generating the HMAC hash. Supported algorithms are "SHA1", "SHA256", and "SHA512". The default is "SHA1".

.EXAMPLE
    $TOTPSecret = "JBSWY3DPEHPK3PXP"
    $MFA = Convert-TOTPToMFA -Secret $Secret -Period 30 -Digits 6 -Algorithm "SHA1"
    Write-Host "Generated TOTP Code: $MFA"

    This example generates a 6-digit TOTP code using the provided secret, a 30-second period, and the SHA1 algorithm.

.NOTES
    Note: If the MFA code is not valid. Synchronize your system clock with the configured NTP server
    - Check the synchronization status : "w32tm /query /status"
    - If the service is not running, start Windows Time service : "Start-Service w32time"
    - Resynchronize the system clock : "w32tm /resync"
    - Check the synchronization status again : "w32tm /query /status"

    This script is based on the TOTP algorithm described in RFC 6238: https://tools.ietf.org/html/rfc6238

    Special thanks to https://totp.danhersam.com/ (https://github.com/jaden/totp-generator/tree/master) and https://github.com/hectorm/otpauth for providing useful
    source code for decoding TOTP secrets. 

    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 3/20/2025
.LINK
    https://github.com/EReis0/PowerShell-Modules/tree/main/Modules/KitchenSink
#>

#>
function Convert-TOTPToMFA {
    param (
        [string]$Secret,
        [int]$Period = 30,
        [int]$Digits = 6,
        [string]$Algorithm = "SHA1"
    )

    # Function to decode Base32 TOTP secret
    function Decode-Base32 {
        param (
            [string]$Base32String
        )

        $Base32Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
        $Base32String = $Base32String.ToUpper().TrimEnd("=")
        $SecretBytes = @()
        $Bits = 0
        $Value = 0

        foreach ($Char in $Base32String.ToCharArray()) {
            $Index = $Base32Chars.IndexOf($Char)
            if ($Index -lt 0) {
                throw "Error: Invalid character '$Char' in TOTP secret."
            }
            $Value = ($Value -shl 5) -bor $Index
            $Bits += 5
            if ($Bits -ge 8) {
                $Bits -= 8
                $SecretBytes += [byte]($Value -shr $Bits)
                $Value = $Value -band ((1 -shl $Bits) - 1)
            }
        }

        return $SecretBytes
    }

    if (-not [string]::IsNullOrEmpty($Secret)) {
        # Decode the Base32 TOTP secret
        $SecretBytes = Decode-Base32 -Base32String $Secret

        if (-not $SecretBytes) {
            throw "Error: Failed to decode TOTP secret."
        }

        # Calculate the time step
        $UnixTime = [math]::Floor(((Get-Date).ToUniversalTime() - [datetime]'1970-01-01').TotalSeconds / $Period)
        $TimeStepBytes = [BitConverter]::GetBytes([UInt64]$UnixTime)
        if ([BitConverter]::IsLittleEndian) {
            [Array]::Reverse($TimeStepBytes)
        }

        # Generate the HMAC hash
        $HMAC = switch ($Algorithm) {
            "SHA1" { New-Object System.Security.Cryptography.HMACSHA1 }
            "SHA256" { New-Object System.Security.Cryptography.HMACSHA256 }
            "SHA512" { New-Object System.Security.Cryptography.HMACSHA512 }
            default { throw "Unsupported algorithm: $Algorithm" }
        }
        $HMAC.Key = $SecretBytes
        $Hash = $HMAC.ComputeHash($TimeStepBytes)

        # Extract the dynamic offset and calculate the TOTP
        $Offset = $Hash[-1] -band 0x0F
        $BinaryCode = (($Hash[$Offset] -band 0x7F) -shl 24) -bor (($Hash[$Offset + 1] -band 0xFF) -shl 16) -bor (($Hash[$Offset + 2] -band 0xFF) -shl 8) -bor ($Hash[$Offset + 3] -band 0xFF)
        $Code = $BinaryCode % [math]::Pow(10, $Digits)

        return $Code.ToString().PadLeft($Digits, '0')
    } else {
        throw "Error: TOTP secret is null or empty."
    }
}
