function Invoke-KmtImportDevModuleTask
{
    <#
        .Synopsis
        Import the dev version of the module

        .Example
        Invoke-KmtImportDevModuleTask

        .Notes

    #>
    [cmdletbinding()]
    param()

    try
    {
        $source = (Get-KmtBuildVariable).Source
        $moduleName = (Get-KmtBuildVariable).ModuleName
        Import-KmtModuleProject -Path "$Source\$ModuleName.psd1" -Force
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError( $PSItem )
    }

}
