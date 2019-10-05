taskx BuildModule @{
    Inputs  = (Get-ChildItem -Path (Get-KmtBuildVariable).Source -Recurse -Filter *.ps1)
    Outputs = (Get-KmtBuildVariable).ModulePath
    Jobs    = {
        $source = (Get-KmtBuildVariable).Source
        $modulePath = (Get-KmtBuildVariable).ModulePath
        $task = @{
            SourcePath = $source
            OutputFileName = $modulePath
        }
        Build-KmtModuleTask @task
    }
}
