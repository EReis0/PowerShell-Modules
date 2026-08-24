# Test-EmailDocument.Tests.ps1

Import-Module "C:\Code\PowerShell-Modules\Modules\PSCorporateMail\PSCorporateMail.psm1"

Describe 'Test-EmailDocument' {

    Context 'When provided a valid document' {

        It 'Returns true' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            Test-EmailDocument `
                -Document $Document |
                Should Be $true
        }
    }

    Context 'When the document type name is missing' {

        It 'Returns false' {

            $Document = [PSCustomObject]@{
                Metadata = [PSCustomObject]@{
                    Title       = 'Test'
                    Template    = 'ServiceDesk'
                    CreatedDate = Get-Date
                    Version     = '1.0.0'
                }

                Components = New-Object System.Collections.Generic.List[object]
            }

            Test-EmailDocument `
                -Document $Document |
                Should Be $false
        }
    }

    Context 'When Metadata is missing' {

        It 'Returns false' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            $Document.PSObject.Properties.Remove('Metadata')

            Test-EmailDocument `
                -Document $Document |
                Should Be $false
        }
    }

    Context 'When Components is missing' {

        It 'Returns false' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            $Document.PSObject.Properties.Remove('Components')

            Test-EmailDocument `
                -Document $Document |
                Should Be $false
        }
    }

    Context 'When Metadata.Title is missing' {

        It 'Returns false' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            $Document.Metadata.PSObject.Properties.Remove('Title')

            Test-EmailDocument `
                -Document $Document |
                Should Be $false
        }
    }

    Context 'When Metadata.Template is missing' {

        It 'Returns false' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            $Document.Metadata.PSObject.Properties.Remove('Template')

            Test-EmailDocument `
                -Document $Document |
                Should Be $false
        }
    }

    Context 'When Metadata.CreatedDate is missing' {

        It 'Returns false' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            $Document.Metadata.PSObject.Properties.Remove('CreatedDate')

            Test-EmailDocument `
                -Document $Document |
                Should Be $false
        }
    }

    Context 'When Metadata.Version is missing' {

        It 'Returns false' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            $Document.Metadata.PSObject.Properties.Remove('Version')

            Test-EmailDocument `
                -Document $Document |
                Should Be $false
        }
    }

    Context 'When Components is null' {

        It 'Returns false' {

            $Document = New-EmailDocument `
                -Title 'Test Email'

            $Document.Components = $null

            Test-EmailDocument `
                -Document $Document |
                Should Be $false
        }
    }
}