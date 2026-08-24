function Add-EmailTable {

    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [object]$Document,

        [Parameter(Mandatory)]
        [object[]]$Data,

        [string[]]$Columns
    )

    process {

        $Component = New-EmailComponent `
            -Type 'Table' `
            -Properties ([PSCustomObject]@{
                Data    = $Data
                Columns = $Columns
            })

        Add-DocumentComponent `
            -Document $Document `
            -Component $Component
    }
}
