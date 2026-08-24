function Add-DocumentComponent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [PSObject]$Document,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [PSObject]$Component
    )

    if (-not (Test-EmailDocument -Document $Document)) {
        throw 'Input object is not a valid PSCorporateMail document.'
    }

    if (-not $Document.PSObject.Properties['Components']) {
        throw 'Document does not contain a Components collection.'
    }

    if (-not $Component.PSObject.Properties['Type']) {
        throw 'Component must contain a Type property.'
    }

    if (-not $Component.PSObject.Properties['Metadata']) {
        throw 'Component must contain a Metadata property.'
    }

    if (-not $Component.PSObject.Properties['Properties']) {
        throw 'Component must contain a Properties property.'
    }

    $null = $Document.Components.Add($Component)

    return $Document
}
