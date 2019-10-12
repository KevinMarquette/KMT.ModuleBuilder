using namespace System.IO
Describe 'Function Get-KmtBuildVariable' -tag build {

    BeforeAll {
        $path = "$testdrive/SampleModule"
        New-Item -Type Directory $path -ErrorAction Ignore
        Copy-Item "$PSScriptRoot/Data/SampleModule/module.kmt.json" -Destination $path
        Initialize-KmtModuleProject -Path $Path
        $data = Get-KmtBuildVariable
    }

    $testCases = @(
        @{name='ModuleName'; value="SampleModule"}
        @{name='BuildRoot'; value=[path]::Join($testdrive,"SampleModule")}
        @{name='DocsPath'; value=[path]::Join($testdrive,'SampleModule','Docs')}
        @{name='Output'; value=[path]::Join($testdrive,'SampleModule','Output')}
        @{name='Source'; value=[path]::Join($testdrive,'SampleModule','SampleModule')}
        @{name='Destination'; value=[path]::Join($testdrive,'SampleModule','Output','SampleModule')}
        @{name='ManifestPath'; value=[path]::Join($testdrive,'SampleModule','Output','SampleModule','SampleModule.psd1')}
        @{name='ModulePath'; value=[path]::Join($testdrive,'SampleModule','Output','SampleModule','SampleModule.psm1')}
        @{name='Folders'; value=@('Classes','Includes','Internal','Private','Public','Resources')}
        @{name='TestFile'; value=[path]::Join($testdrive,'SampleModule','Output','TestResults_PS_.xml')}
        @{name='PSRepository'; value="PSGallery"}
    )
    It 'Init data has [<name>] property' -TestCases $testCases {
        param($name)
        $data.ContainsKey($name) | Should -BeTrue
    }
    It '[<name>] property has correct value' -TestCases $testCases {
        param($name, $value)
        $data.$name | Should -Be $value
    }
}
