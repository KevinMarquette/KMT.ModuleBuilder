param($BuildVariables)

$ModuleName = $BuildVariables.ModuleName

Describe "Public commands have comment-based or external help" {
    $functions = Get-Command -Module $ModuleName
    $help = foreach ($function in $functions) {
        Get-Help -Name $function.Name
    }

    foreach ($node in $help)
    {
        Context $node.Name {
            It "Should have a Description or Synopsis" {
                ($node.Description + $node.Synopsis) | Should Not BeNullOrEmpty
            }

            It "Should have an Example"  {
                $node.Examples | Should Not BeNullOrEmpty
                $node.Examples | Out-String | Should -Match ($node.Name)
            }

            foreach ($parameter in $node.Parameters.Parameter)
            {
                if ($parameter -notmatch 'WhatIf|Confirm')
                {
                    It "Should have a Description for Parameter [$($parameter.Name)]" {
                        $parameter.Description.Text | Should Not BeNullOrEmpty
                    }
                }
            }
        }
    }
}

