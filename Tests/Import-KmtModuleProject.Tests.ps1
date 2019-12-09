Describe 'Function Import-KmtModuleProject' -Tag build {
    It 'Should Import a module' {
        Get-Module SampleModule | Remove-Module
        Import-KmtModuleProject $PSScriptRoot\Data\ReferenceOutput\SampleModule -Verbose
        Get-Module SampleModule | Should -Not -BeNullOrEmpty
    }
}
