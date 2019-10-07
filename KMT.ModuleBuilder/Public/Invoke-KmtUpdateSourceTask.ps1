function Invoke-KmtUpdateSourceTask
{
    <#
        .Synopsis
        Moves manifest changes back into source

        .Example
        Invoke-KmtUpdateSourceTask

        .Notes

    #>
    [cmdletbinding()]
    param(

    )

    end
    {
        try
        {
            $source = (Get-KmtBuildVariable).Source
            $manifestPath = (Get-KmtBuildVariable).ManifestPath
            $moduleName = (Get-KmtBuildVariable).moduleName

            Copy-Item -Path $ManifestPath -Destination "$Source\$ModuleName.psd1"

            $content = Get-Content -Path "$Source\$ModuleName.psd1" -Raw -Encoding UTF8
            $content.Trim() | Set-Content -Path "$Source\$ModuleName.psd1" -Encoding UTF8
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSItem )
        }
    }
}
