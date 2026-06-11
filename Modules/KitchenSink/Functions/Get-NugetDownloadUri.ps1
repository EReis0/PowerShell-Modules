<#
    .SYNOPSIS
    Gets the NuGet package download URI for a package, optionally for a specific version.

    .DESCRIPTION
    Builds the NuGet package page URI, requests the page content, and extracts the
    manual download link (the .nupkg link) from the page markup.

    If Version is provided, the function targets that exact package version page.
    If Version is omitted, the function targets the package page and returns the
    current manual download link.

    .PARAMETER PackageName
    The NuGet package ID, for example System.Data.SQLite.

    .PARAMETER Version
    Optional package version to target, for example 2.0.3.

    .OUTPUTS
    System.String
    Returns an absolute HTTPS URI to the package download endpoint.

    .EXAMPLE
    Get-NugetDownloadUri -PackageName "System.Data.SQLite"
    Returns the manual download URI from the package page.

    .EXAMPLE
    Get-NugetDownloadUri -PackageName "System.Data.SQLite" -Version "2.0.3"
    Returns the manual download URI for the specified package version page.

    .NOTES
    Requires internet access to nuget.org.
#>
function Get-NugetDownloadUri {
    param (
        [Parameter(Mandatory = $true)]
        [string]$PackageName,

        [Parameter(Mandatory = $false)]
        [string]$Version
    )

    # If a version is specified, construct the URI for that specific version. 
    # Otherwise, construct the URI for the latest version of the package.
    if ($Version) {
        $Uri = "https://www.nuget.org/packages/$PackageName/$Version"
    } else {
        $Uri = "https://www.nuget.org/packages/$PackageName"
    }

    # Make a web request to the package page and parse the response to find the download link for the .nupkg file. 
    # The download link is identified by looking for an anchor tag with a data-track attribute
    $response = Invoke-WebRequest $Uri -UseBasicParsing

    # The download link is identified by looking for an anchor tag with a data-track attribute of "outbound-manual-download".
    $downloadUri = $response.Links |
        Where-Object { $_.outerHTML -match 'data-track\s*=\s*["'']outbound-manual-download["'']' } |
        Select-Object -First 1 -ExpandProperty href

    # If the download URI is not found, throw an error.
    if ([string]::IsNullOrWhiteSpace($downloadUri)) {
        throw "Could not find outbound-manual-download link."
    }

    # If the download URI does not start with "http://" or "https://", prepend "https://www.nuget.org" to the URI.
    if ($downloadUri -notmatch '^https?://') {
        $downloadUri = "https://www.nuget.org$downloadUri"
    }

    return $downloadUri
} # Get-NugetDownloadUri -PackageName "System.Data.SQLite"