<#
.SYNOPSIS
Compresses a specified directory into a ZIP file.

.DESCRIPTION
The Compress-Directory function creates a ZIP archive of the specified input directory and saves it to the specified output directory. If the output directory does not exist, it will be created. If a ZIP file with the same name already exists in the output directory, it will be overwritten.

.PARAMETER InputDirectory
The path to the directory you want to compress. This parameter is mandatory.

.PARAMETER OutputDirectory
The path to the directory where the ZIP file will be saved. This parameter is mandatory.

.EXAMPLE
Compress-Directory -InputDirectory "C:\Data\Source" -OutputDirectory "C:\Data\Archives"

This example compresses the "C:\Data\Source" directory into a ZIP file and saves it in "C:\Data\Archives".

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
    param (
        [Parameter(Mandatory = $true)]
        [string]$InputDirectory,

        [Parameter(Mandatory = $true)]
        [string]$OutputDirectory
    )

    # Ensure the input directory exists
    if (-not (Test-Path -Path $InputDirectory)) {
        throw "Input directory '$InputDirectory' does not exist."
    }

    # Ensure the output directory exists, create it if it doesn't
    if (-not (Test-Path -Path $OutputDirectory)) {
        New-Item -ItemType Directory -Path $OutputDirectory | Out-Null
    }

    # Define the output zip file path
    $zipFileName = [System.IO.Path]::GetFileName($InputDirectory) + ".zip"
    $zipFilePath = Join-Path -Path $OutputDirectory -ChildPath $zipFileName

    # Use .NET's ZipFile class to compress the directory
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    if (Test-Path -Path $zipFilePath) {
        Remove-Item -Path $zipFilePath -Force
    }
    [System.IO.Compression.ZipFile]::CreateFromDirectory($InputDirectory, $zipFilePath)

    Write-Host "Directory '$InputDirectory' has been compressed to '$zipFilePath'."
}



<#
.SYNOPSIS
    Converts a CSV file to an HTML report using PSWriteHTML.
.DESCRIPTION
    This function converts a CSV file to an HTML report using PSWriteHTML and preferred parameters. The function is a wrapper for the `ConvertTo-HTMLTable` function in PSWriteHTML. When the function is executed, a file browser will open to select the CSV file to convert. In order to use this function, you must have PSWriteHTML installed.
.PARAMETER None
    This function does not accept any parameters.
.EXAMPLE
    Convert-CSVtoHTML
    This example converts a CSV file to an HTML report using PSWriteHTML and preferred parameters.
.NOTES
    Author: Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 8/2023
.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
Function Convert-CSVtoHTML {
    Import-Module -Name PSWriteHTML
    $DownloadsPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    $File = Get-CSVFilePath
    $importFile = @(Import-CSV -path $File)
    $FileNameRaw = (Get-ChildItem $file).Name
    $FileName = $FileNameRaw.Replace(".csv",'')
    $OutputPath = Join-Path -Path $DownloadsPath -ChildPath "$FileName.html"
    Write-Host "`n`r ---> Exported report to $OutputPath" -foregroundcolor 'black' -backgroundcolor 'green'
    New-HTML {
        New-HTMLTable -DataTable $importFile -Title $FileName -HideFooter -PagingLength 10 -Buttons excelHtml5,searchPanes
    } -ShowHTML -FilePath $OutputPath -Online
} #Convert-CSVtoHTML


<#
.SYNOPSIS
Converts between hexadecimal and plain text formats.

.DESCRIPTION
The Convert-HexText function converts between hexadecimal and plain text formats. If the 'text' parameter is used, the provided text is returned in a hexadecimal format. If the 'hex' parameter is used, the provided hexadecimal value is read and returned in plain text format.

.PARAMETER hex
The hexadecimal value to convert to plain text format.

.PARAMETER text
The text value to convert to hexadecimal format.
Does not accept lists of values.

.EXAMPLE
Convert-HexText -text "Hello, world!"

This example converts the text "Hello, world!" to a hexadecimal format.

.EXAMPLE
Convert-HexText -hex "48656C6C6F2C20776F726C6421"

This example converts the hexadecimal value "48656C6C6F2C20776F726C6421" to plain text format.

.NOTES
Author: Codeholics - Eric Reis (https://github.com/EReis0/)
Date: 10/12/2023
Version: 1.0
#>
function Convert-HexText {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$hex,
        [Parameter(Mandatory=$false)]
        [string]$text
    )

    if ($hex -and $text) {
        Write-Error "Only one of the 'hex' and 'text' parameters can be specified."
        return
    }

    if ($hex) {
        # Convert the hexadecimal string to a byte array
        $bytes = [System.Text.RegularExpressions.Regex]::Matches($hex, '..').ForEach({[byte]::Parse($_.Value, 'HexNumber')})

        # Convert the byte array to a string using the UTF8 encoding
        $string = [System.Text.Encoding]::UTF8.GetString($bytes)

        # Output the string
        Write-Output $string
    }
    elseif ($text) {
        # Convert the text to a byte array using the UTF8 encoding
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)

        # Convert the byte array to a hexadecimal string
        $hex = [BitConverter]::ToString($bytes) -replace '-'

        # Output the hexadecimal string
        Write-Output $hex
    }
    else {
        Write-Error "One of the 'hex' and 'text' parameters must be specified."
    }
}  # Convert-HexText -text "Hello World!"


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



<#
.SYNOPSIS
    Converts a Unix timestamp or a Windows File Time to a human-readable date and time.

.DESCRIPTION
    The Convert-Timestamp function takes a Unix timestamp (milliseconds since 1970-01-01 00:00:00 UTC) or a Windows File Time (100-nanosecond intervals since 1601-01-01 00:00:00 UTC) and converts it to a human-readable date and time in the format "MM/dd/yyyy hh:mm tt".

.PARAMETER timestamp
    The Unix timestamp or Windows File Time to convert. This is a mandatory parameter.

.EXAMPLE
    Convert-Timestamp -timestamp 1706381481000
    This will convert the Unix timestamp 1706381481000 to a human-readable date and time.

.EXAMPLE
    Convert-Timestamp -timestamp 133505150963768760
    This will convert the Windows File Time 133505150963768760 to a human-readable date and time.

.NOTES
    Unix timestamps are typically 13 digits long, while Windows File Times are typically 18 digits long. The function determines the type of the timestamp based on its length.

    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 01/2024

.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
function Convert-Timestamp {
    param(
        [Parameter(Mandatory=$true)]
        [int64]$timestamp
    )

    # Unix timestamp (milliseconds) is typically 13 digits
    # Windows File Time is typically 18 digits
    switch ($timestamp.ToString().Length) {
        { $_ -le 13 } {
            $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
            $TS = $origin.AddMilliseconds($timestamp).ToLocalTime()
            return $TS.ToString("MM/dd/yyyy hh:mm tt")
        }
        { $_ -gt 13 } {
            $TS = [DateTime]::FromFileTime($timestamp)
            return $TS.ToString("MM/dd/yyyy hh:mm tt")
        }
    }
}


<#
.SYNOPSIS
    Generates a Time-based One-Time Password (TOTP) code.

.DESCRIPTION
    The Convert-TOTPToMFA function generates a TOTP code based on the provided secret, period, number of digits, and algorithm. 
    It decodes the Base32 TOTP secret, calculates the time step, generates the HMAC hash, extracts the dynamic offset, and calculates the TOTP code.

