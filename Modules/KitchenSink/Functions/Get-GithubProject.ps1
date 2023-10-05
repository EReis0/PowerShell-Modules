<#
.SYNOPSIS
    Downloads and extracts a zip file from a specified URL to a specified output folder.
.DESCRIPTION
    The Get-GithubProject function downloads a zip file from a specified URL and extracts it to a specified output folder. The function creates a temporary file with a .zip extension, downloads the file from the URL using Invoke-WebRequest, extracts the contents of the file to the output folder using Expand-Archive, and then removes the temporary file.
.PARAMETER url
    Specifies the URL of the zip file to download.
.PARAMETER output
    Specifies the output folder where the contents of the zip file will be extracted.
.EXAMPLE
    Get-GithubProject -url "https://github.com/EReis0/PowerShell-Modules/archive/refs/heads/main.zip" -output "C:\Users\thebl\Documents\New folder"
    Downloads the zip file from the specified URL and extracts its contents to the specified output folder.
    **Copy the URL for the zip file from the GitHub repository.**
.NOTES
    Author: Codeholics - Eric Reis (https://github.com/EReis0)
    Date: 5/25/2022
#>
function Get-GithubProject {
    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $true)]
        [string]$url,

        [parameter(Mandatory = $true)]
        [string]$output
    )
    try {
        # create temp with zip extension (or Expand will complain)
        $tmp = New-TemporaryFile | Rename-Item -NewName {$_ -replace 'tmp$', 'zip' } -PassThru
        #download
        Invoke-WebRequest -outFile $tmp $url
        #exract to same folder
        $tmp | Expand-Archive -DestinationPath $output -force
        # remove temporary file
        $tmp | remove-item
    }catch {
        $_.Error
    }
}