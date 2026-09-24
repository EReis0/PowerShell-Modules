function Add-EmailAlert {

    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [object]$Document,

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
            -Type 'Alert' `
            -Properties ([PSCustomObject]@{
                Message  = $Message
                Severity = $Severity
            })

        Add-DocumentComponent `
            -Document $Document `
            -Component $Component
    }
}