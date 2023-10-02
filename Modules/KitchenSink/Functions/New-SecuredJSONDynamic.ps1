<#
.SYNOPSIS
Creates a new JSON file containing secure data.

.DESCRIPTION
The New-SecuredJSONDynamic function creates a new JSON file containing secure data. 
The function encrypts the secure data and saves it to the specified file path.

.PARAMETER Filepath
Specifies the path to the JSON file to create.

.PARAMETER Params
Specifies a hashtable of key-value pairs to include in the JSON object. 
The keys in the hashtable will be used as the property names in the JSON object.

.EXAMPLE
PS C:\> $params = @{
    "Password" = "P@ssw0rd"
    "Username" = "MyUsername"
    "StudentID" = "568566"
}
PS C:\> New-SecuredJSONDynamic -Filepath "D:\Code\test4.json" -Params $params

This example creates a new JSON file at the specified file path with the specified key-value pairs.

.EXAMPLE
Another way to pass the parameters.
PS C:\> New-SecuredJSONDynamic -Filepath "D:\Code\test4.json" -Params @{"Password" = "P@$sW0rD"; "Username" = "MTestco"}

This example creates a new JSON file at the specified file path with the specified key-value pairs.

.NOTES
Author: thebleak@2023
Version: 1.0
#>
function New-SecuredJSONDynamic {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Filepath,
        [Parameter(Mandatory=$true)]
        [hashtable]$Params
    )
    
    # Create JSON object
    $Json = @{}
    foreach ($key in $Params.Keys) {
        if ($Params[$key]) {
            $Json.$key = (ConvertTo-SecureString -String $Params[$key] -AsPlainText -Force) | ConvertFrom-SecureString
        }
    }

    # Convert the JSON object to a string
    $JsonString = $Json | ConvertTo-Json

    # Write JSON object to file
    $JsonString | Out-File -FilePath $Filepath
    Write-Host "Exported JSON to $Filepath"
} # New-SecuredJSONDynamic -Filepath "D:\downloads\test4.json" -Params @{"Password" = "P@$sW0rD"; "Username" = "MTestco"}