<#
.SYNOPSIS
Compresses a specified directory into a ZIP file.

.DESCRIPTION
The Compress-Directory function creates a ZIP archive of the specified input directory
and saves it to the specified output directory. If the output directory does not exist,
it will be created. If a ZIP file with the same name already exists in the output
directory, it will be overwritten.

.PARAMETER InputDirectory
The path to the directory you want to compress. This parameter is mandatory.

.PARAMETER OutputDirectory
The path to the directory where the ZIP file will be saved. This parameter is mandatory.

.PARAMETER CompressionLevel
Optional. Controls the compression level used when creating the ZIP file.
Valid values: Optimal, Fastest, NoCompression.
Default: Optimal.

.PARAMETER IncludeBaseDirectory
Optional. If set, the root folder itself is included inside the ZIP archive.

.EXAMPLE
Compress-Directory -InputDirectory "C:\Data\Source" -OutputDirectory "C:\Data\Archives"

.EXAMPLE
$inputs = @{
    InputDirectory = "C:\Users\ereis\Desktop\backup and shipout 2025\Downloads"
    OutputDirectory = "C:\Users\ereis\Desktop\backup and shipout 2025 compressed"
}
Compress-Directory @inputs

.NOTES
Requires .NET Framework and PowerShell 5.0 or later.
The ZIP file will be named after the input directory.
#>
function Compress-Directory {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputDirectory,

        [Parameter(Mandatory = $true)]
        [string]$OutputDirectory,

        [Parameter()]
        [ValidateSet("Optimal", "Fastest", "NoCompression")]
        [string]$CompressionLevel = "Optimal",

        [Parameter()]
        [switch]$IncludeBaseDirectory,

        [Parameter()]
        [switch]$ShowStats
    )

    function Get-FolderSize {
        param([string]$Path)
        (Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue |
            Measure-Object -Property Length -Sum).Sum
    }

    function Get-FileSize {
        param([string]$Path)
        (Get-Item $Path).Length
    }

    function Get-FileCount {
        param([string]$Path)
        (Get-ChildItem -Path $Path -Recurse -Force -File -ErrorAction SilentlyContinue).Count
    }

    # Ensure the input directory exists
    if (-not (Test-Path -Path $InputDirectory)) {
        throw "Input directory '$InputDirectory' does not exist."
    }

    # Ensure the output directory exists
    if (-not (Test-Path -Path $OutputDirectory)) {
        Write-Verbose "Output directory does not exist. Creating '$OutputDirectory'..."
        New-Item -ItemType Directory -Path $OutputDirectory | Out-Null
    }

    # Normalize input path
    $normalizedInput = (Resolve-Path $InputDirectory).Path

    Write-Verbose "Starting compression of '$normalizedInput'..."
    Write-Verbose "Using compression level: $CompressionLevel"
    Write-Verbose "IncludeBaseDirectory = $($IncludeBaseDirectory.IsPresent)"

    # Define output ZIP path
    $zipFileName = [System.IO.Path]::GetFileName($normalizedInput) + ".zip"
    $zipFilePath = Join-Path -Path $OutputDirectory -ChildPath $zipFileName

    Write-Verbose "Output ZIP will be created at '$zipFilePath'."

    # Load compression assembly
    if (-not ("System.IO.Compression.FileSystem" -as [Type])) {
        Write-Verbose "Loading compression assembly..."
        Add-Type -AssemblyName System.IO.Compression.FileSystem
    }

    # Convert compression level
    $level = [System.IO.Compression.CompressionLevel]::$CompressionLevel

    if ($PSCmdlet.ShouldProcess($InputDirectory, "Compress to $zipFilePath")) {

        # Remove existing ZIP
        if (Test-Path -Path $zipFilePath) {
            Write-Verbose "Existing ZIP found. Removing '$zipFilePath'..."
            Remove-Item -Path $zipFilePath -Force
        }

        Write-Verbose "Compressing directory..."

        Write-Progress -Activity "Compressing Directory" -Status "Starting..." -PercentComplete 0

        try {
            [System.IO.Compression.ZipFile]::CreateFromDirectory(
                $normalizedInput,
                $zipFilePath,
                $level,
                [bool]$IncludeBaseDirectory
            )
        } catch {
            throw "Compression failed: $($_.Exception.Message)"
        }

        Write-Progress -Activity "Compressing Directory" -Completed
        Write-Verbose "Compression completed successfully."

        # Stats block
        $stats = $null
        if ($ShowStats) {
            Write-Verbose "Calculating compression statistics..."

            $originalSize = Get-FolderSize -Path $normalizedInput
            $zipSize      = Get-FileSize -Path $zipFilePath
            $fileCount    = Get-FileCount -Path $normalizedInput

            $stats = [PSCustomObject]@{
                OriginalSizeMB   = [math]::Round($originalSize / 1MB, 2)
                CompressedSizeMB = [math]::Round($zipSize / 1MB, 2)
                CompressionRatio = if ($originalSize -gt 0) { [math]::Round($zipSize / $originalSize, 4) } else { 0 }
                FilesCompressed  = $fileCount
            }
        }

        # Return structured output
        [PSCustomObject]@{
            InputDirectory       = $InputDirectory
            OutputDirectory      = $OutputDirectory
            ZipFilePath          = $zipFilePath
            CompressionLevel     = $CompressionLevel
            IncludeBaseDirectory = $IncludeBaseDirectory.IsPresent
            Stats                = $stats
            Status               = "Success"
        }
    }
}
