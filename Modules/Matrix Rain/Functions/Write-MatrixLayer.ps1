<#
.SYNOPSIS
Renders a Matrix rain layer for the current frame.

.DESCRIPTION
Draws the foreground or background trail, applies the fade behavior, and skips
cells that are currently occupied by the overlay message.

.PARAMETER Columns
The mutable column positions for the layer.

.PARAMETER CharArray
The character array used to select random glyphs.

.PARAMETER OverlayState
The shared overlay state used to avoid drawing over overlay text.

.PARAMETER Width
The console width used to iterate the layer.

.PARAMETER Height
The console height used by the layer logic.

.PARAMETER TrailLength
The number of trail cells to draw per column.

.PARAMETER IsForeground
Indicates whether the foreground palette should be used.
#>
function Write-MatrixLayer {
    param (
        [object[]]$Columns,
        [object[]]$CharArray,
        [pscustomobject]$OverlayState,
        [int]$Width,
        [int]$Height,
        [int]$TrailLength,
        [bool]$IsForeground
    )

    for ($x = 0; $x -lt $Width; $x++) {
        $y = $Columns[$x]

        for ($t = 0; $t -lt $TrailLength; $t++) {
            $posY = $y - $t
            if ($posY -lt 0) { continue }

            if (
                $OverlayState.FramesLeft -gt 0 -and
                $posY -eq $OverlayState.Y -and
                $x -ge $OverlayState.X -and
                $x -lt ($OverlayState.X + $OverlayState.Width)
            ) {
                continue
            }

            $Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $posY }
            $char = $CharArray | Get-Random

            if ($IsForeground) {
                if ($t -eq 0) {
                    Write-Host $char -ForegroundColor White -NoNewline
                }
                elseif ($t -lt 3) {
                    Write-Host $char -ForegroundColor Green -NoNewline
                }
                elseif ($t -lt 6) {
                    Write-Host $char -ForegroundColor DarkGreen -NoNewline
                }
                else {
                    # Fade out probabilistically to avoid abrupt tail erasure.
                    if ((Get-Random -Minimum 0 -Maximum 3) -eq 0) {
                        Write-Host " " -NoNewline
                    }
                    else {
                        Write-Host $char -ForegroundColor Black -NoNewline
                    }
                }
            }
            else {
                if ($t -eq 0) {
                    Write-Host $char -ForegroundColor DarkGreen -NoNewline
                }
                elseif ($t -lt 4) {
                    Write-Host $char -ForegroundColor DarkGray -NoNewline
                }
                else {
                    # Background trails fade even slower to keep depth continuity.
                    if ((Get-Random -Minimum 0 -Maximum 4) -eq 0) {
                        Write-Host " " -NoNewline
                    }
                    else {
                        Write-Host $char -ForegroundColor Black -NoNewline
                    }
                }
            }
        }
    }
}