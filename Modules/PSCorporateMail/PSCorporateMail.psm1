$allCommands = Join-Path $PSScriptRoot 'Functions'
$privatePath = Join-Path $PSScriptRoot 'Functions\Private'
$publicPath  = Join-Path $PSScriptRoot 'Functions\Public'

# Unblock Each Function
$AllFunctions = Get-ChildItem $allCommands -recurse
foreach ($function in $AllFunctions) {
    Unblock-File -Path $function.FullName
}

# Get Private Functions
if (Test-Path $privatePath) {
    Get-ChildItem -Path $privatePath -Filter '*.ps1' -File | ForEach-Object { . $_.FullName }
}

# Get Public Functions
$publicFiles = @()
if (Test-Path $publicPath) {
    $publicFiles = Get-ChildItem -Path $publicPath -Filter '*.ps1' -File
    $publicFiles | ForEach-Object { . $_.FullName }
}

# Export Module Members
if ($publicFiles) {
    Export-ModuleMember -Function ($publicFiles.BaseName)
}