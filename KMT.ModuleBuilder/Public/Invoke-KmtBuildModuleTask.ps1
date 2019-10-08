function Invoke-KmtBuildModuleTask
{
    <#
        .Synopsis
        Executes the build module task
        .Example
        Invoke-KmtBuildModuleTask

        .Notes

    #>
    [cmdletbinding()]
    param()

    try
    {
        $source = (Get-KmtBuildVariable).Source
        $modulePath = (Get-KmtBuildVariable).ModulePath
        $task = @{
            SourcePath     = $source
            OutputFileName = $modulePath
        }
        Build-KmtModuleTask @task
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError( $PSItem )
    }

}
