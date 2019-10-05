task UpdateSource {
    $source = (Get-KTMBuildVariable).Source
    $manifestPath = (Get-KTMBuildVariable).ManifestPath
    $moduleName = (Get-KTMBuildVariable).moduleName

    Copy-Item -Path $ManifestPath -Destination "$Source\$ModuleName.psd1"

    $content = Get-Content -Path "$Source\$ModuleName.psd1" -Raw -Encoding UTF8
    $content.Trim() | Set-Content -Path "$Source\$ModuleName.psd1" -Encoding UTF8
}
