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
    $choices | ForEach-Object  { $choicedesc.Add((New-Object "System.Management.Automation.Host.ChoiceDescription" -ArgumentList $_))} 
    
    $prompt = $Host.ui.PromptForChoice($caption, $message, $choicedesc, 0)
    
    #here you can ether us strings or use the choice and take an action (example pull user or pull all users.)
    $Answer = Switch ($prompt)
         {
           0 {
            "Yes"
            
            }
           1 {
            "No"
            }
         }
         return $Answer
} #Get-AskUserYNQuestion -Question 'Are you ready?'
