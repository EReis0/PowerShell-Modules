#requires -Module 'PSWriteHTML'

#Importing required modules
Import-module -Name 'PSWriteHTML'

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

Function Get-FileName($initialDirectory){  
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.Filter = "CSV UTF-8 (Comma Delimited) (*.csv)| *.csv"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}

function Convert-CSVtoHTML {
    [CmdletBinding()]
    $DownloadsPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    $File = Get-FileName
    $importFile = @(Import-CSV -path $File)
    $FileNameRaw = (Get-ChildItem $file).Name
    $FileName = $FileNameRaw.Replace(".csv",'')
    write-host "`n`r ---> Exported report to $DownloadsPath\$FileName.html" -foregroundcolor 'black' -backgroundcolor 'green'
    New-HTML {
        New-HTMLTable -DataTable $importFile -Title $FileName -HideFooter -PagingLength 10 -Buttons excelHtml5,searchPanes
    } -ShowHTML -FilePath "$DownloadsPath\$FileName.html" -Online
} #Convert-CSVtoHTML