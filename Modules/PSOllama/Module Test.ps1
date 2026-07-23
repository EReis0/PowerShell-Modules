Import-Module "E:\Code\Repos\PowerShell-Modules\Modules\PSOllama\PSOllama.psm1"
# Chat/generate
$raw = Invoke-OllamaChat -Model 'llama3' -Prompt 'is water wet?'
# If the response is streamed JSON text, parse it:
$parsed = Parse-OllamaResponse -rawResponse $raw
$parsed.response          # full combined text
$parsed.fragments         # table of fragments
$parsed.fragments[0].Response

# Embeddings
$emb = Invoke-OllamaEmbedding -Model 'text-embedding-model' -Input @('text one','text two')
$emb                      # parsed JSON from the embeddings endpoint

# Models
Get-OllamaModel           # list installed models
Get-OllamaModel -Name 'llama3'  # single model info

# Remove a model (prompts for confirmation unless -Force)
Remove-OllamaModel -Name 'some-model'