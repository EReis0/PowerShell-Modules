<#
.SYNOPSIS
Sends an HTML email using dynamic templates and variable substitution.

.DESCRIPTION
Send-OutEmail reads HTML template files for success and failure scenarios, replaces placeholders (e.g., /$VariableName) with values from the caller's scope, and sends the email using the specified SMTP server. Subjects and other parameters can also use template placeholders, making the function ideal for automation and notification tasks where email content needs to be dynamic and reusable.

.PARAMETER SmtpServer
The SMTP server to use for sending the email.

.PARAMETER To
The recipient email address.

.PARAMETER From
The sender email address.

.PARAMETER BCC
(Optional) BCC recipient(s).

.PARAMETER Cc
(Optional) CC recipient(s).

.PARAMETER LogPath
(Optional) Path to a log file for logging email activity.

.PARAMETER ErrorMsg
(Optional) If set, the failure template is used; otherwise, the success template is used.

.PARAMETER ErrorSubject
The subject line for failure emails. Can include template placeholders (e.g., /$Email).

.PARAMETER SuccessSubject
The subject line for success emails. Can include template placeholders (e.g., /$Email).

.PARAMETER SuccessBodyPath
Path to the HTML template for success emails.

.PARAMETER FailBodyPath
Path to the HTML template for failure emails.

.EXAMPLE
$SendOutEmailParams = @{
    SmtpServer      = "smtp.ld.corp.local"
    To              = "user@example.com"
    From            = "Automation <auto@example.com>"
    BCC             = "admin@example.com"
    Cc              = "manager@example.com"
    LogPath         = "C:\Logs\mail.log"
    ErrorMsg        = $null
    ErrorSubject    = "Failure - /$Email"
    SuccessSubject  = "Success - /$Email"
    SuccessBodyPath = "C:\Path\SuccessBody.html"
    FailBodyPath    = "C:\Path\FailBody.html"
}

# Success scenario
Send-OutEmail @SendOutEmailParams

# Failure scenario
$ErrorMsg = "An error occurred"
Send-OutEmail @SendOutEmailParams

.NOTES
- All variables referenced in your templates or subjects (e.g., $Email, $Alias, $ErrorMsg) must be defined in your script before calling Send-OutEmail.
- Placeholders in templates and subjects must use the format /$VariableName.
- If $ErrorMsg is $null, the success template is used; otherwise, the failure template is used.
- You can store subject templates in a JSON config and resolve them with Resolve-TemplateVars before passing to this function.
#>
function Send-OutEmail {
    param(
        [Parameter(Mandatory)]
            [string]$SmtpServer,
        [Parameter(Mandatory)]
            [string]$To,
        [Parameter(Mandatory)]
            [string]$From,
        [string]$BCC = $null,
        [string]$Cc = $null,
        [string]$LogPath = $null,
        [string]$Attachments = $null,
        [Parameter(Mandatory)]
            [string]$ErrorSubject,
        [Parameter(Mandatory)] 
            [string]$SuccessSubject,
        $ErrorMsg = $null,
        [Parameter(Mandatory)]
            [string]$SuccessBodyPath,
        [Parameter(Mandatory)]
            [string]$FailBodyPath
    )

    # Read HTML templates
    $SuccessBody = Get-Content $SuccessBodyPath -Raw
    $FailBody = Get-Content $FailBodyPath -Raw

    if ($null -eq $ErrorMsg) {
        $Subject = $SuccessSubject
        $Body = Resolve-TemplateVars $SuccessBody
    } else {
        $Subject = $ErrorSubject
        $Body = Resolve-TemplateVars $FailBody
    }

    $Params = @{
        SmtpServer  = $SmtpServer
        To          = $To
        From        = $From
        Subject     = $Subject
        Body        = $Body
        BodyAsHtml  = $true
        ErrorAction = "SilentlyContinue"
    }
    if ($BCC) { $Params.Bcc = $BCC }
    if ($Cc) { $Params.Cc = $Cc }
    if ($Attachments) { $Params.Attachments = $Attachments }

    try {
        Send-MailMessage @Params
        if ($LogPath) { Write-LogInfo -LogPath $LogPath -Message "[$(Get-Date)] Sent the email" -ToScreen }
    } catch {
        if ($LogPath) { Write-LogError -LogPath $LogPath -Message "[$(Get-Date)] Failed to send the email : $($_.Exception.Message)" -ToScreen }
        Exit 1
    }
}
