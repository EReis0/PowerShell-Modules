<#
.SYNOPSIS
Replaces template placeholders with variable values.

.DESCRIPTION
Resolve-TemplateVars scans a string for placeholders in the format /$VariableName and replaces each with the value
of the corresponding variable from the caller's scope. This enables dynamic HTML or text template rendering in scripts, such as for email bodies.

.PARAMETER Template
The string containing placeholders (e.g., /$VariableName) to be resolved.

.OUTPUTS
String. The template with all placeholders replaced by their corresponding variable values.

.EXAMPLE
/$SamAccountName will be replaced with the value of $SamAccountName

.EXAMPLE
$Template = "Hello /$User, your ID is /$UserID."
$User = "Alice"
$UserID = 123
$Result = Resolve-TemplateVars $Template
# $Result will be: "Hello Alice, your ID is 123."

.NOTES
- Placeholders must use the format /$VariableName.
- If a variable is not defined, the placeholder is left unchanged.
#>
function Resolve-TemplateVars {
    param([string]$Template)
    return [regex]::Replace($Template, '\/\$(\w+)', {
        param($match)
        $varName = $match.Groups[1].Value
        try {
            (Get-Variable -Name $varName -ErrorAction Stop).Value
        } catch {
            $match.Value
        }
    })
}