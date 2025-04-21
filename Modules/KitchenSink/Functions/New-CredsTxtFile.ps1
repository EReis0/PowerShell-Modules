<#
.SYNOPSIS
    A function to create a password file or validate a password against a file.

.DESCRIPTION
    The `New-CredsTxtFile` function prompts the user for a password and saves it to a file, or validates a password against a file. 
    If the `-Validate` parameter is specified, the function validates the password entered by the user against the password stored in the file. 
    If the `-Validate` parameter is not specified, the function prompts the user for a password and securely saves it to the specified file.

    The password is encrypted when saved to the file and decrypted during validation. 
    The function ensures that the file exists before validation and provides meaningful error messages for invalid or corrupted files.

.PARAMETER Filepath
    The path of the file to save the password to or validate the password against.
    This parameter is mandatory.

.PARAMETER Validate
    If specified, the function validates the password entered by the user against the password stored in the file.
    If not specified, the function prompts the user for a password and saves it to the file.

.EXAMPLE
    New-CredsTxtFile -Filepath "C:\creds\sample55.txt"

    This command prompts the user for a password and saves it to the file at `C:\creds\sample55.txt`.

.EXAMPLE
    New-CredsTxtFile -Filepath "C:\creds\sample55.txt" -Validate

    This command validates the password entered by the user against the password stored in the file at `C:\creds\sample55.txt`.

.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.3
    Date: 04/21/2025

.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
function New-CredsTxtFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Filepath,
        [Parameter(Mandatory=$false)]
        [switch]$Validate
    )

    # If -Validate is specified, validate the file
    if ($Validate) {
        # Verify file path exists
        if (-not (Test-Path -Path $Filepath)) {
            throw "File does not exist: $Filepath. Please specify a valid file path."
        }

        # Prompt for password
        $Credential = Get-Credential -Message "Enter your password" -UserName "Admin"
        
        # If the credential prompt is cancelled, exit the function
        if ($null -eq $Credential) {
            Write-Warning "Credential prompt was cancelled. Exiting..."
            return
        } else {
            $Password = $Credential.GetNetworkCredential().Password
        }

        # Verify password file
        try {
            $SecureString = ConvertTo-SecureString -String (Get-Content $Filepath)
        } catch {
            throw "The password file is invalid or corrupted: $($_.Exception.Message)"
        }

        $SecretContent = [System.Net.NetworkCredential]::new("", $SecureString).Password

        # Compare the password for a match
        if ($SecretContent -eq $Password) {
            Write-Host "Password MATCHED decrypted password." -ForegroundColor Green
        } else {
            Write-Warning "Password DOES NOT MATCH decrypted password."
        }
    } else {
        # Prompt for password
        $Credential = Get-Credential -Message "Enter your password" -UserName "Admin"

        # If the credential prompt is cancelled, exit the function
        if ($null -eq $Credential) {
            Write-Warning "Credential prompt was cancelled. Exiting..."
            return
        } else {
            $Password = $Credential.GetNetworkCredential().Password
        }

        # Save the password
        Write-Host "Exporting Password to $Filepath" -ForegroundColor Green
        ConvertTo-SecureString -String $Password -AsPlainText -Force | ConvertFrom-SecureString | Out-File $Filepath -Encoding UTF8
    }
}  # New-CredsTxtFile -Filepath "C:\creds\sample.txt" -Validate