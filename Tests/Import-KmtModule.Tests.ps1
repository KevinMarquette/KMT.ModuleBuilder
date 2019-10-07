Describe 'Function Import-KmtModule' -Tag build {
    It 'Should Import a module' {
        Get-Module SampleModule | Remove-Module
        Import-KmtModule $PSScriptRoot\Data\ReferenceOutput\SampleModule -Verbose
        Get-Module SampleModule | Should -Not -BeNullOrEmpty
    }
}
