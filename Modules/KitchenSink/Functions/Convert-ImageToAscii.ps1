<#
.SYNOPSIS
Converts an image into ASCII art and optionally saves it as a JPG file.

.DESCRIPTION
The Convert-ImageToAscii function takes an image file as input, resizes it, converts it to grayscale, maps the grayscale values to ASCII characters, and outputs the ASCII art as text. Optionally, the ASCII art can be saved as a JPG file.

.PARAMETER ImagePath
The path to the input image file.

.PARAMETER Width
The width of the ASCII art in characters. The height is calculated automatically to maintain the aspect ratio. Default is 100.

.PARAMETER OutputPath
The path to save the ASCII art as a JPG file. If not provided, the ASCII art is only returned as text.

.EXAMPLE
Convert-ImageToAscii -ImagePath "C:\\path\\to\\image.jpg" -Width 80

This example converts the image at the specified path into ASCII art with a width of 80 characters and outputs it as text.

.EXAMPLE
Convert-ImageToAscii -ImagePath "C:\\path\\to\\image.jpg" -Width 80 -OutputPath "C:\\path\\to\\output.jpg"

This example converts the image at the specified path into ASCII art with a width of 80 characters and saves it as a JPG file at the specified output path.

.NOTES
The function uses the System.Drawing namespace to process images and render ASCII art.

#>
function Convert-ImageToAscii {
    param (
        [string]$ImagePath,
        [int]$Width = 100,
        [string]$OutputPath = $null
    )

    # ASCII characters used to represent pixel intensity levels
    $AsciiChars = '@%#*+=-:. '

    # Load the image
    $bitmap = [System.Drawing.Bitmap]::FromFile($ImagePath)

    # Calculate new height to maintain aspect ratio
    $aspectRatio = $bitmap.Height / $bitmap.Width
    $newHeight = [math]::Round($Width * $aspectRatio * 0.55)  # Adjust for font aspect ratio

    # Resize the image
    $resizedBitmap = New-Object System.Drawing.Bitmap $bitmap, $Width, $newHeight

    # Initialize the ASCII art string
    $asciiArt = ""

    # Loop through each pixel in the resized image
    for ($y = 0; $y -lt $resizedBitmap.Height; $y++) {
        for ($x = 0; $x -lt $resizedBitmap.Width; $x++) {
            # Get the pixel color
            $pixelColor = $resizedBitmap.GetPixel($x, $y)

            # Convert to grayscale
            $grayValue = ([int](($pixelColor.R * 0.3) + ($pixelColor.G * 0.59) + ($pixelColor.B * 0.11)))

            # Map grayscale value to ASCII character
            $charIndex = [math]::Floor(($grayValue / 255) * ($AsciiChars.Length - 1))
            $asciiChar = $AsciiChars[$charIndex]

            # Append the character to the ASCII art string
            $asciiArt += $asciiChar
        }
        $asciiArt += "`n"  # New line after each row
    }

    # Dispose of the bitmaps
    $bitmap.Dispose()
    $resizedBitmap.Dispose()

    # If OutputPath is provided, save the ASCII art as a JPG file
    if ($OutputPath) {
        # Create a new bitmap for the output
        $font = New-Object System.Drawing.Font("Courier New", 10)
        $textSize = [System.Drawing.Graphics]::FromImage((New-Object System.Drawing.Bitmap(1, 1))).MeasureString($asciiArt, $font)
        $outputBitmap = New-Object System.Drawing.Bitmap([int]$textSize.Width, [int]$textSize.Height)
        $graphics = [System.Drawing.Graphics]::FromImage($outputBitmap)
        $graphics.Clear([System.Drawing.Color]::White)
        $graphics.DrawString($asciiArt, $font, [System.Drawing.Brushes]::Black, 0, 0)
        $outputBitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)

        # Dispose of graphics objects
        $graphics.Dispose()
        $outputBitmap.Dispose()
    }

    # Return the ASCII art
    return $asciiArt
} # $asciiArt = Convert-ImageToAscii -ImagePath "D:\Images\56165.gif" -Width 100 -OutputPath "D:\ascii_art.jpg"
