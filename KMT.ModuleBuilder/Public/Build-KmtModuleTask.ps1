function Build-KmtModuleTask
{
    <#
        .Synopsis
        Combines module source files into a psm1

        .Example
        Build-KmtModuleTask -Path $Path

        .Notes

    #>
    [cmdletbinding()]
    param(
        [string]
        $SourcePath,

        [string]
        $OutputFileName
    )

    begin
    {

    }

    process
    {
        try
        {
            Set-Content -Path $OutputFileName -Value 'test'
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSItem )
        }
    }

    end
    {

    }
}
