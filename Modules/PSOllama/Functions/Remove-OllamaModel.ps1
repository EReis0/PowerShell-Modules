<#
.SYNOPSIS
Uninstall a local Ollama model.

.DESCRIPTION
`Remove-OllamaModel` calls the Ollama API to remove a locally installed model.
By default it prompts for confirmation; pass `-Force` to skip the prompt.

.PARAMETER Name
Name of the model to remove (required).

.PARAMETER BaseUrl
Base URL of the Ollama API. Defaults to `http://localhost:11434`.

.PARAMETER Force
If specified, skip interactive confirmation and proceed.

.EXAMPLE
PS C:\> Remove-OllamaModel -Name 'old-model'

.EXAMPLE
PS C:\> Remove-OllamaModel -Name 'old-model' -Force

.NOTES
This function is intentionally conservative and asks for confirmation unless
`-Force` is passed. It uses the `/api/models/{name}` delete endpoint.
#>
function Remove-OllamaModel {
    param(
        [Parameter(Mandatory=$true)][string]$Name,
        [string]$BaseUrl = 'http://localhost:11434',
        [switch]$Force
    )

    if (-not $Force) {
        $ok = Read-Host "Remove model '$Name'? Type 'yes' to confirm"
        if ($ok -ne 'yes') { Write-Host 'Aborted.'; return }
    }

    try {
        return Invoke-RestMethod -Uri ("$BaseUrl/api/models/$Name") -Method Delete
    } catch {
        throw ("Remove-OllamaModel failed calling {0}: {1}" -f ("$BaseUrl/api/models/$Name"), $_.Exception.Message)
    }
}
