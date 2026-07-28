Import-Module "E:\Code\Repos\PowerShell-Modules\Modules\PSOllama\PSOllama.psm1"

$sample = Get-Process | Select-Object Name, Id, CPU, WorkingSet
$input_sample = $sample | ConvertTo-Json -Depth 5

# Get response from Ollama (uncomment or replace this line to call live)
$rawResponse = Invoke-Ollama -Model "llama3" -Prompt "Analyze the following process list and summarize anything unusual: $input_sample"

# For testing purposes, you can use the JSON generated from the sample processes
# $rawResponse = $input_sample
$response = Parse-OllamaResponse -rawResponse $rawResponse

Write-Host "$($response.response)"