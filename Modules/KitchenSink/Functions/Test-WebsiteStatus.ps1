<#
.SYNOPSIS
    Tests the status of a website by checking if it is reachable and if specific text is present on the page.

.DESCRIPTION
    The Test-WebsiteStatus function tests the status of a website by checking if it is reachable and if specific text is present on the
    page. If the website is reachable and the expected text is present, the function returns a message indicating that the website is
    online and functioning correctly. If the website is reachable but the expected text is not present, the function returns a message
    indicating that the website is online but may not be functioning correctly. If the website is not reachable, the function returns
    a message indicating that the website is offline.

.PARAMETER Url
    The URL of the website to test.

.PARAMETER ExpectedText
    The text that should be present on the website.

.EXAMPLE
    Test-WebsiteStatus -Url "www.google.com" -ExpectedText "Google"

    This example tests the status of the website "www.google.com" and checks if the text "Google" is present on the page.

    Url            ExpectedText Online ExpectedTextPresent
    ---            ------------ ------ -------------------
    www.google.com Google         True                True


.NOTES
    Author: Codeholics - Eric Reis (https://github.com/EReis0/)
    Date: 02/06/2024
    Version: 1.1
#>
function Test-WebsiteStatus {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Url,
        [Parameter(Mandatory=$false)]
        [string]$ExpectedText
    )

    # Test the reachability of the website using Test-NetConnection
    try {
    $result = Test-NetConnection -ComputerName $Url -Port 80 -ErrorAction SilentlyContinue
    } catch {
            $_.Exception.Message
        return
    }

    # Check if the website is reachable
    if ($result.TcpTestSucceeded) {
        # Retrieve the content of the website using Invoke-WebRequest
        $response = Invoke-WebRequest -Uri $Url

        # Check if the expected text is present on the page
        if ($ExpectedText -and $response.Content -like "*$ExpectedText*") {
            # The expected text is present on the page and the website is reachable
            $Online = $true
            $ExpectedTextPresent = $true
        } else {
            # The expected text is not present on the page
            $Online = $true
            $ExpectedTextPresent = $false
        }
    } else {
        # The website is not reachable
        $Online = $false
        $ExpectedTextPresent = $false
    }
    # Return the results
    return [PSCustomObject]@{
        Url = $Url
        ExpectedText = $ExpectedText
        Online = $Online
        ExpectedTextPresent = $ExpectedTextPresent
    }
}   # Test-WebsiteStatus -Url "codeholics.com" -ExpectedText "2022 Codeholics"