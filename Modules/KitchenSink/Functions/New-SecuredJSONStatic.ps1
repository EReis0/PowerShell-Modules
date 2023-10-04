<#
.SYNOPSIS
Creates a new JSON file containing secure data.

.DESCRIPTION
The New-SecuredJSONStatic function creates a new JSON file containing secure data. The function encrypts the secure data and saves it to the specified file path.

.PARAMETER Filepath
Specifies the path to the JSON file to create.

.PARAMETER Password
Specifies the password to include in the JSON object.

.PARAMETER Username
Specifies the username to include in the JSON object.

.PARAMETER URL
Specifies the URL to include in the JSON object.

.PARAMETER IP
Specifies the IP address to include in the JSON object.

.PARAMETER Email
Specifies the email address to include in the JSON object.

.PARAMETER Token
Specifies the token to include in the JSON object.

.PARAMETER ClientID
Specifies the client ID to include in the JSON object.

.PARAMETER ClientSecret
Specifies the client secret to include in the JSON object.

.EXAMPLE
PS C:\> New-SecuredJSONStatic -Filepath "D:\Code\test4.json" -Password "P@ssw0rd" -Username "MyUsername" -Email "jdoe@sample.com"

This example creates a new JSON file at the specified file path with the specified key-value pairs.

.NOTES
Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
Version: 1.0

.LINK
https://github.com/EReis0/PowerShell-Samples/
#>
function New-SecuredJSONStatic {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Filepath,
        [Parameter(Mandatory=$true)]
        [string]$Password,
        [Parameter(Mandatory=$false)]
        [string]$Username,
        [Parameter(Mandatory=$false)]
        [string]$URL,
        [Parameter(Mandatory=$false)]
        [string]$IP,
        [Parameter(Mandatory=$false)]
        [string]$Email,
        [Parameter(Mandatory=$false)]
        [string]$Token,
        [Parameter(Mandatory=$false)]
        [string]$ClientID,
        [Parameter(Mandatory=$false)]
        [string]$ClientSecret
    )
    
    # Create JSON object
    $Json = @{}
    foreach ($param in "Password", "Username", "URL", "IP", "Email", "Token", "ClientID", "ClientSecret") {
        if ($PSBoundParameters.$param) {
            $Json.$param = (ConvertTo-SecureString -String $PSBoundParameters.$param -AsPlainText -Force) | ConvertFrom-SecureString
        }
    }

    # Convert the JSON object to a string
    $JsonString = $Json | ConvertTo-Json

    # Write JSON object to file
    $JsonString | Out-File -FilePath $Filepath
    Write-Host "Exported JSON to $Filepath" -ForegroundColor Green
} # New-SecuredJSONStatic -Filepath "D:\Code\test4.json" -Password "P@ssw0rd" -Username "MyUsername" -Email "EReis@loandepot.com"