.PARAMETER Secret
    The Base32 encoded TOTP secret.

.PARAMETER Period
    The time period in seconds for the TOTP code. The default is 30 seconds.

.PARAMETER Digits
    The number of digits for the TOTP code. The default is 6 digits.

.PARAMETER Algorithm
    The hashing algorithm to use for generating the HMAC hash. Supported algorithms are "SHA1", "SHA256", and "SHA512". The default is "SHA1".

.EXAMPLE
    $TOTPSecret = "JBSWY3DPEHPK3PXP"
    $MFA = Convert-TOTPToMFA -Secret $Secret -Period 30 -Digits 6 -Algorithm "SHA1"
    Write-Host "Generated TOTP Code: $MFA"

    This example generates a 6-digit TOTP code using the provided secret, a 30-second period, and the SHA1 algorithm.

.NOTES
    Note: If the MFA code is not valid. Synchronize your system clock with the configured NTP server
    - Check the synchronization status : "w32tm /query /status"
    - If the service is not running, start Windows Time service : "Start-Service w32time"
    - Resynchronize the system clock : "w32tm /resync"
    - Check the synchronization status again : "w32tm /query /status"

    This script is based on the TOTP algorithm described in RFC 6238: https://tools.ietf.org/html/rfc6238

    Special thanks to https://totp.danhersam.com/ (https://github.com/jaden/totp-generator/tree/master) and https://github.com/hectorm/otpauth for providing useful
    source code for decoding TOTP secrets. 

    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 3/20/2025
.LINK
    https://github.com/EReis0/PowerShell-Modules/tree/main/Modules/KitchenSink
#>

#>
function Convert-TOTPToMFA {
    param (
        [string]$Secret,
        [int]$Period = 30,
        [int]$Digits = 6,
        [string]$Algorithm = "SHA1"
    )

    # Function to decode Base32 TOTP secret
    function Decode-Base32 {
        param (
            [string]$Base32String
        )

        $Base32Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
        $Base32String = $Base32String.ToUpper().TrimEnd("=")
        $SecretBytes = @()
        $Bits = 0
        $Value = 0

        foreach ($Char in $Base32String.ToCharArray()) {
            $Index = $Base32Chars.IndexOf($Char)
            if ($Index -lt 0) {
                throw "Error: Invalid character '$Char' in TOTP secret."
            }
            $Value = ($Value -shl 5) -bor $Index
            $Bits += 5
            if ($Bits -ge 8) {
                $Bits -= 8
                $SecretBytes += [byte]($Value -shr $Bits)
                $Value = $Value -band ((1 -shl $Bits) - 1)
            }
        }

        return $SecretBytes
    }

    if (-not [string]::IsNullOrEmpty($Secret)) {
        # Decode the Base32 TOTP secret
        $SecretBytes = Decode-Base32 -Base32String $Secret

        if (-not $SecretBytes) {
            throw "Error: Failed to decode TOTP secret."
        }

        # Calculate the time step
        $UnixTime = [math]::Floor(((Get-Date).ToUniversalTime() - [datetime]'1970-01-01').TotalSeconds / $Period)
        $TimeStepBytes = [BitConverter]::GetBytes([UInt64]$UnixTime)
        if ([BitConverter]::IsLittleEndian) {
            [Array]::Reverse($TimeStepBytes)
        }

        # Generate the HMAC hash
        $HMAC = switch ($Algorithm) {
            "SHA1" { New-Object System.Security.Cryptography.HMACSHA1 }
            "SHA256" { New-Object System.Security.Cryptography.HMACSHA256 }
            "SHA512" { New-Object System.Security.Cryptography.HMACSHA512 }
            default { throw "Unsupported algorithm: $Algorithm" }
        }
        $HMAC.Key = $SecretBytes
        $Hash = $HMAC.ComputeHash($TimeStepBytes)

        # Extract the dynamic offset and calculate the TOTP
        $Offset = $Hash[-1] -band 0x0F
        $BinaryCode = (($Hash[$Offset] -band 0x7F) -shl 24) -bor (($Hash[$Offset + 1] -band 0xFF) -shl 16) -bor (($Hash[$Offset + 2] -band 0xFF) -shl 8) -bor ($Hash[$Offset + 3] -band 0xFF)
        $Code = $BinaryCode % [math]::Pow(10, $Digits)

        return $Code.ToString().PadLeft($Digits, '0')
    } else {
        throw "Error: TOTP secret is null or empty."
    }
}



<#
.SYNOPSIS
    Formats a phone number string to a standard format, including handling extensions.

.DESCRIPTION
    The Format-PhoneNumber function takes a phone number string as input and formats it to a standard format (e.g., (123) 456-7890). It also handles extensions, appending them to the formatted phone number if present.

.PARAMETER phoneNumber
    The phone number string that needs to be formatted.

.EXAMPLE
    $phoneNumber = "(602) 755-0405 EXT 250405"
    $formattedPhoneNumber = Format-PhoneNumber -phoneNumber $phoneNumber
    Write-Output $formattedPhoneNumber
    # Output: "(602) 755-0405 x250405"

.EXAMPLE
    $phoneNumber = "623-294-8427"
    $formattedPhoneNumber = Format-PhoneNumber -phoneNumber $phoneNumber
    Write-Output $formattedPhoneNumber
    # Output: "(623) 294-8427"

.EXAMPLE
    $phoneNumber = "3144943670"
    $formattedPhoneNumber = Format-PhoneNumber -phoneNumber $phoneNumber
    Write-Output $formattedPhoneNumber
    # Output: "(314) 494-3670"

.EXAMPLE
    $phoneNumber = "(972) 499-6799x556799"
    $formattedPhoneNumber = Format-PhoneNumber -phoneNumber $phoneNumber
    Write-Output $formattedPhoneNumber
    # Output: "(972) 499-6799 x556799"

.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 12/13/2024

.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
function Format-PhoneNumber {
    param (
        [string]$phoneNumber
    )
    # Remove any non-digit characters except for 'x' and 'X' for extensions
    $cleanPhoneNumber = $phoneNumber -replace '[^\dXx]', ''
    
    # Check if the phone number has an extension
    if ($cleanPhoneNumber -match '(\d{10})([Xx]\d+)?') {
        $mainNumber = $matches[1]
        $extension = $matches[2]

        # Format the main number
        $formattedNumber = $mainNumber -replace '(\d{3})(\d{3})(\d{4})', '($1) $2-$3'

        # Append the extension if it exists
        if ($extension) {
            $formattedNumber += " x" + $extension.Substring(1)
        }

        return $formattedNumber
    } else {
        return $phoneNumber
    }
}


<#
.SYNOPSIS
    Asks the user a yes or no question and returns the answer.
.DESCRIPTION
    This function asks the user a yes or no question and returns the answer. The function uses the PowerShell host's `PromptForChoice` method to display the question and choices. The question is specified using the `$Question` parameter.
.PARAMETER Question
    Specifies the question to ask the user.
.EXAMPLE
    Get-AskUserYNQuestion -Question 'Are you ready?'
    This example asks the user the question "Are you ready?" and returns the user's answer.
.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 8/2023
.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
Function Get-AskUserYNQuestion {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$Question
    )
    $caption = $Question
    $message = "Choices:"
    $choices = @("&Yes","&No")
    
    $choicedesc = New-Object System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription] 
    $choices | ForEach-Object  {$choicedesc.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList $_))} 
    
    $prompt = $Host.ui.PromptForChoice($caption, $message, $choicedesc, 0)
    
    $Answer = Switch ($prompt){
           0 {"Yes"}
           1 {"No"}
         }
         return $Answer
} #Get-AskUserYNQuestion -Question 'Are you ready?'


