function Invoke-KmtImportBuiltModuleTask
{
    <#
        .Synopsis
        Imports the built module

        .Example
        Invoke-KmtImportBuiltModuleTask

        .Notes

    #>
    [cmdletbinding()]
    param()

    try
    {
        $path = (Get-KmtBuildVariable).ManifestPath
        Import-KmtModule -Path $path -Force
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError( $PSItem )
    }
}
