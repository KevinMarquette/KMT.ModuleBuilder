[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
param($BuildVariables)

$ModuleName = $BuildVariables.ModuleName

Describe "Public commands have comment-based or external help" {
    BeforeAll {
        $functions = Get-Command -Module $ModuleName
        $help = foreach ($function in $functions)
        {
            Get-Help -Name $function.Name
        }
        $testCases = foreach ($node in $help)
        {
            @{
                Name        = $node.name
                Description = $node.Description
                Synopsis    = $node.Synopsis
                Examples    = $node.Examples
            }
        }
    }

    It "<Name> has a Description or Synopsis" -TestCases $testCases -skip:(!$testCases) {
        param($Description, $Synopsis)
        ($Description + $Synopsis) | Should -Not -BeNullOrEmpty
    }

    It "<Name> has an Example" -TestCases $testCases -skip:(!$testCases) {
        param($Name, $Examples)
        $Examples | Should -Not -BeNullOrEmpty
        $Examples | Out-String | Should -Match ($Name)
    }

}