<#
.SYNOPSIS
    Prompts the user to select a CSV file using a file browser dialog.
.DESCRIPTION
    This function prompts the user to select a CSV file using a file browser dialog. The function uses the .NET Framework's `System.Windows.Forms.OpenFileDialog` class to display the dialog. The initial directory can be specified using the `$initialDirectory` parameter. The function only allows CSV files to be selected.
.PARAMETER initialDirectory
    Specifies the initial directory to display in the file browser dialog.
.EXAMPLE
    Get-CSVFilePath -initialDirectory "C:\Users\UserName\Documents"
    This example displays the file browser dialog with the initial directory set to "C:\Users\UserName\Documents", and only allows CSV files to be selected.
.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 8/2023
.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
Function Get-CSVFilePath($initialDirectory) {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.Filter = "CSV UTF-8 (Comma Delimited) (*.csv)| *.csv"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}


<#
.SYNOPSIS
    Displays a folder browser dialog and returns the selected folder.
.DESCRIPTION
    This function displays a folder browser dialog and returns the selected folder. The function uses the .NET Framework's `System.Windows.Forms.FolderBrowserDialog` class to display the dialog. The initial directory can be specified using the `$initialDirectory` parameter.
.PARAMETER initialDirectory
    Specifies the initial directory to display in the folder browser dialog.
.EXAMPLE
    Get-Folder -initialDirectory "C:\Users\UserName\Documents"
    This example displays the folder browser dialog with the initial directory set to "C:\Users\UserName\Documents".
.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 8/2023
.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
Function Get-Folder($initialDirectory){

        [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
        $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
        $foldername.Description = "Select a folder"
        $foldername.rootfolder = "MyComputer"
        $foldername.SelectedPath = $initialDirectory
    
        if($foldername.ShowDialog() -eq "OK"){
        $folder += $foldername.SelectedPath
        }
        
        return $folder
} 


<#
.SYNOPSIS
    Downloads and extracts a zip file from a specified URL to a specified output folder.
.DESCRIPTION
    The Get-GithubProject function downloads a zip file from a specified URL and extracts it to a specified output folder. The function creates a temporary file with a .zip extension, downloads the file from the URL using Invoke-WebRequest, extracts the contents of the file to the output folder using Expand-Archive, and then removes the temporary file.
.PARAMETER url
    Specifies the URL of the zip file to download.
.PARAMETER output
    Specifies the output folder where the contents of the zip file will be extracted.
.EXAMPLE
    Get-GithubProject -url "https://github.com/EReis0/PowerShell-Modules/archive/refs/heads/main.zip" -output "C:\Users\thebl\Documents\New folder"
    Downloads the zip file from the specified URL and extracts its contents to the specified output folder.
    **Copy the URL for the zip file from the GitHub repository.**
.NOTES
    Author: Codeholics - Eric Reis (https://github.com/EReis0)
    Date: 5/25/2022
#>
function Get-GithubProject {
    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $true)]
        [string]$url,

        [parameter(Mandatory = $true)]
        [string]$output
    )
    try {
        # create temp with zip extension (or Expand will complain)
        $tmp = New-TemporaryFile | Rename-Item -NewName {$_ -replace 'tmp$', 'zip' } -PassThru
        #download
        Invoke-WebRequest -outFile $tmp $url
        #exract to same folder
        $tmp | Expand-Archive -DestinationPath $output -force
        # remove temporary file
        $tmp | remove-item
    }catch {
        $_.Error
    }
}


<#
.SYNOPSIS
    Generates a Google Maps URL for a given address.

.DESCRIPTION
    The `Get-GoogleMapsURL` function takes an address as input, encodes it for use in a URL, and generates a Google Maps URL. 
    It validates the URL by making a web request to ensure it is accessible.

.PARAMETER Address
    The address for which the Google Maps URL should be generated. This parameter is mandatory.

.EXAMPLE
    PS> Get-GoogleMapsURL -Address "200 S Executive Dr., Suite 1013, Brookfield, WI 53005"
    https://www.google.com/maps?q=200+S+Executive+Dr.%2C+Suite+1013%2C+Brookfield%2C+WI+53005

    This example generates a Google Maps URL for the specified address.

.EXAMPLE
    PS> Get-GoogleMapsURL -Address "1600 Amphitheatre Parkway, Mountain View, CA"
    https://www.google.com/maps?q=1600+Amphitheatre+Parkway%2C+Mountain+View%2C+CA

    This example generates a Google Maps URL for the Google headquarters address.

.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 03/30/2025
#>
function Get-GoogleMapsURL {
    param (
        [string][Parameter(Mandatory=$true)]$Address
    )

    if ($null -ne $Address) {
        $WebEncode = [System.Net.WebUtility]::UrlEncode($Address)
        $MapsURL = "https://www.google.com/maps?q=$WebEncode"
    }
    else {
        throw "Address is null or empty. Please provide a valid address."
        return $null
    }

    try {
        $Validation = (Invoke-WebRequest -Uri $MapsURL -UseBasicParsing).StatusCode
    } catch {
        throw "Error: Unable to access Google Maps URL. Please check your internet connection or the URL."
        return $null
    }

    if ($Validation -eq 200) {
        return $MapsURL
    } else {
        throw "Error: Unable to create Google Maps URL. Status code: $Validation"
        return $null
    }

}



<#
.SYNOPSIS
    Checks for updates to PowerShell modules installed from the PowerShell Gallery.
.DESCRIPTION
    The Get-ModuleUpdates function checks for updates to PowerShell modules installed from the PowerShell Gallery. 
    It compares the installed version of each module to the latest version available in the gallery and reports any modules
    that have updates available.
.PARAMETER None
    This function does not accept any parameters.
.EXAMPLE
    PS C:\> Get-ModuleUpdates
    Checks for updates to PowerShell modules installed from the PowerShell Gallery and reports any modules that have updates available.
.EXAMPLE
    $test = Get-ModuleUpdates
    clear-host
    Write-Host $test -ForegroundColor Green
.NOTES
    This function requires PowerShell 5.0 or later and an internet connection to access the PowerShell Gallery.

    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 10/2023
.Link
    https://github.com/EReis0/PowerShell-Samples/
#>
function Get-ModuleUpdates {
    $InstalledModules = Get-InstalledModule
    $BaseUri = "https://www.powershellgallery.com/packages/"

    $Data = @()
    foreach ($item in $InstalledModules) {
        Try{
        $PSGallery = Find-Module -Name $item.Name -Repository PSGallery | 
            Select-Object -Property Name, Version, PublishedDate, @{Name = "InstalledVersion"; Expression = {$item.Version}}
        } Catch {
            
        }
        $Row = New-Object -TypeName PSObject -Property @{
            Name = $PSGallery.Name
            Version = $PSGallery.Version
            PublishedDate = $PSGallery.PublishedDate
            InstalledVersion = $PSGallery.InstalledVersion
            UpdateAvailable = $PSGallery.Version -gt $PSGallery.InstalledVersion
            Link = $BaseUri + $PSGallery.Name
        }
        $Data += $Row
    }

    $UpdateAvailable = $Data | Where-Object -Property UpdateAvailable -eq $true

    return $UpdateAvailable | Select-Object Name,UpdateAvailable,InstalledVersion,Version,PublishedDate,Link | Sort-Object -Property Name
}



