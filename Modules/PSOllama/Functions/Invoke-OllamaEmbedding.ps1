<#
.SYNOPSIS
Request vector embeddings from a local Ollama model.

.DESCRIPTION
`Invoke-OllamaEmbedding` posts text to the Ollama embeddings endpoint and returns
the JSON result. Accepts a single string or an array of strings for batch embedding.

.PARAMETER Model
Model name that produces embeddings (string).

.PARAMETER Input
A string or string[] containing text to embed.

.PARAMETER BaseUrl
Base URL of the Ollama API. Defaults to `http://localhost:11434`.

.EXAMPLE
PS C:\> Invoke-OllamaEmbedding -Model 'text-embedding-model' -Input 'hello world'

.EXAMPLE
PS C:\> Invoke-OllamaEmbedding -Model 'text-embedding-model' -Input @('a','b','c')

.NOTES
Returns the object produced by `Invoke-RestMethod` (parsed JSON). Designed for PS 5.1.
#>
function Invoke-OllamaEmbedding {
    param(
        [Parameter(Mandatory=$true)][string]$Model,
        [Parameter(Mandatory=$true)][Object]$Input,
        [string]$BaseUrl = 'http://localhost:11434'
    )

    # Prepare body. Input can be a single string or an array of strings.
    $body = @{ model = $Model; input = $Input } | ConvertTo-Json -Depth 5

    try {
        return Invoke-RestMethod -Uri ("$BaseUrl/api/embeddings") -Method Post -Body $body -ContentType 'application/json'
    } catch {
        throw ("Invoke-OllamaEmbedding failed calling {0}: {1}" -f ("$BaseUrl/api/embeddings"), $_.Exception.Message)
    }
}
