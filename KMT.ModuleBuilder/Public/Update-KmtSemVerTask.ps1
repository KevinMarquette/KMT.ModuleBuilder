function Update-KmtSemVerTask
{
    <#
        .Synopsis
        Calculates the SemVersion and instersts it into the manifest file
        .Example
        Update-KmtSemVerTask

        .Notes

    #>
    [cmdletbinding(SupportsShouldProcess)]
    param(
        $SourcePath,
        $ManifestPath,
        $ModuleName,
        $Repository = 'PSGallery'
    )

    begin
    {

    }

    process
    {
        try
        {
            if ($PSCmdlet.ShouldProcess($ManifestPath))
            {
            }
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
