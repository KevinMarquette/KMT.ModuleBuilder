param($BuildVariables)

$ModuleRoot = $BuildVariables.BuildRoot
$ModuleName = $BuildVariables.ModuleName

Describe "Public commands are tested"  {
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
        $testCases = $null -ne $testCases ? $testCases : $null
    }

    It "[<Name>] has a test" -TestCases $testCases -skip:($null -eq $testCases) {
        param($Name, $Count)
        $Count | Should -BeGreaterThan 0
    }
}
