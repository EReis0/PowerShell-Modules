function Get-MDFileArray {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript({ Test-Path $_ -PathType 'Container' })]
        [string]$Path
    )

    Get-ChildItem -Path $Path -Recurse -File -Filter *.md |
        Select-Object Name, FullName
}