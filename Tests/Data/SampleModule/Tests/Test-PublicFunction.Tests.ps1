Describe 'Function Test-PublicFunction' -Tag Build {
    It 'Should not throw' -Skip {
        Test-PublicFunction -Path $PWD
    }
}