<#
.SYNOPSIS
    Checks if a service is running and starts it if it's not.
.DESCRIPTION
    The Get-ServiceCheck function checks if a service is running and starts it if it's not. 
    It takes an array of service names as input and checks each service in the array.
.PARAMETER ServiceName
    Specifies an array of service names to check.
.EXAMPLE
    Get-ServiceCheck -ServiceName @('PlexUpdateService', 'Spooler')
    This example checks if the 'PlexUpdateService' and 'Spooler' services are running and starts them if they're not
.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 10/2023
.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
function Get-ServiceCheck {
    [cmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$ServiceName
    )

    foreach ($Service in $ServiceName) {
        # Check if service is running
        try{
            $ServiceCheck = Get-Service -Name $Service -ErrorAction SilentlyContinue
        } catch {
            Write-Warning "[$(Get-Date)] Ran into an unexpected error trying to locate $Service. Failed running Get-Service. "
            $_.Exception.Message
        }

        if ($null -eq $ServiceCheck) {
            Write-Warning "[$(Get-Date)]  $Service service not found."
        } else {
            if ($ServiceCheck.Status -ne 'Running') {

                try {
                    Start-Service $Service -ErrorAction SilentlyContinue
                } catch {
                    Write-Warning "[$(Get-Date)] Ran into an unexpected error when trying to start $Service. Failed running Start-Service. "
                    $_.Exception.Message
                }

                Start-Sleep -Seconds 5
                $ServiceCheck.Refresh()
                if ($ServiceCheck.Status -ne 'Running') {
                    Write-Warning "[$(Get-Date)] $Service service failed to start."
                } else {
                    Write-Host "[$(Get-Date)] $Service service started."
                }
            } else {
                Write-Host "[$(Get-Date)] $Service service is already running."
            }
        }
    }
} # Get-ServiceCheck -ServiceName @('PlexUpdateService')


<#
.SYNOPSIS
    Installs a custom PowerShell module to the appropriate module directory.

.DESCRIPTION
    This function installs a custom PowerShell module by copying the module folder from the specified input directory 
    to the appropriate module directory based on the user level. It also ensures the module is imported into the user's 
    PowerShell profile for automatic loading in future sessions. Optionally, it can unblock unsigned scripts.

.PARAMETER InputDir
    Specifies the path of the module to install. This parameter is mandatory and should point to the folder containing 
    the module files.

.PARAMETER UserLevel
    Specifies the level of the user for which the module should be installed. 
    Valid values are:
        - 'Single': Installs the module for the current user only.
        - 'All': Installs the module for all users on the system.
    The default value is 'All'.

.PARAMETER Unblock
    Indicates whether to unblock the module script if it is not signed. This parameter is optional. 
    If specified, the script will check the signature status of the module and unblock it if necessary.

.EXAMPLE
    Install-CustomModule -InputDir "C:\Users\JohnDoe\Downloads\MyModule" -UserLevel "All"
    Installs the "MyModule" module from the specified input directory to the module directory for all users.

.EXAMPLE
    Install-CustomModule -InputDir "C:\Users\JohnDoe\Downloads\MyModule" -UserLevel "Single"
    Installs the "MyModule" module from the specified input directory to the module directory for the current user only.

.EXAMPLE
    Install-CustomModule -InputDir "C:\Users\JohnDoe\Downloads\MyModule" -UserLevel "All" -Unblock
    Installs the "MyModule" module for all users and unblocks the script if it is not signed.

.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.4
    Date: 04/2025

    This script simplifies the process of installing PowerShell modules by automating the following steps:
        - Copying the module to the appropriate module directory.
        - Adding the module to the user's PowerShell profile for automatic loading.
        - Unblocking unsigned scripts if requested.

    While this script is useful for automating module installation, you can also manually copy the module folder 
    to the module directory (e.g., 'C:\Program Files\WindowsPowerShell\Modules') and add the `Import-Module` command 
    to your profile.

