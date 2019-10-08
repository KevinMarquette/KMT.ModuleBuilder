task ImportModule {
    $path = (Get-KmtBuildVariable).ManifestPath
    Import-KmtModule -Path $path -Force
}
