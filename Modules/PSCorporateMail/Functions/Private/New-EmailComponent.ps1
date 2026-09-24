function New-EmailComponent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Type,

        [Parameter()]
        [hashtable]$Properties = @{}
    )

    $Component = [PSCustomObject]@{
        Type = $Type

        Id = [guid]::NewGuid().Guid

        Metadata = [PSCustomObject]@{
            CreatedDate = Get-Date
            Version     = '1.0.0'
        }

        Properties = [PSCustomObject]$Properties
    }

    $Component.PSObject.TypeNames.Insert(
        0,
        "PSCorporateMail.Component.$Type"
    )

    return $Component
}