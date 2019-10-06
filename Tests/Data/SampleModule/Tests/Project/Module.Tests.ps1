$Script:ModuleRoot = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$Script:ModuleName = $Script:ModuleName = Get-ChildItem $ModuleRoot\*\*.psm1 | Select-object -ExpandProperty BaseName

$Script:SourceRoot = Join-Path -Path $ModuleRoot -ChildPath $ModuleName

Describe "All commands pass PSScriptAnalyzer rules" -Tag 'Build' {
    $rules = "$ModuleRoot\ScriptAnalyzerSettings.psd1"
    $scripts = Get-ChildItem -Path $SourceRoot -Include '*.ps1', '*.psm1', '*.psd1' -Recurse |
        Where-Object FullName -notmatch 'Classes'

    foreach ($script in $scripts)
    {
        Context $script.FullName {
            $results = Invoke-ScriptAnalyzer -Path $script.FullName -Settings $rules
            if ($results)
            {
                foreach ($rule in $results)
                {
                    It $rule.RuleName {
                        $message = "{0} Line {1}: {2}" -f $rule.Severity, $rule.Line, $rule.Message
                        $message | Should Be ""
                    }
                }
            }
            else
            {
                It "Should not fail any rules" {
                    $results | Should BeNullOrEmpty
                }
            }
        }
    }
}

Describe "Public commands are used in tests" -Tag 'Build' {
    BeforeAll {
        $commandNames = Get-Command -Module $ModuleName | Select-Object -ExpandProperty Name
        $commandResults = @{}
        $commandNames | ForEach-Object {$commandResults[$_] = 0}

        $testFiles = Get-ChildItem -Path "$ModuleRoot\Tests" -Include "*.Tests.ps1" -Recurse

        # search every test file for command calls
        foreach ($file in $testFiles)
        {
            $content = Get-Content -Path $file.FullName -Raw
            foreach ($command in $commandNames)
            {
                $pattern = '\b{0}\b' -f $command
                if ($content -match $pattern)
                {
                    $commandResults[$command] += 1
                }
            }
        }

        # create testcases from results of command search
        $testCases = foreach($key in $commandResults.Keys)
        {
            @{
                Name = $key
                Count = $commandResults[$key]
            }
        }
    }

    It "[<Name>] has a test" -TestCases $testCases {
        param($Count)
        $Count | Should -BeGreaterThan 0
    }
}
