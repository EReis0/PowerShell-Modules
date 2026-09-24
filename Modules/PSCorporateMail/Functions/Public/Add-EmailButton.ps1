function Add-EmailButton {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateNotNull()]
        [PSObject]$Document,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Text,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Url
    )

    process {

        $Component = New-EmailComponent `
            -Type Button `
            -Properties @{
                Text = $Text
                Url  = $Url
            }

        Add-DocumentComponent `
            -Document $Document `
            -Component $Component
    }
}