.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
Function Install-CustomModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $InputDir,
        [Parameter(Mandatory=$false)]
        $UserLevel = 'All',
        [Parameter(Mandatory=$false, HelpMessage="Unblock the script if it is not signed.")]
        [switch]$Unblock
    )

    # Get the module name from the input directory
    $ModuleName = $InputDir.Split('\')[-1]

    # Get the module path for single or all users
    if ($UserLevel -eq 'Single') {
        $WindowsPowerShellModulePath = $env:PSModulePath.Split(';')[0]
    } elseif ($UserLevel -eq 'ALL') {
        $WindowsPowerShellModulePath = $env:PSModulePath.Split(';')[1]
    } else {
        Write-Warning "UserLevel must be 'Single' or 'All'"
    }

    $ModuleOutputPath = Join-Path -Path $WindowsPowerShellModulePath -ChildPath $ModuleName
    
    Write-Host "Copy module from $InputDir to $WindowsPowerShellModulePath" -ForegroundColor Black -BackgroundColor white

    # Check if the module is already installed
    $filecheck = test-path $ModuleOutputPath
    if ($filecheck) {
        Write-Host "Removing existing $ModuleName module from $WindowsPowerShellModulePath" -ForegroundColor Black -BackgroundColor Yellow
        Remove-Item -Path $ModuleOutputPath -Force -Recurse
    }

    # Add the directory containing the module to the PSModulePath environment variable
    $env:PSModulePath += ";$InputDir"

    # Unblock the script if the -Unblock parameter is used
    if ($Unblock) {
        Write-Host "Checking script signature and unblocking if necessary..." -ForegroundColor Yellow

        # Replace with the path to your script file
        $scriptPath = Join-Path -Path $InputDir -ChildPath "$($ModuleName).psm1"

        # Check the signature status
        $signature = Get-AuthenticodeSignature -FilePath $scriptPath

        # Display the signature status and unblock if needed
        if ($signature.Status -eq 'Valid') {
            Write-Host "The script is signed and valid." -ForegroundColor Green
        } elseif ($signature.Status -eq 'NotSigned') {
            Write-Host "The script is not signed. Unblocking the file..." -ForegroundColor Yellow
            Unblock-File -Path $scriptPath
            Write-Host "The file has been unblocked." -ForegroundColor Green
        } else {
            Write-Host "The script is signed but the signature is invalid or unknown." -ForegroundColor Red
        }
    }

    # Validate InputDir
    if (-not (Test-Path -Path $InputDir -PathType Container)) {
        Write-Host "The specified InputDir '$InputDir' does not exist or is not a directory." -ForegroundColor Red
        return
    }

    # Copy the module to the module directory
    try{
        Copy-Item -Path $InputDir -Destination $ModuleOutputPath -PassThru -Recurse -ErrorAction Stop | Out-Null
        Write-Host "$ModuleName Was successfully installed to $WindowsPowerShellModulePath" -ForegroundColor Black -BackgroundColor Green
    }catch{
        $CatchError = $_.Exception.Message
        $ErrorType = $CatchError[0].Exception.GetType().FullName
        Write-Host $CatchError -ForegroundColor Black -BackgroundColor Red
        Write-Host $ErrorType -ForegroundColor Black -BackgroundColor Red
    }

    # Run this to create the profile
    $ProfilePath = $profile.CurrentUserCurrentHost # $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
    try {
        $CheckProfile = Test-Path -Path $ProfilePath
        if ($CheckProfile -eq $false) {
            Write-Host "Creating profile at $ProfilePath" -ForegroundColor Black -BackgroundColor Yellow
            New-Item -ItemType File -Path $ProfilePath -Force
        }
    } catch {
        Write-Host "Error creating profile: $($_.Exception.Message)" -ForegroundColor Red
        return
    }

    # Check if the Import-Module command already exists in the profile
    Write-Host "Checking if $ModuleName is already imported in the profile" -ForegroundColor Black -BackgroundColor Yellow

    # If the command (for main module) does not exist, add it to the profile
    $ImportModuleCommand = "Import-Module -Name $ModuleName"
    $EscapedPattern = [regex]::Escape($ImportModuleCommand) # Escape special characters in the command
    if (-not (Select-String -Path $ProfilePath -Pattern $EscapedPattern -Quiet)) {
        Write-Host "Adding $ModuleName to the profile" -ForegroundColor Black -BackgroundColor Yellow
        Add-Content -Path $ProfilePath -Value "$ImportModuleCommand"
    }

    # Find Submodules
    $SubModules = @(Get-ChildItem -Path $ModuleOutputPath -Recurse -Filter '*.psm1' |
    Where-Object {$_.BaseName -ne $ModuleName} | Select-Object Name,BaseName,FullName | Out-Null)

    # Add submodules to the profile
    if ($SubModules) {
        foreach ($SubModule in $SubModules) {
            $ImportSubModuleCommand = "Import-Module -Name '$($SubModule.FullName)'"
            if (-not (Select-String -Path $ProfilePath -Pattern [regex]::Escape($ImportSubModuleCommand) -Quiet)) {
                Write-Host "Adding submodule $($SubModule.BaseName) to the profile" -ForegroundColor Black -BackgroundColor Yellow
                Add-Content -Path $ProfilePath -Value $ImportSubModuleCommand
            }
        }
    }

    Write-host "Validating Installation..." -ForegroundColor Yellow

    # Import the main module
    Import-Module -Name $ModuleName

    # main module installation verification
    $check1 = Get-Module -Name $ModuleName
    $check2 = Get-Command -Module $ModuleName | format-table -AutoSize

    # based on the checks, was installation successful?
    if ($check1 -and $check2) {
        Write-Host "Module Installation was successful!" -ForegroundColor Green
        $check2
    } else {
        Write-Host "Module Installation failed!" -ForegroundColor Red
    }


    if ($SubModules){
        # Import the submodules
        foreach ($item in $SubModules) {
            Import-Module -Name $($item.BaseName)
            $check3 = Get-Module -Name $($item.BaseName)
            $check4 = Get-Command -Module $($item.BaseName) | format-table -AutoSize
            $AllCommands = Get-Command -Module $($item.BaseName), $ModuleName

            if ($check3 -and $check4) {
                Write-Host "SubModule [$($item.BaseName)] was successfully installed!" -ForegroundColor Green
                $AllCommands
            } else {
                Write-Host "SubModule [$($item.BaseName)] was not installed!" -ForegroundColor Red
            }
        }

        if ($SubModules){
            $AllCommands
        } else {
            $check2
        }
    }
}  # Install-CustomModule -InputDir 'D:\Code\Repos\PowerShell-Modules\Modules\KitchenSink' -UserLevel 'All' 
# Install-CustomModule -InputDir 'D:\Code\Repos\LD\PowerShell LD\WolfPack2' -UserLevel 'All' -unblock


<#
.SYNOPSIS
    Installs a custom module from the downloads folder to the module directory.
.DESCRIPTION
    This function installs a custom module from the downloads folder to the module directory. 
    The function copies the module folder from the downloads folder to the module directory, 
    and removes any existing module with the same name. If an Anti-Virus is running, it may flag this script as a virus. 
    You will have to exclude powershell.exe from your AV during the installation.
.PARAMETER InputDir
    Specifies the path of the module to install. This parameter is mandatory. It should be the path to your module folder.
.PARAMETER UserLevel
    Specifies the level of the user for which the module should be installed. 
    This parameter is optional and can be set to either 'Single' or 'All'. If not specified, the default value is 'All'.
.EXAMPLE
    Install-CustomModule -InputDir "C:\Users\thebl\Downloads\KitchenSink" -UserLevel "All"
    This example installs the "KitchenSink" module from the -InputDir  to the module directory for all users.

    Install-CustomModule -InputDir "C:\Users\thebl\Downloads\KitchenSink" -UserLevel "Single"
    This example installs the "KitchenSink" module from the -InputDir  to the module directory for the current user.
.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.1
    Date: 10/2023

    You don't really need this script, you can technically just copy the folder and paste it to the module directory 
    'C:\Program Files\WindowsPowerShell\Modules'. Then you will need to add the import-module command to your profile.
    
    Installing the module is useful but you can also just import-module with the path to use it for a script.
.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
Function Install-CustomModuleOG {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $InputDir,
        [Parameter(Mandatory=$false)]
        $UserLevel = 'All'
    )

    # Get the module name from the input directory
    $ModuleName = $InputDir.Split('\')[-1]

    # Get the module path for single or all users
    if ($UserLevel -eq 'Single') {
        $WindowsPowerShellModulePath = $env:PSModulePath.Split(';')[0]
    } elseif ($UserLevel -eq 'ALL') {
        $WindowsPowerShellModulePath = $env:PSModulePath.Split(';')[1]
    } else {
        Write-Warning "UserLevel must be 'Single' or 'All'"
    }

    $ModuleOutputPath = Join-Path -Path $WindowsPowerShellModulePath -ChildPath $ModuleName
    
    Write-Host "This script will install the $ModuleName module to the module directory." -ForegroundColor Black -BackgroundColor white
    Write-Host "Copy module from $InputDir to $WindowsPowerShellModulePath" -ForegroundColor Black -BackgroundColor white

    # Check if the module is already installed
    $filecheck = test-path $ModuleOutputPath
    if ($filecheck) {
        Write-Host "Removing existing $ModuleName module from $WindowsPowerShellModulePath" -ForegroundColor Black -BackgroundColor Yellow
        Remove-Item -Path $ModuleOutputPath -Force -Recurse
    }

    # Copy the module to the module directory
    try{
    Copy-Item -Path $InputDir -Destination $ModuleOutputPath -PassThru -Recurse -ErrorAction Stop
    Write-Host "$ModuleName Was successfully installed to $WindowsPowerShellModulePath" -ForegroundColor Black -BackgroundColor Green
    }catch{
        $CatchError = $_.Exception.Message
        $ErrorType = $CatchError[0].Exception.GetType().FullName
        Write-Host $CatchError -ForegroundColor Black -BackgroundColor Red
        Write-Host $ErrorType -ForegroundColor Black -BackgroundColor Red
    }

    # Run this to create the profile
    $ProfilePath = "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
    $CheckProfile = Test-Path -Path $ProfilePath
    if ($CheckProfile -eq $false) {
        Write-Host "Creating profile at $ProfilePath" -ForegroundColor Black -BackgroundColor Yellow
        New-Item -ItemType File -Path $ProfilePath -Force
    }

    # Check if the Import-Module command already exists in the profile
    Write-Host "Checking if $ModuleName is already imported in the profile" -ForegroundColor Black -BackgroundColor Yellow
    $ProfileContent = Get-Content -Path $ProfilePath
    $ImportModuleCommand = "Import-Module -Name $ModuleName"
    $CommandExists = $ProfileContent -like "*$ImportModuleCommand*"

    # If the command does not exist, add it to the profile
    if (-not $CommandExists) {
        Write-Host "Adding $ModuleName to the profile" -ForegroundColor Black -BackgroundColor Yellow
        Add-Content -Path $ProfilePath -Value "`n$ImportModuleCommand`n"
    }

    Write-host "Validating Installation..." -ForegroundColor Yellow
    Import-Module -Name $ModuleName

    $check1 = Get-Module -Name $ModuleName

    $check2 = Get-Command -Module $ModuleName | format-table -AutoSize

    if ($check1 -and $check2) {
        Write-Host "Installation was successful!" -ForegroundColor Green
        $check2
    } else {
        Write-Host "Installation failed!" -ForegroundColor Red
    }
}  # Install-CustomModule -InputDir 'D:\Code\Repos\PowerShell-Modules\Modules\KitchenSink' -UserLevel 'All'


