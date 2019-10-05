Describe 'Baseline Functionality' -tag baseline {

    BeforeAll {
        $referenceFolder = "$PSScriptRoot/Data/ReferenceOutput/SampleModule"
        $destinationFolder = "TestDrive:/SampleModule/Output/SampleModule"
        Copy-Item $PSScriptRoot/Data/SampleModule TestDrive: -Recurse
        Push-Location "TestDrive:/SampleModule"
        Invoke-Build Clean,Default
    }

    $createdItems = @(
        @{name="Output folder"; path="TestDrive:/SampleModule/Output"}
        @{name="Download version file"; path="TestDrive:/SampleModule/Output/downloads/versionfile"}
        @{name="PSM1 file"; path="$destinationFolder/SampleModule.psm1"}
        @{name="PSD1 file"; path="$destinationFolder/SampleModule.psd1"}
        @{name="LICENSE file"; path="$destinationFolder/LICENSE"}
        @{name="Help file"; path="$destinationFolder/en-US/SampleModule-help.xml"}
    )

    It 'Creates the <name>' -TestCases $createdItems {
        param($Path)
        $Path | Should -Exist
    }

    $validateContents = @(
        @{name="PSD1 file"; fileName="SampleModule.psd1"}
        @{name="PSM1 file"; fileName="SampleModule.psm1"}
    )

    It 'Validates the <name> contents' -TestCases $validateContents {
        param($fileName)
        $referencePath = Join-Path $referenceFolder $fileName
        $referenceData = Get-Content -Path $referencePath | Where {$_ -notmatch '^#'}

        $destinationPath = Join-Path $destinationFolder $fileName
        $destinationData = Get-Content -Path $destinationPath | Where {$_ -notmatch '^#'}

        $destinationData | Should -BeExactly $referenceData
    }

    AfterAll {
        Pop-Location
    }
}
