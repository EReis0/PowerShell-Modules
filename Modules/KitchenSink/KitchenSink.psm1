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
    Author: Codeholics - TheBleak
    Version: 1.0
    Date: 8/2023
.LINK
    https://github.com/thebleak13/PowerShell-Samples/blob/main/BleakKitchenSink/README.md
#>
Function Convert-CSVtoHTML {
    Import-Module -Name PSWriteHTML
    $DownloadsPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    $File = Get-CSVFilePath
    $importFile = @(Import-CSV -path $File)
    $FileNameRaw = (Get-ChildItem $file).Name
    $FileName = $FileNameRaw.Replace(".csv",'')
    Write-Host "`n`r ---> Exported report to $DownloadsPath\$FileName.html" -foregroundcolor 'black' -backgroundcolor 'green'
    New-HTML {
        New-HTMLTable -DataTable $importFile -Title $FileName -HideFooter -PagingLength 10 -Buttons excelHtml5,searchPanes
    } -ShowHTML -FilePath "$DownloadsPath\$FileName.html" -Online
} #Convert-CSVtoHTML


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
    Author: Codeholics - TheBleak
    Version: 1.0
    Date: 8/2023
.LINK
    https://github.com/thebleak13/PowerShell-Samples/blob/main/BleakKitchenSink/README.md
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
    Author: Codeholics - TheBleak
    Version: 1.0
    Date: 8/2023
.LINK
    https://github.com/thebleak13/PowerShell-Samples/blob/main/BleakKitchenSink/README.md
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
    Author: Codeholics - TheBleak
    Version: 1.0
    Date: 8/2023
.LINK
    https://github.com/thebleak13/PowerShell-Samples/blob/main/BleakKitchenSink/README.md
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
    Installs a custom module from the downloads folder to the module directory.
.DESCRIPTION
    This function installs a custom module from the downloads folder to the module directory. The function copies the module folder from the downloads folder to the module directory, and removes any existing module with the same name. If an Anti-Virus is running, it may flag this script as a virus. You will have to exclude powershell.exe from your AV during the installation.
.PARAMETER InputDir
    Specifies the path of the module to install. This parameter is mandatory.
.PARAMETER UserLevel
    Specifies the level of the user for which the module should be installed. This parameter is optional and can be set to either 'Single' or 'All'. If not specified, the default value is 'All'.
.EXAMPLE
    Install-CustomModule -InputDir "C:\Users\thebl\Downloads\BleakKitchenSink" -UserLevel "All"
    This example installs the "BleakKitchenSink" module from the -InputDir  to the module directory for all users.

    Install-CustomModule -InputDir "C:\Users\thebl\Downloads\BleakKitchenSink" -UserLevel "Single"
    This example installs the "BleakKitchenSink" module from the -InputDir  to the module directory for the current user.
.NOTES
    Author: Team Codeholics - TheBleak13 https://github.com/thebleak13
    Version: 1.0
    Date: 8/2023
    Warning: If you're running an Anti-Virus, it may flag this script as a virus. You will have to exclude powershell.exe from your AV during the installation. Just make sure to remove the AV exception because leaving it in place is very risky.

    You don't really need this script, you can technically just copy the folder and paste it to the module directory 'C:\Program Files\WindowsPowerShell\Modules'. This will also avoid the issues with AV.
    Installing the module is useful but you can also just import-module with the path to use it for a script.
.LINK
    https://github.com/thebleak13/PowerShell-Samples/blob/main/Modules/KitchenSink/README.md
#>
Function Install-CustomModule {
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
        $WindowsPowerShellModulePath = "C:\Program Files\WindowsPowerShell\Modules"
    } else {
        Write-Warning "UserLevel must be 'Single' or 'All'"
    }

    $ModuleOutputPath = "$WindowsPowerShellModulePath\$ModuleName"
    
    Write-Host "This script will install the $ModuleName module to the module directory." -ForegroundColor Black -BackgroundColor white
    Write-Host "Copy module from $InputDir to $WindowsPowerShellModulePath" -ForegroundColor Black -BackgroundColor white
    Write-Host "If you have an Anti-Virus, it may flag this script as a virus. You will have to exclude powershell.exe from your AV during the installation." -ForegroundColor Black -BackgroundColor Yellow

    # Check if the module is already installed
    $filecheck = test-path $ModuleOutputPath
    if ($filecheck) {
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
        New-Item -ItemType File -Path $ProfilePath -Force
    }

    # Check if the Import-Module command already exists in the profile
    $ProfileContent = Get-Content -Path $ProfilePath
    $ImportModuleCommand = "Import-Module -Name $ModuleName"
    $CommandExists = $ProfileContent -like "*$ImportModuleCommand*"

    # If the command does not exist, add it to the profile
    if (-not $CommandExists) {
    Add-Content -Path $ProfilePath -Value "`n$ImportModuleCommand`n"
    }

    Import-Module -Name $ModuleName

    Get-Module -Name $ModuleName
} # Install-CustomModule -InputDir 'C:\Users\thebl\Downloads\BleakKitchenSink' -UserLevel 'All'


<#
.SYNOPSIS
    Creates a single PowerShell module (PSM) file from a folder of functions.
.DESCRIPTION
    This function creates a single PowerShell module (PSM) file from a folder of functions. The resulting PSM file will have the same name as the root folder and will contain all of the functions in the specified folder. Each function definition will be separated by two blank lines.
.PARAMETER RootFolder
    Specifies the root folder path of the module/project.
.PARAMETER FunctionsDir
    Specifies the name of the folder that contains the functions. The default value is "Functions".
.EXAMPLE
    Join-FunctionsToPSM -RootFolder "C:\Github\ProjectSample" -FunctionsDir "Functions"
    This example creates a PSM file with all of the functions in the root folder. The resulting PSM file will have the same name as the root folder.
.NOTES
    Author: Codeholics - TheBleak
    Version: 1.1
    Date: 8/24/2023
#>
function Join-FunctionsToPSM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$RootFolder,

        [Parameter(Mandatory = $false)]
        [string]$FunctionsDir = "Functions"
    )

    $RootFolderName = Get-Item $RootFolder | Select-Object -ExpandProperty Name
    $FunctionFolder = $RootFolder + "\" + $FunctionsDir
    $FullPSMPath = "$RootFolder\$RootFolderName.psm1"

    $Validation_root = Test-Path $RootFolder
    if ($validation_root -eq $false) {
        Write-Error "Root folder does not exist"
        return
    }

    $Validation_Functions = Test-Path $FunctionFolder
    if ($validation_Functions -eq $false) {
        Write-Error "Functions folder does not exist"
        return
    }

    $ResultBuilder = [System.Text.StringBuilder]::new()

    foreach ($File in Get-ChildItem -Path $FunctionFolder -Filter *.ps1 -File) {
        $FileContent = Get-Content $File.FullName -Raw
        $null = $ResultBuilder.AppendLine($FileContent)
        $null = $ResultBuilder.AppendLine()
        $null = $ResultBuilder.AppendLine()
    }

    Set-Content -Value $ResultBuilder.ToString() -Path $FullPSMPath
} # Join-FunctionsToPSM -RootFolder "D:\Code\Repos\PowerShell-Modules\Modules\KitchenSink" -FunctionsDir "Functions"



