<#
.SYNOPSIS
    A function to create a password file or validate a password against a file.

.DESCRIPTION
    The New-CredsTxtFile function prompts the user for a password and saves it to a file, or validates a password against a file. 
    If the -ValidateOnly parameter is specified, the function validates the password against the file. 
    If the -ValidateOnly parameter is not specified, the function prompts the user for a password and saves it to the file.

.PARAMETER Filepath
    The path of the file to save the password to or validate the password against.

.PARAMETER ValidateOnly
    If specified, the function validates the password against the file. 
    If not specified, the function prompts the user for a password and saves it to the file.

.EXAMPLE
    New-CredsTxtFile -Filepath "C:\creds\sample55.txt" -ValidateOnly $true

    This command validates the password entered by the user against the password in the file at C:\creds\sample55.txt.

.EXAMPLE
    New-CredsTxtFile -Filepath "C:\creds\sample55.txt"

    This command prompts the user for a password and saves it to the file at C:\creds\sample55.txt.
.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.2
    Date: 02/02/2024
.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
function New-CredsTxtFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Filepath,
        [Parameter(Mandatory=$false)]
        [bool]$ValidateOnly = $false
    )

    # If -validateonly is not specified, prompt for password and save it to file
    if ($ValidateOnly -eq $false) {

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
        Write-Host "Exporting Password to $Filepath" -foregroundcolor green
        ConvertTo-SecureString -String $Password -AsPlainText -Force | ConvertFrom-SecureString | Out-File $Filepath -Encoding UTF8
    # If -validateonly is specified, validate the file
    } elseif ($ValidateOnly -eq $true) {

        # Verify file path exists
        $PathValidation = Test-Path -Path $Filepath
        if ($PathValidation -eq $false) {
            Write-Warning "File does not exist. Please specify a valid file path."
            return
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
        $SecureString = ConvertTo-SecureString -String (Get-Content $Filepath)
        $SecretContent = [System.Net.NetworkCredential]::new("", $SecureString).Password

        # Compare the password for a match
        if ($SecretContent -eq $Password) {
            Write-Host "Password MATCHED decrypted password." -foregroundcolor green
        } else {
            Write-Warning "Password DID NOT MATCH decrypted password."
        }
    }
}  # New-CredsTxtFile -Filepath "C:\creds\sample.txt" -ValidateOnly $true