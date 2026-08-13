<#
.SYNOPSIS
Advances the rain motion for one animation frame.

.DESCRIPTION
Updates each column position, applies random velocity drift, applies the wave
offset, and resets columns that hit the bottom or recycle early.

.PARAMETER Columns
The mutable column position array to update.

.PARAMETER Velocity
The mutable velocity array to update.

.PARAMETER Width
The console width used to iterate across columns.

.PARAMETER Height
The console height used to detect wraps.

.PARAMETER Frame
The current frame counter used by the wave calculation.

.PARAMETER WaveAmplitude
The amplitude of the sine wave motion.

.PARAMETER WaveFrequency
The frequency of the sine wave motion.
#>
function Update-MatrixMotion {
    param (
        [object[]]$Columns,
        [object[]]$Velocity,
        [int]$Width,
        [int]$Height,
        [int]$Frame,
        [double]$WaveAmplitude,
        [double]$WaveFrequency
    )

    for ($x = 0; $x -lt $Width; $x++) {
        $vel = $Velocity[$x]

        if ((Get-Random -Minimum 0 -Maximum 100) -gt 95) {
            $Velocity[$x] = Get-Random -Minimum 1 -Maximum 5
            $vel = $Velocity[$x]
        }

        $waveBoost = [Math]::Sin(($Frame + $x) * $WaveFrequency) * $WaveAmplitude
        $nextY = [double]$Columns[$x] + [double]$vel + $waveBoost
        $Columns[$x] = [int][Math]::Round($nextY)

        if ($Columns[$x] -ge $Height -or (Get-Random -Minimum 0 -Maximum 100) -gt 97) {
            $Columns[$x] = Get-Random -Minimum 0 -Maximum 10
            $Velocity[$x] = Get-Random -Minimum 1 -Maximum 5
        }
    }
}