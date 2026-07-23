<#
.SYNOPSIS
Sends a simple prompt to a locally running Ollama model using the generate endpoint.

.DESCRIPTION
`Invoke-Ollama` posts a prompt to the Ollama HTTP API and returns the parsed result
from `Invoke-RestMethod`. Designed to be compatible with PowerShell 5.1.

.PARAMETER Model
The Ollama model name to use (for example: "llama3").

.PARAMETER Prompt
The text prompt to send to the model.

.PARAMETER BaseUrl
The base URL for the local Ollama API. Defaults to `http://localhost:11434`.

.EXAMPLE
PS C:\> Invoke-Ollama -Model 'llama3' -Prompt 'Summarize current CPU usage'

.EXAMPLE
PS C:\> Invoke-Ollama -Model 'llama3' -Prompt 'Hello' -BaseUrl 'http://127.0.0.1:11434'

.NOTES
This function is intentionally minimal; use `Invoke-OllamaChat` for clearer intent
or `Parse-OllamaResponse` to process streamed JSON chunks.
#>
function Invoke-Ollama {
    param(
        [Parameter(Mandatory=$true)][string]$Model,
        [Parameter(Mandatory=$true)][string]$Prompt,
        [string]$BaseUrl = 'http://localhost:11434'
    )

    $body = @{ model = $Model; prompt = $Prompt } | ConvertTo-Json

    try {
        return Invoke-RestMethod -Uri ("$BaseUrl/api/generate") -Method Post -Body $body -ContentType 'application/json'
    } catch {
        throw ("Invoke-Ollama failed calling {0}: {1}" -f ("$BaseUrl/api/generate"), $_.Exception.Message)
    }
}