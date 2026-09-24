function Test-EmailDocument {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [object]$Document
    )

    # Verify TypeName
    if (
        $Document.PSObject.TypeNames -notcontains
        'PSCorporateMail.Document'
    ) {
        return $false
    }

    # Verify required top-level properties
    if (-not $Document.PSObject.Properties['Metadata']) {
        return $false
    }

    if (-not $Document.PSObject.Properties['Components']) {
        return $false
    }

    # Verify metadata structure
    if (-not $Document.Metadata.PSObject.Properties['Title']) {
        return $false
    }

    if (-not $Document.Metadata.PSObject.Properties['Template']) {
        return $false
    }

    if (-not $Document.Metadata.PSObject.Properties['CreatedDate']) {
        return $false
    }

    if (-not $Document.Metadata.PSObject.Properties['Version']) {
        return $false
    }

    # Verify component collection exists
    if ($null -eq $Document.Components) {
        return $false
    }

    return $true
}