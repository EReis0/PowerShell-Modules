# UI Progress Window

A lightweight PowerShell module for showing a modeless WPF progress window during script execution.

## What This Module Does

- Opens a reusable progress window from your script
- Updates progress and status text while work is running
- Supports timed demo mode and data-driven updates
- Supports window positioning (center/corners)
- Supports screen targeting (active cursor screen, active window screen, primary screen)
- Supports custom title-bar icon

## Module Structure

- `UI Progress Window.psm1`
- Functions/`Start-UIProgressWindow.ps1`
- Functions/`Update-UIProgressWindow.ps1`
- Functions/`Stop-UIProgressWindow.ps1`
- Functions/`Show-UIProgressWindow.ps1`
- Demos/`UI Progress Demo - 1 min.ps1`
- Demos/`UI Progress Demo - ADUsers.ps1`

## Import

```powershell
Import-Module "C:\Code\PowerShell-Modules\Modules\UI Progress Window\UI Progress Window.psm1" -Force
```

## Core Workflow (Recommended)

Use Start/Update/Stop for real workloads (AD users, API calls, file operations, etc.).

```powershell
Start-UIProgressWindow -WindowTitle "AD Sync" -HeaderText "Processing users..." -Topmost

for ($i = 1; $i -le 10; $i++) {
    $percent = [int](($i / 10) * 100)
    Update-UIProgressWindow -Percent $percent -StatusText "$i of 10"
    Start-Sleep -Milliseconds 500
}

Stop-UIProgressWindow -Complete -AutoCloseDelaySeconds 1
```

## Functions

### Start-UIProgressWindow
Creates and shows the modeless progress window.

Parameters:
- WindowTitle
- HeaderText
- Topmost
- Position: Center, TopLeft, TopRight, BottomLeft, BottomRight
- OffsetX
- OffsetY
- ScreenTarget: ActiveCursor, ActiveWindow, Primary
- IconPath

Example:

```powershell
Start-UIProgressWindow `
    -WindowTitle "One Minute Progress" `
    -HeaderText "Running 1-minute demo..." `
    -Topmost `
    -Position BottomRight `
    -ScreenTarget ActiveWindow `
    -IconPath "C:\Icons\sync.ico"
```

### Update-UIProgressWindow
Updates the progress bar and status text.

Parameters:
- Percent (0-100)
- StatusText

Example:

```powershell
Update-UIProgressWindow -Percent 42 -StatusText "42 of 100 users"
```

### Stop-UIProgressWindow
Completes (optional) and closes the window.

Parameters:
- Complete
- AutoCloseDelaySeconds

Example:

```powershell
Stop-UIProgressWindow -Complete -AutoCloseDelaySeconds 1
```

### Show-UIProgressWindow
Convenience wrapper that runs a timed progress flow from 0 to 100.

Parameters include:
- WindowTitle, HeaderText
- Position, OffsetX, OffsetY
- ScreenTarget
- IconPath
- StepPercent, IntervalSeconds, DurationSeconds
- Topmost
- AutoClose, AutoCloseDelaySeconds

Example:

```powershell
Show-UIProgressWindow `
    -WindowTitle "Quick Test" `
    -HeaderText "Please wait..." `
    -DurationSeconds 10 `
    -Position TopRight `
    -ScreenTarget ActiveWindow `
    -Topmost `
    -AutoClose
```

## Demos

Run the included demos:

```powershell
& "C:\Code\PowerShell-Modules\Modules\UI Progress Window\Demos\UI Progress Demo - 1 min.ps1"
& "C:\Code\PowerShell-Modules\Modules\UI Progress Window\Demos\UI Progress Demo - ADUsers.ps1"
```

## Get-Help

All functions include comment-based help.

```powershell
Get-Help Start-UIProgressWindow -Full
Get-Help Update-UIProgressWindow -Examples
Get-Help Stop-UIProgressWindow -Full
Get-Help Show-UIProgressWindow -Full
```

## Notes

- If your script already has a window open, starting a new one will close the previous window context.
- The window is modeless, so your script keeps running while updates are applied.
- For title-bar icons, .ico files are recommended.
