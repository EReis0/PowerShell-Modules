- [Matrix Rain](#matrix-rain)
  - [Features](#features)
  - [Exported Command](#exported-command)
  - [Requirements](#requirements)
  - [Install / Import](#install--import)
  - [Quick Start](#quick-start)
  - [Examples](#examples)
    - [Faster animation with longer trails](#faster-animation-with-longer-trails)
    - [Custom glyph set and overlay messages](#custom-glyph-set-and-overlay-messages)
    - [Tune wave motion](#tune-wave-motion)
  - [Parameters](#parameters)
    - [`-Speed`](#-speed)
    - [`-TrailLength`](#-traillength)
    - [`-Characters`](#-characters)
    - [`-OverlayMessages`](#-overlaymessages)
    - [`-WaveAmplitude`](#-waveamplitude)
    - [`-WaveFrequency`](#-wavefrequency)
  - [Runtime Controls](#runtime-controls)
  - [Internal Module Structure](#internal-module-structure)
  - [Notes](#notes)
  - [Troubleshooting](#troubleshooting)
    - [Command not found](#command-not-found)
    - [Animation too busy](#animation-too-busy)
    - [Overlay too active](#overlay-too-active)
  - [Author](#author)
  - [License](#license)

# Matrix Rain

<img src="https://img.shields.io/badge/PowerShell-5.1+-5391FE?logo=powershell&amp;logoColor=white" alt="PowerShell">    <img src="https://img.shields.io/badge/Platform-Windows Terminal-4D4D4D" alt="Platform">    <img src="https://img.shields.io/badge/License-MIT-green" alt="License">    <img src="https://img.shields.io/badge/Type-Script Module-blue" alt="Module">

A PowerShell module that renders a Matrix-style animated rain effect in the console with layered depth, smooth fades, and a live status overlay.

## Features

- Dual rain layers (foreground and background) for depth
- Smooth probabilistic trailing fade
- Type-out overlay messages with subtle flicker
- Wave-based motion influence for organic movement
- Runtime keyboard controls for speed and redraw
- Modular internal design with helper functions

## Exported Command

- `Invoke-MatrixRain`

## Requirements

- PowerShell 5.1 or PowerShell 7+
- Interactive host (Windows Terminal recommended)
- Compatible editions: Desktop and Core

## Install / Import

```powershell
Import-Module "C:\Code\PowerShell-Modules\Modules\Matrix Rain\Matrix Rain.psd1" -Force
```

## Quick Start

```powershell
Invoke-MatrixRain
```

## Examples

### Faster animation with longer trails

```powershell
Invoke-MatrixRain -Speed 15 -TrailLength 18
```

### Custom glyph set and overlay messages

```powershell
Invoke-MatrixRain -Characters "01ABCDEF" -OverlayMessages "Scanning...","Connected","Transmitting..."
```

### Tune wave motion

```powershell
Invoke-MatrixRain -WaveAmplitude 0.8 -WaveFrequency 0.05
```

## Parameters

### `-Speed`
Frame delay in milliseconds.  
- Type: `Int32`  
- Default: `25`  
- Range: `5..500`  
- Lower values are faster.

### `-TrailLength`
Number of trailing characters behind each column head.  
- Type: `Int32`  
- Default: `12`  
- Range: `1..100`

### `-Characters`
Character source string used to render rain glyphs.  
- Type: `String`  
- Default includes `0/1`, kana, alphabet, and symbols.

### `-OverlayMessages`
Optional status messages shown in the animated overlay.  
- Type: `String[]`  
- Default: built-in status message list

### `-WaveAmplitude`
Strength of wave influence in column motion.  
- Type: `Double`  
- Default: `0.8`  
- Range: `0..3`  
- Set `0` to disable wave influence.

### `-WaveFrequency`
Speed and density of wave oscillation.  
- Type: `Double`  
- Default: `0.05`  
- Range: `0.001..0.5`

## Runtime Controls

While animation is running:

- `q` Quit
- `+` Increase animation speed (lower delay)
- `-` Decrease animation speed (higher delay)
- `r` Clear and redraw console

## Internal Module Structure

The module loads function files from the `Functions` folder, including:

- `Initialize-MatrixState`
- `Update-MatrixMotion`
- `Write-MatrixLayer`
- `Write-MatrixOverlay`
- `Invoke-MatrixRain`

Only `Invoke-MatrixRain` is intended as the public command.

## Notes

- This command writes directly to the host console (no pipeline output).
- Resizing the terminal during execution can briefly cause visual artifacts.
- Best visual quality is achieved in a wide terminal window.

## Troubleshooting

### Command not found
```powershell
Get-Command Invoke-MatrixRain -All
```
If missing, re-import the module using the manifest path.

### Animation too busy
- Increase `-Speed`
- Decrease `-TrailLength`
- Lower `-WaveAmplitude`

### Overlay too active
- Pass a shorter custom `-OverlayMessages` list
- Use shorter message strings

## Author

Eric Reis  
GitHub: https://github.com/EReis0

## License

MIT