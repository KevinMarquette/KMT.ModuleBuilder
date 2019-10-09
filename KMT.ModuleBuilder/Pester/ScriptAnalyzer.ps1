[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
param($BuildVariables)

$ModuleRoot = $BuildVariables.BuildRoot
$SourceRoot = $BuildVariables.Source

Describe "All commands pass PSScriptAnalyzer rules" {
    BeforeAll {
        $rules = "$ModuleRoot\ScriptAnalyzerSettings.psd1"
        $scripts = Get-ChildItem -Path $SourceRoot -Include '*.ps1', '*.psm1', '*.psd1' -Recurse |
            Where-Object FullName -notmatch 'Classes'

        $testCases = foreach ($script in $scripts)
        {
            $results = Invoke-ScriptAnalyzer -Path $script.FullName -Settings $rules -Verbose:$false

            foreach ($rule in $results)
            {
                @{
                    Path     = $script.FullName
                    Rule     = $rule.RuleName
                    Severity = $rule.Severity
                    Line     = $rule.Line
                    Message  = $rule.Message

                }
            }
        }
    }

    it "[<rule>] <path>" -TestCases $testCases -Skip:(!$testCases) {
        param($Severity,$Line,$Message)
        $because = "{0} {1} {2}" -f $Severity,$Line,$Message
        $Message | Should -BeNullOrEmpty -Because $because
    }
}
