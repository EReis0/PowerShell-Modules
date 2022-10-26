Function Get-AskUserYNQuestion {
    <#
    .SYNOPSIS
        Get-AskUserYNQuestion -Question [string]
    .DESCRIPTION
        Asks the user a yes or no question and returns the answer.
    .NOTES
        N/A
    .LINK
        https://github.com/thebleak13/PowerShell-Samples/blob/main/BleakKitchenSink/README.md
    .EXAMPLE
        PS C:\> Get-AskUserYNQuestion -Question 'Are you ready?'

        Are you ready?
        Choices:
        [Y] Yes  [N] No  [?] Help (default is "Y"): y
        Yes
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$Question
    )
    $caption = $Question
    $message = "Choices:"
    $choices = @("&Yes","&No")
    
    $choicedesc = New-Object System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription] 
    $choices | ForEach-Object  { $choicedesc.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList $_))} 
    
    $prompt = $Host.ui.PromptForChoice($caption, $message, $choicedesc, 0)
    
    $Answer = Switch ($prompt){
           0 {
            "Yes"
            }
           1 {
            "No"
            }
         }
         return $Answer
} #Get-AskUserYNQuestion -Question 'Are you ready?'