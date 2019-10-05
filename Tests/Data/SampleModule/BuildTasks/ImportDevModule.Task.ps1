
task ImportDevModule {
    $source = (Get-KmtBuildVariable).Source
    $moduleName = (Get-KmtBuildVariable).ModuleName
    ImportModule -Path "$Source\$ModuleName.psd1" -Force
}
