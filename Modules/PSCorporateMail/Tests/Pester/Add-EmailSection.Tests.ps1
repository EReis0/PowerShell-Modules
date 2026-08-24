# Add-EmailSection.Tests.ps1

Import-Module "C:\Code\PowerShell-Modules\Modules\PSCorporateMail\PSCorporateMail.psm1"

Describe 'Add-EmailSection' {

    Context 'When adding a section component' {

        It 'Returns a document object' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Result = $Mail |
                Add-EmailSection `
                    -Title 'Summary' `
                    -Body 'This is a test.'

            ($Result.PSTypeNames -contains 'PSCorporateMail.Document') |
                Should Be $true
        }

        It 'Adds a component to the document' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailSection `
                    -Title 'Summary' `
                    -Body 'This is a test.'

            $Mail.Components.Count |
                Should Be 1
        }

        It 'Creates a Section component' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailSection `
                    -Title 'Summary' `
                    -Body 'This is a test.'

            $Mail.Components[0].Type |
                Should Be 'Section'
        }

        It 'Stores the title' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailSection `
                    -Title 'Summary' `
                    -Body 'This is a test.'

            $Mail.Components[0].Properties.Title |
                Should Be 'Summary'
        }

        It 'Stores the body' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailSection `
                    -Title 'Summary' `
                    -Body 'This is a test.'

            $Mail.Components[0].Properties.Body |
                Should Be 'This is a test.'
        }

        It 'Creates a component metadata object' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailSection `
                    -Title 'Summary' `
                    -Body 'This is a test.'

            ($Mail.Components[0].Metadata -ne $null) |
                Should Be $true
        }

        It 'Creates a component Id' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailSection `
                    -Title 'Summary' `
                    -Body 'This is a test.'

            $Mail.Components[0].Id |
                Should Not BeNullOrEmpty
        }

        It 'Creates a component type name' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailSection `
                    -Title 'Summary' `
                    -Body 'This is a test.'

            ($Mail.Components[0].PSTypeNames -contains 'PSCorporateMail.Component.Section') |
                Should Be $true
        }

        It 'Creates a PSCustomObject properties object' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailSection `
                    -Title 'Summary' `
                    -Body 'This is a test.'

            $Mail.Components[0].Properties.GetType().Name |
                Should Be 'PSCustomObject'
        }
    }

    Context 'When multiple sections are added' {

        It 'Adds both components to the document' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailSection `
                    -Title 'Section 1' `
                    -Body 'Body 1'

            $Mail = $Mail |
                Add-EmailSection `
                    -Title 'Section 2' `
                    -Body 'Body 2'

            $Mail.Components.Count |
                Should Be 2
        }

        It 'Maintains component order' {

            $Mail = New-EmailDocument `
                -Title 'Test Email'

            $Mail = $Mail |
                Add-EmailSection `
                    -Title 'Section 1' `
                    -Body 'Body 1'

            $Mail = $Mail |
                Add-EmailSection `
                    -Title 'Section 2' `
                    -Body 'Body 2'

            $Mail.Components[0].Properties.Title |
                Should Be 'Section 1'

            $Mail.Components[1].Properties.Title |
                Should Be 'Section 2'
        }
    }
}