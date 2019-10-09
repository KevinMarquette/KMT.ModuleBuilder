Describe 'Function Build-KmtModuleTask' -tag build {
    Import-Module $PSScriptRoot\KMT.ModuleBuilderTestUtility -DisableNameChecking -Force

    $testCases = @(
        @{
            name='SimpleModule';
            source="$PSScriptRoot/Data/SampleModule/SampleModule";
            reference="$PSScriptRoot/Data/ReferenceOutput/SampleModule/SampleModule.psm1"
        }
    )
    It -skip 'Builds <Name> module' -TestCases $testCases {
        param($Name,$Source,$reference)

        $task = @{
            SourcePath = $source
            OutputFileName = Join-Path "TestDrive:" "$Name.psm1"
        }
        Build-KmtModuleTask @task

        $task.OutputFileName | Assert-Psm1Equality $reference
    }
}
