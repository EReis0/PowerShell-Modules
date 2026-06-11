<#
.SYNOPSIS
Completes and closes the UI progress window.

.DESCRIPTION
Optionally marks progress as complete, waits for an optional delay, then closes
the active progress window if it is visible.

.PARAMETER Complete
If provided, sets progress to 100 and changes the button label to Done.

.PARAMETER AutoCloseDelaySeconds
Optional delay before closing the window.

.EXAMPLE
Stop-UIProgressWindow

.EXAMPLE
Stop-UIProgressWindow -Complete -AutoCloseDelaySeconds 2
#>
function Stop-UIProgressWindow {
    [CmdletBinding()]
    param(
        [Parameter()]
        [switch]$Complete,

        [Parameter()]
        [ValidateRange(0, 60)]
        [int]$AutoCloseDelaySeconds = 0
    )

    $ctx = $script:InstallProgressContext
    if (-not $ctx -or -not $ctx.Window) {
        return
    }

    if ($Complete) {
        Update-UIProgressWindow -Percent 100 -StatusText "Complete!"
        $ctx.Window.Dispatcher.Invoke([System.Action]{
            $ctx.CloseButton.Content = "Done"
        }) | Out-Null
    }

    if ($AutoCloseDelaySeconds -gt 0) {
        Start-Sleep -Seconds $AutoCloseDelaySeconds
    }

    if ($ctx.Window.IsVisible) {
        $ctx.Window.Dispatcher.Invoke([System.Action]{
            $ctx.Window.Close()
        }) | Out-Null
    }
}