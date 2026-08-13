<#
.SYNOPSIS
Builds the shared runtime state for the Matrix rain animation.

.DESCRIPTION
Creates the rain columns, velocities, character array, and overlay state used
by the animation loop so the main function can stay focused on orchestration.

.PARAMETER Characters
The character string used to generate rain glyphs.

.PARAMETER OverlayMessages
The overlay messages available for status text.

.PARAMETER Width
The current console width.

.PARAMETER Height
The current console height.

.PARAMETER TrailLength
The configured trail length.

.PARAMETER WaveAmplitude
The configured wave amplitude.

.PARAMETER WaveFrequency
The configured wave frequency.

.OUTPUTS
An object that stores all mutable animation state.
#>
function Initialize-MatrixState {
    param (
        [string]$Characters,
        [string[]]$OverlayMessages,
        [int]$Width,
        [int]$Height,
        [int]$TrailLength,
        [double]$WaveAmplitude,
        [double]$WaveFrequency
    )

    $fgColumns = @()
    $bgColumns = @()
    $fgVelocity = @()
    $bgVelocity = @()

    for ($i = 0; $i -lt $Width; $i++) {
        $fgColumns += Get-Random -Minimum 0 -Maximum $Height
        $bgColumns += Get-Random -Minimum 0 -Maximum $Height

        $fgVelocity += Get-Random -Minimum 2 -Maximum 5
        $bgVelocity += Get-Random -Minimum 1 -Maximum 2
    }

    [pscustomobject]@{
        CharArray     = $Characters.ToCharArray()
        Width         = $Width
        Height        = $Height
        TrailLength   = $TrailLength
        WaveAmplitude = $WaveAmplitude
        WaveFrequency = $WaveFrequency
        Frame         = 0
        FgColumns     = $fgColumns
        BgColumns     = $bgColumns
        FgVelocity    = $fgVelocity
        BgVelocity    = $bgVelocity
        OverlayMessages = $OverlayMessages
        OverlayState  = [pscustomobject]@{
            Message    = ""
            X          = 0
            Y          = 0
            Width      = 0
            FramesLeft = 0
        }
    }
}