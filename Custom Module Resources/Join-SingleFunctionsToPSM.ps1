Function Join-SingleFunctionsToPSM {
    <#
    .SYNOPSIS
        Create a single PSM file from a folder of functions.
    .DESCRIPTION
        Create a single PSM file from a folder of functions.
    .NOTES
        There are 2 ways I found to do this. The first method is to include dot sources to the functions in the psm. 
        This method, is best because it adds all the functions into a single psm file.
        Only thing I don't like is no spaces between the functions.
    .LINK
        N/A
    .EXAMPLE
        Join-SingleFunctionsToPSM -RootFolder "C:\Github\ProjectSample" -FunctionFolderName "Functions"
        This will create a psm file with all of the functions in the root folder (PSM file will have same name as root folder)
            -RootFolder: The root folder path of the Module/Project
            -FunctionFolderName: The name of the folder that contains the functions (default is "Functions")
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$RootFolder,
        [Parameter(Mandatory=$false)]
        $FunctionFolderName = "Functions"
    )

    $RootFolderName = Get-Item $RootFolder | select -ExpandProperty Name
    $FunctionFolder = $RootFolder + "\" + $FunctionFolderName
    $FullPSMPath = "$RootFolder\$RootFolderName.psm1"

    $ResultBuilder = [System.Text.StringBuilder]::new()
    $Tokens = $null
    $Errors = $null

    foreach ($File in Get-ChildItem -Path $FunctionFolder -Filter *.ps1 -File)
    {
        $ScriptAst = [System.Management.Automation.Language.Parser]::ParseFile($File.FullName, [ref]$Tokens, [ref]$Errors)
        $FoundFunctions = $ScriptAst.FindAll({
            param ($ast)
            $ast -is [System.Management.Automation.Language.FunctionDefinitionAst]
        }, <#SearchNestedScriptBlocks:#> $true)

        foreach ($Function in $FoundFunctions)
        {
            # You may want to do additional work here like traversing back up the tree to find the help comment
            # Or filter out nested functions so they don't appear twice in the final script file
            $null = $ResultBuilder.AppendLine($Function.Extent.Text)
        }
    }
    Set-Content -Value $ResultBuilder.ToString() -Path $FullPSMPath
}