# script-scoped variable so all functions can read and write the same window context
$script:InstallProgressContext = $null

# Path to the Functions directory
$functionpath = $PSScriptRoot + "\Functions\"

# List of All Functions found within the directory
$functionlist = Get-ChildItem -Path $functionpath -Name

# Loop Over All Function Files and Dot Source Them Into Memory
ForEach ($function in $functionlist) {

    . ($functionpath + $function)
}