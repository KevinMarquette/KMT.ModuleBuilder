function Invoke-KmtPublishVersionTask
{
    <#
        .Synopsis
        Publishes the version back to the build system

        .Example
        Invoke-KmtPublishVersionTask -Path $Path

        .Notes

    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '')]
    [cmdletbinding()]
    param(

    )


    try
    {
        $manifestPath = (Get-KmtBuildVariable).ManifestPath
        [version] $sourceVersion = (Get-Metadata -Path $manifestPath -PropertyName 'ModuleVersion')
        Write-Host "##vso[build.updatebuildnumber]$sourceVersion"

        # Do the same for appveyor
        # https://www.appveyor.com/docs/build-worker-api/#update-build-details
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError( $PSItem )
    }

}
