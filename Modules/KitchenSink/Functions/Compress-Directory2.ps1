<#
.SYNOPSIS
Compresses a specified directory into a ZIP file using ZipArchive with real file-by-file progress.

.DESCRIPTION
This version of Compress-Directory uses ZipArchive instead of ZipFile.CreateFromDirectory,
allowing true file-by-file progress tracking, better logging, optional statistics, and
fine-grained control over compression behavior.

.PARAMETER InputDirectory
The path to the directory you want to compress. Mandatory.

.PARAMETER OutputDirectory
The path where the ZIP file will be saved. Mandatory.

.PARAMETER CompressionLevel
Controls compression level: Optimal, Fastest, NoCompression. Default: Optimal.

.PARAMETER IncludeBaseDirectory
If set, the root folder itself is included inside the ZIP archive.

.PARAMETER ShowStats
If set, compression statistics (sizes, ratio, file count) are returned.

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

    # Validate input directory
    if (-not (Test-Path -Path $InputDirectory)) {
        throw "Input directory '$InputDirectory' does not exist."
    }

    # Ensure output directory exists
    if (-not (Test-Path -Path $OutputDirectory)) {
        Write-Verbose "Output directory does not exist. Creating '$OutputDirectory'..."
        New-Item -ItemType Directory -Path $OutputDirectory | Out-Null
    }

    # Normalize input path
    $normalizedInput = (Resolve-Path $InputDirectory).Path

    Write-Verbose "Starting ZipArchive compression of '$normalizedInput'..."
    Write-Verbose "CompressionLevel = $CompressionLevel"
    Write-Verbose "IncludeBaseDirectory = $($IncludeBaseDirectory.IsPresent)"

    # Build ZIP path
    $zipFileName = [System.IO.Path]::GetFileName($normalizedInput) + ".zip"
    $zipFilePath = Join-Path -Path $OutputDirectory -ChildPath $zipFileName

    Write-Verbose "ZIP will be created at '$zipFilePath'."

    # Load compression assembly
    if (-not ("System.IO.Compression.FileSystem" -as [Type])) {
        Write-Verbose "Loading compression assembly..."
        Add-Type -AssemblyName System.IO.Compression.FileSystem
    }

    # Convert compression level
    $level = [System.IO.Compression.CompressionLevel]::$CompressionLevel

    # Collect files
    $files = Get-ChildItem -Path $normalizedInput -Recurse -File -Force
    $total = $files.Count

    if ($total -eq 0) {
        throw "Input directory contains no files to compress."
    }

    if ($PSCmdlet.ShouldProcess($InputDirectory, "Compress to $zipFilePath")) {

        # Remove existing ZIP
        if (Test-Path -Path $zipFilePath) {
            Write-Verbose "Existing ZIP found. Removing '$zipFilePath'..."
            Remove-Item -Path $zipFilePath -Force
        }

        Write-Verbose "Creating ZipArchive stream..."

        # Create ZIP file stream
        $zipStream = [System.IO.File]::Open($zipFilePath, 'Create')
        $zipArchive = New-Object System.IO.Compression.ZipArchive($zipStream, 'Create')

        $index = 0

        foreach ($file in $files) {
            $index++

            # Determine entry path inside ZIP
            $relativePath = $file.FullName.Substring($normalizedInput.Length).TrimStart('\')

            if ($IncludeBaseDirectory) {
                $baseName = [System.IO.Path]::GetFileName($normalizedInput)
                $relativePath = Join-Path $baseName $relativePath
            }

            # Progress bar
            $percent = [math]::Round(($index / $total) * 100, 2)
            Write-Progress -Activity "Compressing Directory" `
                -Status "Adding $relativePath" `
                -PercentComplete $percent

            Write-Verbose "Adding file: $relativePath"

            # Create ZIP entry
            $entry = $zipArchive.CreateEntry($relativePath, $level)

            # Copy file contents
            $entryStream = $entry.Open()
            $fileStream = [System.IO.File]::OpenRead($file.FullName)

            $fileStream.CopyTo($entryStream)

            $fileStream.Close()
            $entryStream.Close()
        }

        # Finalize ZIP
        $zipArchive.Dispose()
        $zipStream.Close()

        Write-Progress -Activity "Compressing Directory" -Completed
        Write-Verbose "ZipArchive compression completed successfully."

        # Stats block
        $stats = $null
        if ($ShowStats) {
            Write-Verbose "Calculating compression statistics..."

            $originalSize = Get-FolderSize -Path $normalizedInput
            $zipSize      = Get-FileSize -Path $zipFilePath
            $fileCount    = $total

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
