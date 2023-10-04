<#
.SYNOPSIS
    Speaks the specified text using the default system settings.
.DESCRIPTION
    The Invoke-Speech function speaks the specified text using the default system settings. 
    You can specify the speed, volume, and voice of the speech, and you can generate a PowerShell script that reproduces the speech settings.
.PARAMETER Text
    The text to speak.
.PARAMETER Speed
    The speed of the speech, in words per minute.
.PARAMETER Volume
    The volume of the speech, as a percentage of the maximum volume.
.PARAMETER Voice
    The name of the voice to use for the speech.
.PARAMETER Generate
    Generates a PowerShell script that reproduces the speech settings.
.PARAMETER Resume
    Returns a hash table of the speech settings.
.EXAMPLE
    Invoke-Speech -Text "Hello, world!"

    This example speaks the text "Hello, world!" using the default system settings.
.EXAMPLE
    Invoke-Speech -Text "Hello, world!" -Speed 200 -Volume 50 -Voice "Microsoft David Desktop"

    This example speaks the text "Hello, world!" using the Microsoft David Desktop voice, at a speed of 200 words per minute and a volume of 50%.
.EXAMPLE
    Invoke-Speech -Text "Hello, world!" -Generate

    This example speaks the text "Hello, world!" and generates a PowerShell script that reproduces the speech settings.
.EXAMPLE
    Invoke-Speech -Text "Hello, world!" -Resume

    This example speaks the text "Hello, world!" and returns a hash table of the speech settings.
.NOTES
    Author: Codeholics (https://github.com/Codeholics) - Eric Reis (https://github.com/EReis0/)
    Version: 1.0
    Date: 10/2023
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
    
    Try
    {						
        Add-Type -AssemblyName System.speech
        $Global:Talk = New-Object System.Speech.Synthesis.SpeechSynthesizer
        If ($Voice)
        {
            $Talk.SelectVoice($Voice)
        }
    }
    Catch 
    {
        Write-Error "Can not load the System Speech assembly"
        exit
    }		
    

    If ($Speed)
    {
        $Talk.Rate = $Speed
    }	
        
    If ($Volume)
    {
        $Talk.Volume = $Volume
    }	
        
    $Talk.Speak($Text)	

    If ($Generate)
    {
        $Script_File = "$([Environment]::GetFolderPath('Desktop'))\My_Speech_Script.ps1"
        New-Item $Script_File -type file				
        Add-Content $Script_File "#Load assembly"	
        Add-Content $Script_File 'Add-Type -AssemblyName System.speech'
        Add-Content $Script_File '$Talk = New-Object System.Speech.Synthesis.SpeechSynthesizer'

        If ($Voice)
        {
            Add-Content $Script_File ""	
            Add-Content $Script_File "# Set the selectd voice"			
            Add-Content $Script_File ('$Talk.SelectVoice' + "('" + "$Voice" + "')")
        }

        If ($Speed)
        {
            Add-Content $Script_File ""	
            Add-Content $Script_File "# Set the speed value"				
            Add-Content $Script_File ('$Talk.Rate = ' + '"' + "$Speed" + '"')
        }

        If ($Volume)
        {
            Add-Content $Script_File ""	
            Add-Content $Script_File "# Set the volume value"			
            Add-Content $Script_File ('$Talk.Volume = ' + '"' + "$Volume" + '"')
        }
                
        Add-Content $Script_File ""	
        Add-Content $Script_File "# Set the text to speak"			
        Add-Content $Script_File ('$Talk.Speak(' + '"' + "$Text" + '")')				
    }

    If ($Resume)
    {
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