<#
.SYNOPSIS
    Speaks the specified text using the default system settings.

.DESCRIPTION
    The `Invoke-Speech` function speaks the specified text using the default system settings. 
    You can specify the speed, volume, and voice of the speech. Additionally, you can generate a standalone PowerShell script 
    that reproduces the speech settings or return the current speech settings as a hash table.

.PARAMETER Text
    The text to speak.

.PARAMETER Speed
    The speed of the speech, in words per minute. Higher values result in faster speech.

.PARAMETER Volume
    The volume of the speech, as a percentage of the maximum volume (0 to 100).

.PARAMETER Voice
    The name of the voice to use for the speech. Use `Get-InstalledVoices` to list available voices.

.PARAMETER Generate
    Generates a standalone PowerShell script (`My_Speech_Script.ps1`) on the desktop that reproduces the speech settings.
    The script includes all specified parameters (e.g., speed, volume, voice, and text) and can be executed independently.

.PARAMETER Resume
    Returns a hash table of the current speech settings, including the text, speed, volume, and voice. 
    This is useful for debugging or saving the configuration for later use.

.EXAMPLE
    Invoke-Speech -Text "Hello, world!"

    This example speaks the text "Hello, world!" using the default system settings.

.EXAMPLE
    Invoke-Speech -Text "Hello, world!" -Speed 200 -Volume 50 -Voice "Microsoft David Desktop"

    This example speaks the text "Hello, world!" using the Microsoft David Desktop voice, at a speed of 200 words per minute and a volume of 50%.

.EXAMPLE
    Invoke-Speech -Text "Hello, world!" -Generate

    This example speaks the text "Hello, world!" and generates a standalone PowerShell script (`My_Speech_Script.ps1`) on the desktop 
    that reproduces the speech settings.

.EXAMPLE
    Invoke-Speech -Text "Hello, world!" -Resume

    This example speaks the text "Hello, world!" and returns a hash table of the current speech settings.

.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.2
    Date: 4/2025

.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
function Invoke-Speech {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true, position=1)]		
        [string] $Text,				
        [Parameter(Mandatory=$False,Position=1)]
        [int] $Speed,
        [Parameter(Mandatory=$False,Position=1)]
        [int] $Volume,	
        [Parameter(Mandatory=$False,Position=1)]
        [string] $Voice,		
        [Parameter(Mandatory=$False,Position=1)]		
        [switch] $Generate,	
        [Parameter(Mandatory=$False,Position=1)]		
        [switch] $Resume				
    )
    
    Try {						
        Add-Type -AssemblyName System.speech
        $Global:Talk = New-Object System.Speech.Synthesis.SpeechSynthesizer
        If ($Voice) {
            $Talk.SelectVoice($Voice)
        }
    } Catch {
        throw "Cannot load the System Speech assembly: $($_.Exception.Message)"
    }		
    

    If ($Speed) {
        $Talk.Rate = $Speed
    }
        
    If ($Volume) {
        $Talk.Volume = $Volume
    }
        
    $Talk.Speak($Text)

    If ($Generate) {
        $Script_File = "$([Environment]::GetFolderPath('Desktop'))\My_Speech_Script.ps1"
        New-Item $Script_File -type file				
        Add-Content $Script_File "#Load assembly"	
        Add-Content $Script_File 'Add-Type -AssemblyName System.speech'
        Add-Content $Script_File '$Talk = New-Object System.Speech.Synthesis.SpeechSynthesizer'

        If ($Voice) {
            Add-Content $Script_File ""	
            Add-Content $Script_File "# Set the selectd voice"			
            Add-Content $Script_File ('$Talk.SelectVoice' + "('" + "$Voice" + "')")
        }

        If ($Speed) {
            Add-Content $Script_File ""	
            Add-Content $Script_File "# Set the speed value"				
            Add-Content $Script_File ('$Talk.Rate = ' + '"' + "$Speed" + '"')
        }

        If ($Volume) {
            Add-Content $Script_File ""	
            Add-Content $Script_File "# Set the volume value"			
            Add-Content $Script_File ('$Talk.Volume = ' + '"' + "$Volume" + '"')
        }
                
        Add-Content $Script_File ""	
        Add-Content $Script_File "# Set the text to speak"			
        Add-Content $Script_File ('$Talk.Speak(' + '"' + "$Text" + '")')				
    }

    If ($Resume) {
        $ResumeOutput = @{
            "Volume" = $Talk.Volume
            "Speed" = $Talk.Rate
            "Voice" = $Talk.Voice.Name
            "Text" = $Text
            "Generate script" = $Generate
        }
        $ResumeOutput
    }
    # New-Alias -Name "speak" -Value "Invoke-Speech"
    # Set-Alias -Name "speak" -Value "Invoke-Speech"
}  # Invoke-Speech -Text "Hello"



<#
.SYNOPSIS
    Combines multiple PowerShell function files into a single module file (.psm1).

.DESCRIPTION
    The `Join-FunctionsToPSM` function creates a single PowerShell module file (.psm1) by combining all `.ps1` files from a specified folder. 
    The resulting `.psm1` file will have the same name as the root folder and will include all the functions from the specified folder. 
    Each function definition in the `.psm1` file will be separated by two blank lines for readability.

    If a `.psm1` file with the same name already exists, the function creates a backup of the existing file with a `.bak` extension before overwriting it. 
    If a `.bak` file already exists, it will be removed and replaced with the latest backup.

.PARAMETER RootDir
    Specifies the root folder path of the module/project. This is the folder where the `.psm1` file will be created.
    The name of the `.psm1` file will match the name of this folder.

.PARAMETER FunctionsDir
    Specifies the name of the folder within the root directory that contains the `.ps1` function files.
    The default value is "Functions". This parameter can be a relative or absolute path.

.EXAMPLE
    Join-FunctionsToPSM -RootDir "C:\Github\ProjectSample" -FunctionsDir "Functions"
    This example creates a `.psm1` file in the `C:\Github\ProjectSample` folder by combining all `.ps1` files in the `Functions` subfolder.

.EXAMPLE
    Join-FunctionsToPSM -RootDir "C:\Modules\MyModule"
    This example creates a `.psm1` file in the `C:\Modules\MyModule` folder by combining all `.ps1` files in the default `Functions` subfolder.

.EXAMPLE
    Join-FunctionsToPSM -RootDir "D:\Projects\MyModule" -FunctionsDir "CustomFunctions" -Verbose
    This example creates a `.psm1` file in the `D:\Projects\MyModule` folder by combining all `.ps1` files in the `CustomFunctions` subfolder.
    The `-Verbose` switch provides detailed output during the function's execution.

