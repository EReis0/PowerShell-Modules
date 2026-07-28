<#
.SYNOPSIS
Get information about installed Ollama models.

.DESCRIPTION
`Get-OllamaModel` retrieves either a list of installed models or details for a
single model. The function attempts several common endpoint paths to support
different Ollama versions/configurations.

.PARAMETER Name
Optional model name to fetch details for. If omitted, returns all models.

.PARAMETER BaseUrl
Base URL of the local Ollama API. Defaults to `http://localhost:11434`.

.EXAMPLE
PS C:\> Get-OllamaModel

.EXAMPLE
PS C:\> Get-OllamaModel -Name 'llama3'

.EXAMPLE
PS C:\> Get-OllamaModel -BaseUrl 'http://127.0.0.1:11434'

.NOTES
This function is PowerShell 5.1 compatible and will try several endpoint
variants such as `/api/models`, `/models`, `/v1/models`, and `/api/v1/models`.
#>
function Get-OllamaModel {
    param(
        [string]$Name,
        [string]$BaseUrl = 'http://localhost:11434'
    )

    # Try common endpoint variants to support differing Ollama versions/configs
    $endpoints = @('/api/models','/models','/v1/models','/api/v1/models')

    foreach ($ep in $endpoints) {
        if ([string]::IsNullOrWhiteSpace($Name)) {
            $uri = "$BaseUrl$ep"
        } else {
            $uri = "$BaseUrl$ep/$Name"
        }

        try {
            $resp = Invoke-RestMethod -Uri $uri -Method Get
            Write-Verbose ("Get-OllamaModel: successful response from {0}" -f $uri)
            return $resp
        } catch {
            # If 404, try the next endpoint; otherwise rethrow with context
            $we = $_.Exception
            $status = $null
            try {
                if ($we.Response -ne $null) { $status = [int]$we.Response.StatusCode }
            } catch { }

            if ($status -eq 404) {
                continue
            } else {
                throw ("Get-OllamaModel failed calling {0}: {1}" -f $uri, $_.Exception.Message)
            }
        }
    }

    throw ("Get-OllamaModel failed: endpoints returned 404 or were not reachable. Tried: {0} at {1}" -f ($endpoints -join ', '), $BaseUrl)
}
