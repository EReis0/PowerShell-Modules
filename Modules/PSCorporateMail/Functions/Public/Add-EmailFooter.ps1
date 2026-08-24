function Add-EmailFooter {

    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [object]$Document,

        [string]$Department,

        [string]$SupportEmail,

        [string]$AdditionalText
    )

    process {

        $Component = New-EmailComponent `
            -Type 'Footer' `
            -Properties ([PSCustomObject]@{
                Department     = $Department
                SupportEmail   = $SupportEmail
                AdditionalText = $AdditionalText
            })

        Add-DocumentComponent `
            -Document $Document `
            -Component $Component
    }
}