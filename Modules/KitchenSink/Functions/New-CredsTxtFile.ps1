<#
.SYNOPSIS
    Exports a password to a file in UTF8 encoding and validates the file.
.DESCRIPTION
    Exports a password to a file in UTF8 encoding and validates the file. The function converts the password to a secure string and then to an encrypted standard string using the ConvertTo-SecureString and ConvertFrom-SecureString cmdlets. The encrypted string is then written to a file using the Out-File cmdlet. The function also validates the file by comparing the decrypted password to the original password.
.PARAMETER Filepath
    Specifies the path and filename of the file to export the password to.
.PARAMETER Password
    Specifies the password to export.
.PARAMETER ValidateOnly
    Only validates if the encypted password in the file matches the specified password. 
    Using this parameter will not export the password to the file.
    If you use this parameter you will need to specify the value as $true to validate only.
.EXAMPLE
    PS C:\> New-CredsTxtFile -Filepath "C:\Temp\password.txt" -Password "MyPassword123"
    Exports the password "MyPassword123" to the file "C:\Temp\password.txt" in UTF8 encoding and validates the file.
.EXAMPLE
    PS C:\> New-CredsTxtFile -Filepath "C:\Temp\password.txt" -Password "MyPassword123" -ValidateOnly
    Validates the file "C:\Temp\password.txt" by comparing the decrypted password to the original password.
.NOTES
    This function exports a password to a file in UTF8 encoding and validates the file. The function converts the password to a secure string and then to an encrypted standard string using the ConvertTo-SecureString and ConvertFrom-SecureString cmdlets. The encrypted string is then written to a file using the Out-File cmdlet. The function also validates the file by comparing the decrypted password to the original password.
    
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 01/16/2024

    This function is not really needed but a good way to create and validate a password file in a consistent manner.
.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
function New-CredsTxtFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Filepath,
        [Parameter(Mandatory=$true)]
        [string]$Password,
        [Parameter(Mandatory=$false)]
        [bool]$ValidateOnly = $false
    )
    
    if ($ValidateOnly -eq $false) {
    # Save the password
    Write-Host "Exporting Password to $Filepath" -foregroundcolor green
    ConvertTo-SecureString -String $Password -AsPlainText -Force | ConvertFrom-SecureString | Out-File $Filepath -Encoding UTF8
    }

    # Verify password file
    $SecureString = ConvertTo-SecureString -String (Get-Content $Filepath)
    $Pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
    $SecretContent = [Runtime.InteropServices.Marshal]::PtrToStringAuto($Pointer)

    # Display the password in plain text
    # $SecretContent

    # Compare the password for a match
    if ($SecretContent -eq $Password) {
        Write-Host "Password MATCHED decrypted password." -foregroundcolor green
    } else {
        Write-Warning "Password DID NOT MATCH decrypted password."
    }
}  # New-CredsTxtFile -Filepath "C:\creds\sample.txt" -Password "P@ssw0rd" -ValidateOnly $true


