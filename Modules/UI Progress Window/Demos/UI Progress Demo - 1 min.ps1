$moduleRoot = Split-Path -Parent $PSScriptRoot
$iconPath = Join-Path -Path $moduleRoot -ChildPath 'Icons\icons8-coffee-cup-26.png'

Import-Module (Join-Path -Path $moduleRoot -ChildPath 'UI Progress Window.psm1') -Force

# Data-driven style: update by work item progress
Start-UIProgressWindow `
    -WindowTitle "One Minute Progress" `
    -HeaderText "Running 1-minute demo..." `
    -Topmost `
    -IconPath $iconPath `
    -Position BottomRight `
    -ScreenTarget ActiveWindow

for ($i = 1; $i -le 60; $i++) {
    $percent = [int](($i / 60) * 100)
    Update-UIProgressWindow -Percent $percent -StatusText "$i of 60"
    Start-Sleep -Seconds 1
}

Stop-UIProgressWindow -Complete -AutoCloseDelaySeconds 1