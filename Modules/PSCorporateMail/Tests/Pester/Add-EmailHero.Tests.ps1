# Add-EmailHero.Tests.ps1

Describe 'Add-EmailHero' {

    Context 'When adding a hero component' {

        It 'Returns a document object' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Result = $Mail |
                Add-EmailHero `
                    -Title 'Termination SafeGuard'

            ($Result.PSTypeNames -contains 'PSCorporateMail.Document') |
                Should Be $true
        }

        It 'Adds a component to the document' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailHero `
                    -Title 'Termination SafeGuard'

            $Mail.Components.Count |
                Should Be 1
        }

        It 'Creates a Hero component' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailHero `
                    -Title 'Termination SafeGuard'

            $Mail.Components[0].Type |
                Should Be 'Hero'
        }

        It 'Stores the title' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailHero `
                    -Title 'Termination SafeGuard'

            $Mail.Components[0].Properties.Title |
                Should Be 'Termination SafeGuard'
        }

        It 'Stores the subtitle' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailHero `
                    -Title 'Termination SafeGuard' `
                    -Subtitle 'Daily Compliance Review'

            $Mail.Components[0].Properties.Subtitle |
                Should Be 'Daily Compliance Review'
        }

        It 'Uses Default severity when not specified' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailHero `
                    -Title 'Termination SafeGuard'

            $Mail.Components[0].Properties.Severity |
                Should Be 'Default'
        }

        It 'Stores the specified severity' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailHero `
                    -Title 'Termination SafeGuard' `
                    -Severity Warning

            $Mail.Components[0].Properties.Severity |
                Should Be 'Warning'
        }

        It 'Creates a component metadata object' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailHero `
                    -Title 'Termination SafeGuard'

            ($Mail.Components[0].Metadata -ne $null) |
                Should Be $true
        }

        It 'Creates a component Id' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailHero `
                    -Title 'Termination SafeGuard'

            $Mail.Components[0].Id |
                Should Not BeNullOrEmpty
        }

        It 'Creates a component type name' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailHero `
                    -Title 'Termination SafeGuard'

            ($Mail.Components[0].PSTypeNames -contains 'PSCorporateMail.Component.Hero') |
                Should Be $true
        }

        It 'Creates a PSCustomObject properties object' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailHero `
                    -Title 'Termination SafeGuard'

            $Mail.Components[0].Properties.GetType().Name |
                Should Be 'PSCustomObject'
        }
    }

    Context 'When multiple hero components are added' {

        It 'Adds both components to the document' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailHero `
                    -Title 'Hero 1'

            $Mail = $Mail |
                Add-EmailHero `
                    -Title 'Hero 2'

            $Mail.Components.Count |
                Should Be 2
        }

        It 'Maintains component order' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailHero `
                    -Title 'Hero 1'

            $Mail = $Mail |
                Add-EmailHero `
                    -Title 'Hero 2'

            $Mail.Components[0].Properties.Title |
                Should Be 'Hero 1'

            $Mail.Components[1].Properties.Title |
                Should Be 'Hero 2'
        }
    }
}