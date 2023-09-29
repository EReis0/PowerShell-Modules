<#
.SYNOPSIS
Checks for updates to PowerShell modules installed from the PowerShell Gallery.

.DESCRIPTION
The Get-ModuleUpdates function checks for updates to PowerShell modules installed from the PowerShell Gallery. 
It compares the installed version of each module to the latest version available in the gallery and reports any modules
that have updates available.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
PS C:\> Get-ModuleUpdates
Checks for updates to PowerShell modules installed from the PowerShell Gallery and reports any modules that have updates available.

.EXAMPLE
$test = Get-ModuleUpdates
clear-host
Write-Host $test -ForegroundColor Green

.NOTES
This function requires PowerShell 5.0 or later and an internet connection to access the PowerShell Gallery.

- Author: TheBleak13@2023
- Version: 1.0

#>
function Get-ModuleUpdates {
    $InstalledModules = Get-InstalledModule
    $BaseUri = "https://www.powershellgallery.com/packages/"

    $Data = @()
    foreach ($item in $InstalledModules) {
        Try{
        $PSGallery = Find-Module -Name $item.Name -Repository PSGallery | 
            Select-Object -Property Name, Version, PublishedDate, @{Name = "InstalledVersion"; Expression = {$item.Version}}
        } Catch {
            
        }
        $Row = New-Object -TypeName PSObject -Property @{
            Name = $PSGallery.Name
            Version = $PSGallery.Version
            PublishedDate = $PSGallery.PublishedDate
            InstalledVersion = $PSGallery.InstalledVersion
            UpdateAvailable = $PSGallery.Version -gt $PSGallery.InstalledVersion
            Link = $BaseUri + $PSGallery.Name
        }
        $Data += $Row
    }

    $UpdateAvailable = $Data | Where-Object -Property UpdateAvailable -eq $true

    return $UpdateAvailable | Select-Object Name,UpdateAvailable,InstalledVersion,Version,PublishedDate,Link | Sort-Object -Property Name
}


