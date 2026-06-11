<#
.SYNOPSIS
Updates the progress value and status text in the UI progress window.

.DESCRIPTION
Writes the provided percent and optional status text to the active window context.
If no window is active, the function returns without error.

.PARAMETER Percent
Progress percentage to display (0 to 100).

.PARAMETER StatusText
Optional status detail appended to the percent text.

.EXAMPLE
Update-UIProgressWindow -Percent 45

.EXAMPLE
Update-UIProgressWindow -Percent 72 -StatusText "432 of 600 users"
#>
function Update-UIProgressWindow {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateRange(0, 100)]
        [int]$Percent,

        [Parameter()]
        [string]$StatusText
    )

    $ctx = $script:InstallProgressContext
    if (-not $ctx -or -not $ctx.Window -or -not $ctx.Window.IsVisible) {
        return
    }

    $ctx.Window.Dispatcher.Invoke([System.Action]{
        $ctx.Percent = $Percent
        $ctx.Progress.Value = $Percent
        if ([string]::IsNullOrWhiteSpace($StatusText)) {
            $ctx.Status.Text = "$Percent% Complete"
        }
        else {
            $ctx.Status.Text = "$Percent% Complete - $StatusText"
        }
    }.GetNewClosure()) | Out-Null

    # Pump pending UI messages so the modeless window repaints during script work.
    [System.Windows.Forms.Application]::DoEvents()
}