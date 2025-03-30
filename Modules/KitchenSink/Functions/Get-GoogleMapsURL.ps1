<#
.SYNOPSIS
    Generates a Google Maps URL for a given address.

.DESCRIPTION
    The `Get-GoogleMapsURL` function takes an address as input, encodes it for use in a URL, and generates a Google Maps URL. 
    It validates the URL by making a web request to ensure it is accessible.

.PARAMETER Address
    The address for which the Google Maps URL should be generated. This parameter is mandatory.

.EXAMPLE
    PS> Get-GoogleMapsURL -Address "200 S Executive Dr., Suite 1013, Brookfield, WI 53005"
    https://www.google.com/maps?q=200+S+Executive+Dr.%2C+Suite+1013%2C+Brookfield%2C+WI+53005

    This example generates a Google Maps URL for the specified address.

.EXAMPLE
    PS> Get-GoogleMapsURL -Address "1600 Amphitheatre Parkway, Mountain View, CA"
    https://www.google.com/maps?q=1600+Amphitheatre+Parkway%2C+Mountain+View%2C+CA

    This example generates a Google Maps URL for the Google headquarters address.

.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 03/30/2025
#>
function Get-GoogleMapsURL {
    param (
        [string][Parameter(Mandatory=$true)]$Address
    )

    if ($null -ne $Address) {
        $WebEncode = [System.Net.WebUtility]::UrlEncode($Address)
        $MapsURL = "https://www.google.com/maps?q=$WebEncode"
    }
    else {
        throw "Address is null or empty. Please provide a valid address."
        return $null
    }

    try {
        $Validation = (Invoke-WebRequest -Uri $MapsURL -UseBasicParsing).StatusCode
    } catch {
        throw "Error: Unable to access Google Maps URL. Please check your internet connection or the URL."
        return $null
    }

    if ($Validation -eq 200) {
        return $MapsURL
    } else {
        throw "Error: Unable to create Google Maps URL. Status code: $Validation"
        return $null
    }

}
