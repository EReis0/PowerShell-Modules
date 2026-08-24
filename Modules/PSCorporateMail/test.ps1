$PSCorporateMail = 'C:\Code\PowerShell-Modules\Modules\PSCorporateMail\PSCorporateMail.psm1'
Unblock-File $PSCorporateMail
Import-Module $PSCorporateMail


$Mail = New-EmailDocument `
    -Title 'Termination SafeGuard'

$Mail |
    Add-EmailHero `
        -Title 'Daily Compliance Review' `
        -Severity Warning

$Mail |
    Add-EmailSection `
        -Title 'Summary' `
        -Body 'One account requires review.'

$Mail |
    Add-EmailButton `
        -Text 'Open ServiceNow' `
        -Url 'https://instance.service-now.com'

$Mail.Components | Format-List *