function Export-EmailHtml {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Document
    )

    Test-EmailDocument -Document $Document

    $Theme = Get-Theme -Name $Document.Metadata.Template

    return ConvertTo-DocumentHtml `
        -Document $Document `
        -Theme $Theme
}