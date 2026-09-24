function Add-EmailInfoBox {

    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [object]$Document,

        [Parameter(Mandatory)]
        [string]$Title,

        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet(
            'Info',
            'Success',
            'Warning',
            'Critical'
        )]
        [string]$Severity = 'Info'
    )

    process {

        $Component = New-EmailComponent `
            -Type 'InfoBox' `
            -Properties ([PSCustomObject]@{
                Title    = $Title
                Message  = $Message
                Severity = $Severity
            })

        Add-DocumentComponent `
            -Document $Document `
            -Component $Component

        return $Document
    }
}