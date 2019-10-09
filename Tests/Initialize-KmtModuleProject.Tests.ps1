Describe 'Function Initialize-KmtModuleProject' -Tag build {

    It -skip 'Does not throw an error' {
        Initialize-KmtModuleProject -Path "$testdrive\SampleModule"
    }
}
