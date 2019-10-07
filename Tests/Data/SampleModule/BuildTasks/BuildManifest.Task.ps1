
taskx BuildManifest @{
    Inputs  = (Get-ChildItem -Path (Get-KmtBuildVariable).Source -Recurse -File)
    Outputs = (Get-KmtBuildVariable).ManifestPath
    Jobs    = {
        Invoke-KmtBuildManifestTask
    }
}
