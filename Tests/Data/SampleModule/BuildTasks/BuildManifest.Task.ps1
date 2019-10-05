
taskx BuildManifest @{
    Inputs  = (Get-ChildItem -Path (Get-KmtBuildVariable).Source -Recurse -File)
    Outputs = (Get-KmtBuildVariable).ManifestPath
    Jobs    = {
        $ManifestPath = (Get-KmtBuildVariable).ManifestPath
        $ModuleName = (Get-KmtBuildVariable).ModuleName
        $Source = (Get-KmtBuildVariable).Source

        "Updating [$ManifestPath]..."
        Copy-Item -Path "$Source\$ModuleName.psd1" -Destination $ManifestPath

        $functions = Get-ChildItem -Path "$ModuleName\Public" -Recurse -Filter *.ps1 -ErrorAction 'Ignore' |
            Where-Object 'Name' -notmatch 'Tests'

        if ($functions)
        {
            'Setting FunctionsToExport...'
            Set-ModuleFunctions -Name $ManifestPath -FunctionsToExport $functions.BaseName
        }
    }
}
