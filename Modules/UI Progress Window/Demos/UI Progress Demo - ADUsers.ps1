$moduleRoot = "C:\Code\PowerShell-Modules\Modules\UI Progress Window"
$uiProgressModulePath = Join-Path -Path $moduleRoot -ChildPath 'UI Progress Window.psm1'

if (!(Test-Path -Path $uiProgressModulePath)) {
    throw "UI Progress Window module not found at path: $uiProgressModulePath"
}

Import-Module ActiveDirectory, $uiProgressModulePath -Force


$users = @('200636','200546','200564','200397')
$UserCount = $users.Count
$CurrentUser = 0

$iconPath = Join-Path -Path $moduleRoot -ChildPath 'Icons\icons8-coffee-cup-26.png'

Start-UIProgressWindow `
    -WindowTitle "AD Sync" `
    -HeaderText "Processing users..." `
    -Topmost `
    -Position BottomRight `
    -ScreenTarget ActiveWindow `
    -IconPath $iconPath `
    -Theme Transparent50
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

