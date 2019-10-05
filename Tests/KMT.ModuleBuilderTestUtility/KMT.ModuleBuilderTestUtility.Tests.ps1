Import-Module $PSScriptRoot
Describe 'Module KMT.ModuleBuilderTestUtility' {

    Context "Function Assert-Psm1Equality" {

        BeforeEach {
            $date = Get-Date
            $source = "TestDrive:\Source.psm1"
            $reference = "TestDrive:\Reference.psm1"
            $date | Set-Content -Path $source
            $date | Set-Content -Path $reference
        }

        It "compares two equal module files" {
            $source | Assert-Psm1Equality $reference
        }

        It "compares two different module files" {
            "OTHER_DATA" | Set-Content -Path $source
            {$source | Assert-Psm1Equality $reference} | Should -Throw
        }
    }
}
