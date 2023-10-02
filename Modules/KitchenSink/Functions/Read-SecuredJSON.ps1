<#
.SYNOPSIS
Reads a JSON file containing secure data and returns an object with decrypted properties.

.DESCRIPTION
The Read-SecuredJSON function reads a JSON file containing secure data and returns an object with decrypted properties. 
The function decrypts the secure data in the JSON file and returns the decrypted values as plain text.

.PARAMETER Path
Specifies the path to the JSON file containing the secure data. The file must have a .json extension.

.EXAMPLE
Plain text values
PS C:\> $data = Read-SecuredJSON -Path "D:\Code\test4.json"
PS C:\> $Password = $data.Password

Convert plain text values to secure strings
$Data = Read-SecuredJSON -Path "D:\Code\test4.json"
$Password = $data.Password | ConvertTo-SecureString -AsPlainText -Force

This example reads the secure data from the "test4.json" file and sets the `$Password` variable to the decrypted value of the "Password" property.

.NOTES
Author: Codeholics - Eric Reis
Version: 1.0

.LINK
https://github.com/EReis0/PowerShell-Samples/
#>
function Read-SecuredJSON {
    [cmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ -PathType Leaf -Include "*.json" })]
        [string]$Path
    )

    $json = get-content $Path | ConvertFrom-Json

    $SecuredData = [PSCustomObject]@{}
    foreach ($property in $json.PSObject.Properties) {
        if ([string]::IsNullOrWhiteSpace($property.Value) -eq $false) {
            $SecuredData | Add-Member -MemberType NoteProperty -Name $property.Name -Value ([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR(($property.Value | ConvertTo-SecureString))))
        }
    }
    return $SecuredData
} # $Data = Read-SecuredJSON -Path "D:\Code\test4.json"



