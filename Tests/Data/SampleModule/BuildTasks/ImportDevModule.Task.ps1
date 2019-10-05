
task ImportDevModule {
    $source = (Get-KTMBuildVariable).Source
    $moduleName = (Get-KTMBuildVariable).ModuleName
    ImportModule -Path "$Source\$ModuleName.psd1" -Force
}
