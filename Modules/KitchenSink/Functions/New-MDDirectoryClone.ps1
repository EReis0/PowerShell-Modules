function New-MDDirectoryClone {
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High'
    )]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('FullName')]
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string]$SourcePath,

        [Parameter(Mandatory)]
        [string]$DestinationPath,

        [string[]]$ExcludeDirectory,

        [switch]$Force
    )

    process {

        $SourcePath = (Resolve-Path $SourcePath).Path

        # Get markdown inventory
        $MDFiles = Get-MDFileArray -Path $SourcePath

        # Remove excluded directories
        if ($ExcludeDirectory) {
            $MDFiles = $MDFiles | Where-Object {

                $PathParts = $_.FullName -split '[\\/]'

                $Exclude = $false

                foreach ($Directory in $ExcludeDirectory) {
                    if ($PathParts -contains $Directory) {
                        $Exclude = $true
                        break
                    }
                }

                -not $Exclude
            }
        }

        if (-not $MDFiles) {
            Write-Warning "No markdown files found under [$SourcePath] after exclusions."
            return
        }

        # Destination exists
        if (Test-Path $DestinationPath) {

            if (-not $Force) {
                Write-Error @"
Destination already exists:

$DestinationPath

To prevent accidental data loss, the clone operation
will not continue.

Verify the destination path and rerun with -Force
to purge the existing contents and rebuild the clone.

Example:

New-MDDirectoryClone `
    -SourcePath '$SourcePath' `
    -DestinationPath '$DestinationPath' `
    -Force
"@
                return
            }

            if ($PSCmdlet.ShouldProcess(
                $DestinationPath,
                'Purge existing clone directory'
            )) {

                Get-ChildItem `
                    -Path $DestinationPath `
                    -Force |
                    Remove-Item `
                        -Recurse `
                        -Force
            }
        }
        else {

            if ($PSCmdlet.ShouldProcess(
                $DestinationPath,
                'Create destination root'
            )) {

                New-Item `
                    -Path $DestinationPath `
                    -ItemType Directory `
                    -Force | Out-Null
            }
        }

        # Build inventory with relative paths
        $FileInventory =
            foreach ($File in $MDFiles) {

                $RelativeFilePath =
                    $File.FullName.Substring($SourcePath.Length).
                    TrimStart('\','/')

                [PSCustomObject]@{
                    File             = $File
                    RelativeFilePath = $RelativeFilePath
                    RelativeDirectory = Split-Path `
                        -Path $RelativeFilePath `
                        -Parent
                }
            }

        # Create required directory structure
        $DirectoriesToCreate =
            $FileInventory |
            Select-Object -ExpandProperty RelativeDirectory |
            Where-Object { $_ } |
            Sort-Object -Unique

        foreach ($Directory in $DirectoriesToCreate) {

            $TargetDirectory = Join-Path `
                -Path $DestinationPath `
                -ChildPath $Directory

            if (-not (Test-Path $TargetDirectory)) {

                if ($PSCmdlet.ShouldProcess(
                    $TargetDirectory,
                    'Create directory'
                )) {

                    New-Item `
                        -Path $TargetDirectory `
                        -ItemType Directory `
                        -Force | Out-Null
                }
            }
        }

        # Copy markdown files
        foreach ($Item in $FileInventory) {

            $DestinationFile = Join-Path `
                -Path $DestinationPath `
                -ChildPath $Item.RelativeFilePath

            if ($PSCmdlet.ShouldProcess(
                $DestinationFile,
                'Copy markdown file'
            )) {

                Copy-Item `
                    -Path $Item.File.FullName `
                    -Destination $DestinationFile `
                    -Force
            }
        }

        Write-Verbose @"
Created [$($DirectoriesToCreate.Count)] directories.
Copied [$($MDFiles.Count)] markdown files.
"@
    }
}