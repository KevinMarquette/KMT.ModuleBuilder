

task SetVersion {
    $task = @{
        ManifestPath = (Get-KmtBuildVariable).ManifestPath
        ModuleName = (Get-KmtBuildVariable).ModuleName
        Repository = (Get-KmtBuildVariable).Repository
    }

    Update-KmtSemVerTask -Verbose @task

    # This cleans up files from previous implementation
    $BuildRoot = (Get-KmtBuildVariable).BuildRoot
    if(Test-Path $BuildRoot\fingerprint)
    {
        Remove-Item $BuildRoot\fingerprint
    }
}
