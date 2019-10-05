Describe 'Function Initialize-KTMModuleProject' -Tag build {

    It 'Does not throw an error' {
        Initialize-KTMModuleProject -ModuleName SampleModule -BuildRoot "$testdrive\SampleModule"
    }
}
