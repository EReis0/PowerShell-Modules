<#
.SYNOPSIS
Shows and drives a timed UI progress window from 0 to 100.

.DESCRIPTION
Convenience wrapper that starts the UI progress window, updates progress on a
timer, and optionally closes it after completion.

.PARAMETER WindowTitle
Text shown in the window title bar.

.PARAMETER HeaderText
Main heading text shown inside the window.

.PARAMETER Position
Window placement mode: Center, TopLeft, TopRight, BottomLeft, or BottomRight.

.PARAMETER OffsetX
Horizontal offset in pixels from the selected edge.

.PARAMETER OffsetY
Vertical offset in pixels from the selected edge.

.PARAMETER ScreenTarget
Which monitor to use for placement: ActiveCursor, ActiveWindow, or Primary.

.PARAMETER IconPath
Optional path to an icon file to use in the title bar.

.PARAMETER Theme
Visual theme to use for the window: Dark, Light, or Transparent50.

.PARAMETER StepPercent
Minimum increment size applied each interval.

.PARAMETER IntervalSeconds
Delay between updates in seconds.

.PARAMETER DurationSeconds
Optional total duration. If omitted, duration is inferred from step and interval.

.PARAMETER Topmost
If provided, keeps the window on top of other windows.

.PARAMETER AutoClose
If provided, closes the window automatically after completion.

.PARAMETER AutoCloseDelaySeconds
Delay before auto-closing when AutoClose is used.

.EXAMPLE
Show-UIProgressWindow -DurationSeconds 60 -Topmost

.EXAMPLE
Show-UIProgressWindow -Position BottomRight -ScreenTarget ActiveWindow -AutoClose -AutoCloseDelaySeconds 1
#>
function Show-UIProgressWindow {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$WindowTitle = "Installation",

        [Parameter()]
        [string]$HeaderText = "Installing Software...",

        [Parameter()]
        [ValidateSet("Center", "TopLeft", "TopRight", "BottomLeft", "BottomRight")]
        [string]$Position = "Center",

        [Parameter()]
        [ValidateRange(0, 500)]
        [int]$OffsetX = 20,

        [Parameter()]
        [ValidateRange(0, 500)]
        [int]$OffsetY = 20,

        [Parameter()]
        [ValidateSet("ActiveCursor", "ActiveWindow", "Primary")]
        [string]$ScreenTarget = "ActiveCursor",

        [Parameter()]
        [string]$IconPath,

        [Parameter()]
        [ValidateSet("Dark", "Light", "Transparent50")]
        [string]$Theme = "Light",

        [Parameter()]
        [ValidateRange(1, 100)]
        [int]$StepPercent = 5,

        [Parameter()]
        [ValidateRange(1, 300)]
        [int]$IntervalSeconds = 1,

        [Parameter()]
        [ValidateRange(1, 3600)]
        [int]$DurationSeconds,

        [Parameter()]
        [switch]$Topmost,

        [Parameter()]
        [switch]$AutoClose,

        [Parameter()]
        [ValidateRange(1, 60)]
        [int]$AutoCloseDelaySeconds = 2
    )

    Start-UIProgressWindow -WindowTitle $WindowTitle -HeaderText $HeaderText -Topmost:$Topmost -Position $Position -OffsetX $OffsetX -OffsetY $OffsetY -ScreenTarget $ScreenTarget -IconPath $IconPath -Theme $Theme

    $effectiveDurationSeconds = if ($PSBoundParameters.ContainsKey('DurationSeconds')) {
        $DurationSeconds
    }
    else {
        [int][Math]::Ceiling((100.0 / $StepPercent) * $IntervalSeconds)
    }

    $startTimeUtc = [DateTime]::UtcNow

    while ($true) {
        $ctx = $script:UIProgressWindowContext
        if (-not $ctx -or -not $ctx.Window -or -not $ctx.Window.IsVisible) {
            break
        }

        $elapsedSeconds = ([DateTime]::UtcNow - $startTimeUtc).TotalSeconds
        $percentByTime = [int][Math]::Floor(([Math]::Min($elapsedSeconds, $effectiveDurationSeconds) / $effectiveDurationSeconds) * 100)
        $currentPercent = if ($null -ne $ctx.Percent) { [int]$ctx.Percent } else { 0 }
        $nextPercent = [Math]::Min(100, [Math]::Max($percentByTime, $currentPercent + $StepPercent))

        Update-UIProgressWindow -Percent $nextPercent

        if ($nextPercent -ge 100) {
            if ($AutoClose) {
                Stop-UIProgressWindow -Complete -AutoCloseDelaySeconds $AutoCloseDelaySeconds
            }
            else {
                $ctx = $script:UIProgressWindowContext
                if ($ctx -and $ctx.CloseButton) {
                    $ctx.CloseButton.Content = "Done"
                }

                while ($script:UIProgressWindowContext -and $script:UIProgressWindowContext.Window -and $script:UIProgressWindowContext.Window.IsVisible) {
                    Start-Sleep -Milliseconds 200
                    [System.Windows.Forms.Application]::DoEvents()
                }
            }

            break
        }

        Start-Sleep -Seconds $IntervalSeconds
    }
}