# New-EmailDocument.Tests.ps1

Import-Module "C:\Code\PowerShell-Modules\Modules\PSCorporateMail\PSCorporateMail.psm1"

# New-EmailDocument.Tests.ps1

Describe 'New-EmailDocument' {

    Context 'When creating a document with required parameters' {

        It 'Creates a PSCorporateMail document object' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            ($Document.PSTypeNames -contains 'PSCorporateMail.Document') |
                Should Be $true
        }

        It 'Sets the title correctly' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            $Document.Metadata.Title |
                Should Be 'Test Email'
        }

        It 'Uses ServiceDesk as the default template' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            $Document.Metadata.Template |
                Should Be 'ServiceDesk'
        }

        It 'Creates a metadata property' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            ($Document.PSObject.Properties['Metadata'] -ne $null) |
                Should Be $true
        }

        It 'Creates a components property' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            ($Document.PSObject.Properties['Components'] -ne $null) |
                Should Be $true
        }

        It 'Creates an empty components collection' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            $Document.Components.Count |
                Should Be 0
        }

        It 'Creates a Generic List for components' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            $Document.Components.GetType().FullName |
                Should Be 'System.Collections.Generic.List`1[[System.Object, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089]]'
        }
    }

    Context 'When optional parameters are supplied' {

        It 'Sets the subtitle correctly' {

            $Document = New-EmailDocument `
                -Title 'Test Email' `
                -Subtitle 'Daily Report'

            $Document.Metadata.Subtitle |
                Should Be 'Daily Report'
        }

        It 'Sets the specified template' {

            $Document = New-EmailDocument `
                -Title 'Test Email' `
                -Template Automation

            $Document.Metadata.Template |
                Should Be 'Automation'
        }
    }

    Context 'Metadata validation' {

        It 'Sets CreatedDate' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            $Document.Metadata.CreatedDate |
                Should Not BeNullOrEmpty
        }

        It 'Sets Version' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            $Document.Metadata.Version |
                Should Be '1.0.0'
        }
    }
}