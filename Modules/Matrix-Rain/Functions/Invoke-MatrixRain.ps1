<#
.SYNOPSIS
Displays an animated Matrix-style rain effect in the PowerShell console.

.DESCRIPTION
Invoke-MatrixRain renders two character rain layers (background and foreground)
to create a depth effect in the current console window. The animation runs until
you quit with keyboard input.

Interactive keys while running:
- q : Quit the animation
- + : Increase animation speed (lower delay, minimum 5 ms)
- - : Decrease animation speed (higher delay)
- r : Clear and redraw the console

.PARAMETER Speed
Initial frame delay in milliseconds. Lower values animate faster.
Valid range is 5 to 500. You can also adjust speed live with + and -.

.PARAMETER TrailLength
Number of trailing characters drawn behind each column head.
Valid range is 1 to 100.

.PARAMETER Characters
String containing characters used for rain output. The string is converted
to a character array and random characters are selected for each draw.

.PARAMETER OverlayMessages
Optional array of status-style messages displayed intermittently in the
background layer.

.PARAMETER WaveAmplitude
Controls how strongly the global sine wave influences column motion.
Lower values are subtler. Set to 0 to disable wave influence.

.PARAMETER WaveFrequency
Controls how quickly the sine wave phase changes across frames/columns.
Lower values produce slower, broader pulses.

.EXAMPLE
Invoke-MatrixRain

Starts the animation with default settings.

.EXAMPLE
Invoke-MatrixRain -Speed 15 -TrailLength 18

Starts a faster animation with longer trails.

.EXAMPLE
Invoke-MatrixRain -Characters "01ABCDEF" -OverlayMessages "Scanning...","Connected"

Uses a custom character set and custom overlay messages.

.INPUTS
None. You cannot pipe objects to this function.

.OUTPUTS
None. This function writes directly to the host console.

.NOTES
Best used in Windows Terminal or a standard interactive PowerShell host.
Resizing the window during execution may produce visual artifacts until redraw.
#>
function Invoke-MatrixRain {
    [CmdletBinding()]
    param (
        [ValidateRange(5, 500)]
        [int]$Speed = 25,

        [ValidateRange(1, 100)]
        [int]$TrailLength = 12,

        [string]$Characters = "01アイウエオカキクケコサシスセソABCDEFGHIJKLMNOPQRSTUVWXYZ@#$%&*",

        [string[]]$OverlayMessages = @(
            "Analyzing input stream...",
            "Decrypting packet...",
            "Injecting payload...",
            "Bypassing firewall...",
            "Accessing secure node...",
            "Mapping network...",
            "Tracing signal origin...",
            "Executing override..."
        ),

        [ValidateRange(0, 3)]
        [double]$WaveAmplitude = 0.8,

        [ValidateRange(0.001, 0.5)]
        [double]$WaveFrequency = 0.05
    )

    Clear-Host

    $width = $Host.UI.RawUI.WindowSize.Width
    $height = $Host.UI.RawUI.WindowSize.Height
    $running = $true
    $state = Initialize-MatrixState -Characters $Characters -OverlayMessages $OverlayMessages -Width $width -Height $height -TrailLength $TrailLength -WaveAmplitude $WaveAmplitude -WaveFrequency $WaveFrequency

    $handleInput = {
        if ([System.Console]::KeyAvailable) {
            $key = [System.Console]::ReadKey($true)

            switch ($key.KeyChar) {
                'q' { return "quit" }
                '+' { $Speed = [Math]::Max(5, $Speed - 5) }
                '-' { $Speed += 5 }
                'r' { Clear-Host }
            }
        }

        return $null
    }

    $drawLayer = {
        param (
            [object[]]$Columns,
            [bool]$IsForeground
        )

        Write-MatrixLayer -Columns $Columns -CharArray $state.CharArray -OverlayState $state.OverlayState -Width $state.Width -Height $state.Height -TrailLength $state.TrailLength -IsForeground $IsForeground
    }

    while ($running) {
        $state.Frame++

        $action = & $handleInput
        if ($action -eq "quit") { break }

        Update-MatrixMotion -Columns $state.BgColumns -Velocity $state.BgVelocity -Width $state.Width -Height $state.Height -Frame $state.Frame -WaveAmplitude $state.WaveAmplitude -WaveFrequency $state.WaveFrequency
        Update-MatrixMotion -Columns $state.FgColumns -Velocity $state.FgVelocity -Width $state.Width -Height $state.Height -Frame $state.Frame -WaveAmplitude $state.WaveAmplitude -WaveFrequency $state.WaveFrequency

        & $drawLayer -Columns $state.BgColumns -IsForeground $false
        & $drawLayer -Columns $state.FgColumns -IsForeground $true

        if ($state.OverlayState.FramesLeft -gt 0 -or (Get-Random -Minimum 0 -Maximum 100) -gt 94) {
            Write-MatrixOverlay -OverlayState $state.OverlayState -OverlayMessages $state.OverlayMessages -Width $state.Width -Height $state.Height
        }

        Start-Sleep -Milliseconds $Speed
    }
}