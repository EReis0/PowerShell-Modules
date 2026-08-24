function New-EmailDocument {
    <#
    .SYNOPSIS
        Creates a new email document object.

    .DESCRIPTION
        Creates the root PSCorporateMail document object used by all
        email components and renderers.

    .PARAMETER Title
        Main document title.

    .PARAMETER Subtitle
        Optional document subtitle.

    .PARAMETER Template
        Theme template to use.

    .EXAMPLE
        $Mail = New-EmailDocument `
            -Title 'Termination SafeGuard' `
            -Subtitle 'Daily Compliance Report' `
            -Template Automation

    .OUTPUTS
        PSCorporateMail.Document
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Title,

        [Parameter()]
        [string]$Subtitle,

        [Parameter()]
        [ValidateSet(
            'ServiceDesk',
            'Automation',
            'Compliance',
            'Executive'
        )]
        [string]$Template = 'ServiceDesk'
    )

    [PSCustomObject]@{
        PSTypeName = 'PSCorporateMail.Document'

        Metadata = [PSCustomObject]@{
            Title       = $Title
            Subtitle    = $Subtitle
            Template    = $Template
            CreatedDate = Get-Date
            Version     = '1.0.0'
        }

        Components = New-Object System.Collections.Generic.List[object]
    }
}