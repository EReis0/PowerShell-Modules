function Get-Theme {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet(
            'ServiceDesk',
            'Automation',
            'Compliance',
            'Executive'
        )]
        [string]$Name
    )

    switch ($Name) {

        'ServiceDesk' {

            [PSCustomObject]@{
                Name            = 'ServiceDesk'

                FontFamily      = 'Segoe UI'

                PrimaryColor    = '#0078D4'
                AccentColor     = '#005A9E'

                BackgroundColor = '#FFFFFF'
                TextColor       = '#323130'
                BorderColor     = '#E1DFDD'

                HeroBackground  = '#0078D4'
                HeroText        = '#FFFFFF'

                ButtonBackground = '#0078D4'
                ButtonText       = '#FFFFFF'

                FooterText      = '#605E5C'

                SeverityColors  = [PSCustomObject]@{
                    Info     = '#0078D4'
                    Success  = '#107C10'
                    Warning  = '#FFB900'
                    Critical = '#D13438'
                }
            }
        }

        'Automation' {

            [PSCustomObject]@{
                Name            = 'Automation'

                FontFamily      = 'Segoe UI'

                PrimaryColor    = '#003A70'
                AccentColor     = '#0078D4'

                BackgroundColor = '#FFFFFF'
                TextColor       = '#323130'
                BorderColor     = '#E1DFDD'

                HeroBackground  = '#003A70'
                HeroText        = '#FFFFFF'

                ButtonBackground = '#0078D4'
                ButtonText       = '#FFFFFF'

                FooterText      = '#605E5C'

                SeverityColors  = [PSCustomObject]@{
                    Info     = '#0078D4'
                    Success  = '#107C10'
                    Warning  = '#FFB900'
                    Critical = '#D13438'
                }
            }
        }

        'Compliance' {

            [PSCustomObject]@{
                Name            = 'Compliance'

                FontFamily      = 'Segoe UI'

                PrimaryColor    = '#107C10'
                AccentColor     = '#5E9732'

                BackgroundColor = '#FFFFFF'
                TextColor       = '#323130'
                BorderColor     = '#E1DFDD'

                HeroBackground  = '#107C10'
                HeroText        = '#FFFFFF'

                ButtonBackground = '#107C10'
                ButtonText       = '#FFFFFF'

                FooterText      = '#605E5C'

                SeverityColors  = [PSCustomObject]@{
                    Info     = '#0078D4'
                    Success  = '#107C10'
                    Warning  = '#FFB900'
                    Critical = '#D13438'
                }
            }
        }

        'Executive' {

            [PSCustomObject]@{
                Name            = 'Executive'

                FontFamily      = 'Segoe UI'

                PrimaryColor    = '#323130'
                AccentColor     = '#605E5C'

                BackgroundColor = '#FFFFFF'
                TextColor       = '#323130'
                BorderColor     = '#E1DFDD'

                HeroBackground  = '#323130'
                HeroText        = '#FFFFFF'

                ButtonBackground = '#323130'
                ButtonText       = '#FFFFFF'

                FooterText      = '#605E5C'

                SeverityColors  = [PSCustomObject]@{
                    Info     = '#0078D4'
                    Success  = '#107C10'
                    Warning  = '#FFB900'
                    Critical = '#D13438'
                }
            }
        }
    }
}