.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.2
    Date: 4/21/2025

.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
function Join-FunctionsToPSM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$RootDir,

        [Parameter(Mandatory = $false)]
        [string]$FunctionsDir = "Functions"
    )

    # Validate Parameter $RootDir
    try {
        $RootDir = Resolve-Path -Path $RootDir -ErrorAction Stop
        $RootDirName = (Get-Item -Path $RootDir).Name
        Write-Verbose "Resolved root directory: $RootDir"
    } catch {
        throw "Invalid path: $RootDir. Error: $($_.Exception.Message)"
    }
    
    # Validate Parameter $FunctionsDir
    $FunctionsDir = Join-Path -Path $RootDir -ChildPath $FunctionsDir
    if (-not (Test-Path $FunctionsDir)) {
        throw "Functions directory does not exist: $FunctionsDir"
    }
    Write-Verbose "Resolved functions directory: $FunctionsDir"

    # Create PSM file path
    $FullPSMPath = Join-Path -Path $RootDir -ChildPath "$RootDirName.psm1"
    Write-Verbose "Output PSM file path: $FullPSMPath"

    # Check if the PSM file already exists and back it up if it does
    if (Test-Path $FullPSMPath) {
        $BackupPath = "$FullPSMPath.bak"
        if (Test-Path $BackupPath) {
            Remove-Item -Path $BackupPath -Force
            Write-Verbose "Existing backup file removed: $BackupPath"
        }
        Copy-Item -Path $FullPSMPath -Destination $BackupPath -Force
        Write-Verbose "Existing PSM file backed up to: $BackupPath"
    }

    # Initialize StringBuilder to store function content
    $ResultBuilder = [System.Text.StringBuilder]::new()

    # Get all .ps1 files in the functions directory
    $Ps1Files = Get-ChildItem -Path $FunctionsDir -Recurse -Filter *.ps1 -File | Sort-Object Name
    if (-not $Ps1Files) {
        throw "No .ps1 files found in the functions directory: $FunctionsDir. Ensure the directory contains valid PowerShell function files."
    }
    
    # Read the content of each .ps1 file and append it to the StringBuilder
    foreach ($File in $Ps1Files) {
        $FileContent = Get-Content $File.FullName -Raw
        $null = $ResultBuilder.AppendLine($FileContent) # Append the file content
        $null = $ResultBuilder.AppendLine() # Add a blank line
        $null = $ResultBuilder.AppendLine() # Add another blank line
    }

    # Export the functions to the PSM file
    try {
        Set-Content -Value $ResultBuilder.ToString() -Path $FullPSMPath -Encoding UTF8
    } catch {
        throw "Failed to write to file: $FullPSMPath. Error: $($_.Exception.Message)"
    }
    Write-Host "PSM file created successfully: $FullPSMPath" -ForegroundColor Green
} # Join-FunctionsToPSM -RootDir "D:\Code\Repos\PowerShell-Modules\Modules\KitchenSink"


<#
.SYNOPSIS
    A function to create a password file or validate a password against a file.

.DESCRIPTION
    The `New-CredsTxtFile` function prompts the user for a password and saves it to a file, or validates a password against a file. 
    If the `-Validate` parameter is specified, the function validates the password entered by the user against the password stored in the file. 
    If the `-Validate` parameter is not specified, the function prompts the user for a password and securely saves it to the specified file.

    The password is encrypted when saved to the file and decrypted during validation. 
    The function ensures that the file exists before validation and provides meaningful error messages for invalid or corrupted files.

.PARAMETER Filepath
    The path of the file to save the password to or validate the password against.
    This parameter is mandatory.

.PARAMETER Validate
    If specified, the function validates the password entered by the user against the password stored in the file.
    If not specified, the function prompts the user for a password and saves it to the file.

.EXAMPLE
    New-CredsTxtFile -Filepath "C:\creds\sample55.txt"

    This command prompts the user for a password and saves it to the file at `C:\creds\sample55.txt`.

.EXAMPLE
    New-CredsTxtFile -Filepath "C:\creds\sample55.txt" -Validate

    This command validates the password entered by the user against the password stored in the file at `C:\creds\sample55.txt`.

.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.3
    Date: 04/21/2025

.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
function New-CredsTxtFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Filepath,
        [Parameter(Mandatory=$false)]
        [switch]$Validate
    )

    # If -Validate is specified, validate the file
    if ($Validate) {
        # Verify file path exists
        if (-not (Test-Path -Path $Filepath)) {
            throw "File does not exist: $Filepath. Please specify a valid file path."
        }

        # Prompt for password
        $Credential = Get-Credential -Message "Enter your password" -UserName "Admin"
        
        # If the credential prompt is cancelled, exit the function
        if ($null -eq $Credential) {
            Write-Warning "Credential prompt was cancelled. Exiting..."
            return
        } else {
            $Password = $Credential.GetNetworkCredential().Password
        }

        # Verify password file
        try {
            $SecureString = ConvertTo-SecureString -String (Get-Content $Filepath)
        } catch {
            throw "The password file is invalid or corrupted: $($_.Exception.Message)"
        }

        $SecretContent = [System.Net.NetworkCredential]::new("", $SecureString).Password

        # Compare the password for a match
        if ($SecretContent -eq $Password) {
            Write-Host "Password MATCHED decrypted password." -ForegroundColor Green
        } else {
            Write-Warning "Password DOES NOT MATCH decrypted password."
        }
    } else {
        # Prompt for password
        $Credential = Get-Credential -Message "Enter your password" -UserName "Admin"

        # If the credential prompt is cancelled, exit the function
        if ($null -eq $Credential) {
            Write-Warning "Credential prompt was cancelled. Exiting..."
            return
        } else {
            $Password = $Credential.GetNetworkCredential().Password
        }

        # Save the password
        Write-Host "Exporting Password to $Filepath" -ForegroundColor Green
        ConvertTo-SecureString -String $Password -AsPlainText -Force | ConvertFrom-SecureString | Out-File $Filepath -Encoding UTF8
    }
}  # New-CredsTxtFile -Filepath "C:\creds\sample.txt" -Validate


<#
.SYNOPSIS
    Creates a new JSON file containing secure data.
.DESCRIPTION
    The New-SecuredJSON function creates a new JSON file containing secure data. 
    The function encrypts the secure data and saves it to the specified file path.
.PARAMETER Filepath
    Specifies the path to the JSON file to create.
.PARAMETER Params
    Specifies a hashtable of key-value pairs to include in the JSON object. 
    The keys in the hashtable will be used as the property names in the JSON object.
.EXAMPLE
    PS C:\> $params = @{
        "Password" = "P@ssw0rd"
        "Username" = "MyUsername"
        "StudentID" = "568566"
    }
    PS C:\> New-SecuredJSON -Filepath "D:\Code\test4.json" -Params $params

    This example creates a new JSON file at the specified file path with the specified key-value pairs.
.EXAMPLE
    Another way to pass the parameters.
    PS C:\> New-SecuredJSON -Filepath "D:\Code\test4.json" -Params @{"Password" = "P@$sW0rD"; "Username" = "MTestco"}

    This example creates a new JSON file at the specified file path with the specified key-value pairs.
