param($BuildVariables)

$ModuleRoot = $BuildVariables.BuildRoot
$SourceRoot = $BuildVariables.Source

Describe "All commands pass PSScriptAnalyzer rules"  {
    $rules = "$ModuleRoot\ScriptAnalyzerSettings.psd1"
    $scripts = Get-ChildItem -Path $SourceRoot -Include '*.ps1', '*.psm1', '*.psd1' -Recurse |
        Where-Object FullName -notmatch 'Classes'

    foreach ($script in $scripts)
    {
        Context $script.FullName {
            $results = Invoke-ScriptAnalyzer -Path $script.FullName -Settings $rules -Verbose:$false
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
