<#
.SYNOPSIS
Send a chat-style prompt to a local Ollama model.

.DESCRIPTION
`Invoke-OllamaChat` calls the Ollama generate endpoint with a text prompt and returns
the API response. Use `Parse-OllamaResponse` to transform streamed JSON chunks into
usable fragments.

.PARAMETER Model
Model name to target (for example 'llama3').

.PARAMETER Prompt
Text prompt to send to the model.

.PARAMETER BaseUrl
Base URL of the Ollama API. Defaults to `http://localhost:11434`.

.EXAMPLE
PS C:\> Invoke-OllamaChat -Model 'llama3' -Prompt 'Is water wet?'

.EXAMPLE
PS C:\> $raw = Invoke-OllamaChat -Model 'llama3' -Prompt 'Explain recursion' -BaseUrl 'http://127.0.0.1:11434'
PS C:\> $parsed = Parse-OllamaResponse -rawResponse $raw
PS C:\> $parsed.response

.NOTES
Designed for PowerShell 5.1 compatibility.
#>
function Invoke-OllamaChat {
    param(
        [Parameter(Mandatory=$true)][string]$Model,
        [Parameter(Mandatory=$true)][string]$Prompt,
        [string]$BaseUrl = 'http://localhost:11434'
    )

    $body = @{ model = $Model; prompt = $Prompt } | ConvertTo-Json

    try {
        return Invoke-RestMethod -Uri ("$BaseUrl/api/generate") -Method Post -Body $body -ContentType 'application/json'
    } catch {
        throw ("Invoke-OllamaChat failed calling {0}: {1}" -f ("$BaseUrl/api/generate"), $_.Exception.Message)
    }
}
