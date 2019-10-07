
task ImportDevModule {
    $source = (Get-KmtBuildVariable).Source
    $moduleName = (Get-KmtBuildVariable).ModuleName
    Import-KmtModule -Path "$Source\$ModuleName.psd1" -Force
}
