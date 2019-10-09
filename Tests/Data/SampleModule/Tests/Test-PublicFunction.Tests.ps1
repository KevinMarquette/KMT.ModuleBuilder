Describe 'Function Test-PublicFunction' -Tag build {
    It 'Should not throw' {
        Test-PublicFunction -Path $PWD
    }
}
