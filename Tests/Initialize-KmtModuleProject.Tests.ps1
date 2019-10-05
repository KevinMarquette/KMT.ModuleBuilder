Describe 'Function Initialize-KmtModuleProject' -Tag build {

    It 'Does not throw an error' {
        Initialize-KmtModuleProject -ModuleName SampleModule -BuildRoot "$testdrive\SampleModule"
    }
}
