<#
.SYNOPSIS
Renders the overlay message for the current frame.

.DESCRIPTION
Chooses a status message, types it out one character at a time, and applies
light flicker so it reads like a live terminal overlay.

.PARAMETER OverlayState
The overlay state object that tracks position, width, and lifetime.

.PARAMETER OverlayMessages
The available overlay strings to pick from.

.PARAMETER Width
The console width used to clamp the message.

.PARAMETER Height
The console height used to choose overlay placement.
#>
function Write-MatrixOverlay {
    param (
        [pscustomobject]$OverlayState,
        [string[]]$OverlayMessages,
        [int]$Width,
        [int]$Height
    )

    if (-not $OverlayMessages -or $OverlayMessages.Count -eq 0) {
        return
    }

    if ($OverlayState.FramesLeft -le 0) {
        $OverlayState.Message = $OverlayMessages | Get-Random
        $OverlayState.Width = 0
        $OverlayState.Y = Get-Random -Minimum 0 -Maximum $Height
        $maxX = [Math]::Max(0, $Width - 1)
        $OverlayState.X = Get-Random -Minimum 0 -Maximum ($maxX + 1)
        $OverlayState.FramesLeft = 20
    }

    $maxWidth = [Math]::Min($OverlayState.Message.Length, $Width - $OverlayState.X)
    if ($OverlayState.Width -lt $maxWidth) {
        $OverlayState.Width++
    }

    $Host.UI.RawUI.CursorPosition = @{ X = $OverlayState.X; Y = $OverlayState.Y }

    $text = $OverlayState.Message.Substring(0, $OverlayState.Width)
    if ((Get-Random -Minimum 0 -Maximum 10) -eq 0) {
        Write-Host $text -ForegroundColor DarkGray -NoNewline
    }
    else {
        Write-Host $text -ForegroundColor Gray -NoNewline
    }

    $OverlayState.FramesLeft--
}