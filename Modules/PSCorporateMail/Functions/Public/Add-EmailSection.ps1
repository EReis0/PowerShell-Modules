function Add-EmailSection {
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
        [string]$Title,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Body
    )

    process {

        $Component = New-EmailComponent `
            -Type Section `
            -Properties @{
                Title = $Title
                Body  = $Body
            }

        Add-DocumentComponent `
            -Document $Document `
            -Component $Component
    }
}