.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 10/2023
.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
function New-SecuredJSON {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Filepath,
        [Parameter(Mandatory=$true)]
        [hashtable]$Params
    )
    
    # Create JSON object
    $Json = @{}
    foreach ($key in $Params.Keys) {
        if ($Params[$key]) {
            $Json.$key = (ConvertTo-SecureString -String $Params[$key] -AsPlainText -Force) | ConvertFrom-SecureString
        }
    }

    # Convert the JSON object to a string
    $JsonString = $Json | ConvertTo-Json

    # Write JSON object to file
    $JsonString | Out-File -FilePath $Filepath
    Write-Host "Exported JSON to $Filepath"
} # New-SecuredJSON -Filepath "D:\Code\test4.json" -Params @{"Password" = "P@ssW0rD"; "Username" = "MTestco"}



<#
.SYNOPSIS
Creates a new JSON file containing secure data.

.DESCRIPTION
The New-SecuredJSONStatic function creates a new JSON file containing secure data. The function encrypts the secure data and saves it to the specified file path.

.PARAMETER Filepath
Specifies the path to the JSON file to create.

.PARAMETER Password
Specifies the password to include in the JSON object.

.PARAMETER Username
Specifies the username to include in the JSON object.

.PARAMETER URL
Specifies the URL to include in the JSON object.

.PARAMETER IP
Specifies the IP address to include in the JSON object.

.PARAMETER Email
Specifies the email address to include in the JSON object.

.PARAMETER Token
Specifies the token to include in the JSON object.

.PARAMETER ClientID
Specifies the client ID to include in the JSON object.

.PARAMETER ClientSecret
Specifies the client secret to include in the JSON object.

.EXAMPLE
PS C:\> New-SecuredJSONStatic -Filepath "D:\Code\test4.json" -Password "P@ssw0rd" -Username "MyUsername" -Email "jdoe@sample.com"

This example creates a new JSON file at the specified file path with the specified key-value pairs.

.NOTES
Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
Version: 1.0

.LINK
https://github.com/EReis0/PowerShell-Samples/
#>
function New-SecuredJSONStatic {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Filepath,
        [Parameter(Mandatory=$true)]
        [string]$Password,
        [Parameter(Mandatory=$false)]
        [string]$Username,
        [Parameter(Mandatory=$false)]
        [string]$URL,
        [Parameter(Mandatory=$false)]
        [string]$IP,
        [Parameter(Mandatory=$false)]
        [string]$Email,
        [Parameter(Mandatory=$false)]
        [string]$Token,
        [Parameter(Mandatory=$false)]
        [string]$ClientID,
        [Parameter(Mandatory=$false)]
        [string]$ClientSecret
    )
    
    # Create JSON object
    $Json = @{}
    foreach ($param in "Password", "Username", "URL", "IP", "Email", "Token", "ClientID", "ClientSecret") {
        if ($PSBoundParameters.$param) {
            $Json.$param = (ConvertTo-SecureString -String $PSBoundParameters.$param -AsPlainText -Force) | ConvertFrom-SecureString
        }
    }

    # Convert the JSON object to a string
    $JsonString = $Json | ConvertTo-Json

    # Write JSON object to file
    $JsonString | Out-File -FilePath $Filepath
    Write-Host "Exported JSON to $Filepath" -ForegroundColor Green
} # New-SecuredJSONStatic -Filepath "D:\Code\test4.json" -Password "P@ssw0rd" -Username "MyUsername" -Email "EReis@loandepot.com"


<#
.SYNOPSIS
    Reads a JSON file containing secure data and returns an object with decrypted properties.
.DESCRIPTION
    The Read-SecuredJSON function reads a JSON file containing secure data and returns an object with decrypted properties. 
    The function decrypts the secure data in the JSON file and returns the decrypted values as plain text.
.PARAMETER Path
    Specifies the path to the JSON file containing the secure data. The file must have a .json extension.
.EXAMPLE
    Plain text values
    PS C:\> $data = Read-SecuredJSON -Path "D:\Code\test4.json"
    PS C:\> $Password = $data.Password

    Convert plain text values to secure strings
    $Data = Read-SecuredJSON -Path "D:\Code\test4.json"
    $Password = $data.Password | ConvertTo-SecureString -AsPlainText -Force

    This example reads the secure data from the "test4.json" file and 
    sets the `$Password` variable to the decrypted value of the "Password" property.
.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 10/2023
.LINK
    https://github.com/EReis0/PowerShell-Samples/
#>
function Read-SecuredJSON {
    [cmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ -PathType Leaf -Include "*.json" })]
        [string]$Path
    )

    $json = get-content $Path | ConvertFrom-Json

    $SecuredData = [PSCustomObject]@{}
    foreach ($property in $json.PSObject.Properties) {
        if ([string]::IsNullOrWhiteSpace($property.Value) -eq $false) {
            $decryptedValue = [System.Net.NetworkCredential]::new("", ($property.Value | ConvertTo-SecureString)).Password
            $SecuredData | Add-Member -MemberType NoteProperty -Name $property.Name -Value $decryptedValue
        }
    }
    return $SecuredData
} # $Data = Read-SecuredJSON -Path "D:\Code\test4.json"



<#
.SYNOPSIS
    Tests the status of a website by checking if it is reachable and if specific text is present on the page.

.DESCRIPTION
    The Test-WebsiteStatus function tests the status of a website by checking if it is reachable and if specific text is present on the
    page. If the website is reachable and the expected text is present, the function returns a message indicating that the website is
    online and functioning correctly. If the website is reachable but the expected text is not present, the function returns a message
    indicating that the website is online but may not be functioning correctly. If the website is not reachable, the function returns
    a message indicating that the website is offline.

.PARAMETER Url
    The URL of the website to test.

.PARAMETER ExpectedText
    The text that should be present on the website.

.EXAMPLE
    Test-WebsiteStatus -Url "www.google.com" -ExpectedText "Google"

    This example tests the status of the website "www.google.com" and checks if the text "Google" is present on the page.

    Url            ExpectedText Online ExpectedTextPresent
    ---            ------------ ------ -------------------
    www.google.com Google         True                True


.NOTES
    Author: Codeholics - Eric Reis (https://github.com/EReis0/)
    Date: 02/06/2024
    Version: 1.1
#>
function Test-WebsiteStatus {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Url,
        [Parameter(Mandatory=$false)]
        [string]$ExpectedText
    )

    # Test the reachability of the website using Test-NetConnection
    try {
    $result = Test-NetConnection -ComputerName $Url -Port 80 -ErrorAction SilentlyContinue
    } catch {
            $_.Exception.Message
        return
    }

    # Check if the website is reachable
    if ($result.TcpTestSucceeded) {
        # Retrieve the content of the website using Invoke-WebRequest
        $response = Invoke-WebRequest -Uri $Url

        # Check if the expected text is present on the page
        if ($ExpectedText -and $response.Content -like "*$ExpectedText*") {
            # The expected text is present on the page and the website is reachable
            $Online = $true
            $ExpectedTextPresent = $true
        } else {
            # The expected text is not present on the page
            $Online = $true
            $ExpectedTextPresent = $false
        }
    } else {
        # The website is not reachable
        $Online = $false
        $ExpectedTextPresent = $false
    }
    # Return the results
    return [PSCustomObject]@{
        Url = $Url
        ExpectedText = $ExpectedText
        Online = $Online
        ExpectedTextPresent = $ExpectedTextPresent
    }
}   # Test-WebsiteStatus -Url "codeholics.com" -ExpectedText "2022 Codeholics"



