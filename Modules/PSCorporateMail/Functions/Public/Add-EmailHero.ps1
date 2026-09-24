function Add-EmailHero {
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

        [string]$Subtitle,

        [ValidateSet(
            'Default',
            'Info',
            'Success',
            'Warning',
            'Critical'
        )]
        [string]$Severity = 'Default'
    )

    process {

        $Component = New-EmailComponent `
            -Type Hero `
            -Properties @{
                Title    = $Title
                Subtitle = $Subtitle
                Severity = $Severity
            }

        Add-DocumentComponent `
            -Document $Document `
            -Component $Component
    }
}