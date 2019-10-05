
taskx BuildManifest @{
    Inputs  = (Get-ChildItem -Path (Get-KTMBuildVariable).Source -Recurse -File)
    Outputs = (Get-KTMBuildVariable).ManifestPath
    Jobs    = {
        $ManifestPath = (Get-KTMBuildVariable).ManifestPath
        $ModuleName = (Get-KTMBuildVariable).ModuleName
        $Source = (Get-KTMBuildVariable).Source

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
