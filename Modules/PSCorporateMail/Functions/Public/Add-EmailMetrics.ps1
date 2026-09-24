function Add-EmailMetrics {

    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [object]$Document,

        [Parameter(Mandatory)]
        [hashtable]$Metrics
    )

    process {

        $Component = New-EmailComponent `
            -Type 'Metrics' `
            -Properties ([PSCustomObject]@{
                Metrics = $Metrics
            })

        Add-DocumentComponent `
            -Document $Document `
            -Component $Component
    }
}