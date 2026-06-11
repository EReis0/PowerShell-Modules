# script-scoped variable so all functions can read and write the same window context
$script:InstallProgressContext = $null

# Path to the Functions directory
$functionPath = Join-Path -Path $PSScriptRoot -ChildPath 'Functions'
Get-ChildItem -Path $functionPath -Filter '*.ps1' -File | ForEach-Object {
    . $_.FullName
}