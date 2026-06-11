$moduleRoot = Split-Path -Parent $PSScriptRoot
$uiProgressModulePath = Join-Path -Path $moduleRoot -ChildPath 'UI Progress Window.psm1'
Import-Module ActiveDirectory, $uiProgressModulePath -Force


$users = @('200636','200546','200564','200397')
$UserCount = $users.Count
$CurrentUser = 0

 Start-UIProgressWindow `
    -WindowTitle "AD Sync" `
    -HeaderText "Processing users..." `
    -Topmost `
    -Position BottomRight `
    -ScreenTarget ActiveWindow `
    -IconPath "$CPSScriptRoot\icons\icons8-coffee-cup-26.png" `

$Data = @()
foreach ($user in $users) {
    $CurrentUser++
    
    $percent = [int](($CurrentUser / $UserCount) * 100)
    Update-UIProgressWindow -Percent $percent -StatusText "Processing user $($CurrentUser) of $($UserCount): $($user)"

    $ADRecord = Get-ADUser -filter {EmployeeID -eq $user} -Properties * | 
        Select-Object Name, SamAccountName, EmployeeID ,Enabled, LastLogonDate
   
    Start-Sleep -Seconds 2

    $Data += $ADRecord
}

Stop-UIProgressWindow -Complete -AutoCloseDelaySeconds 1
$Data

