function Invoke-KmtBuildManifestTask
{
    <#
        .Synopsis
        Copies the manifest and updates the functions to export
        .Example
        Invoke-KmtBuildManifestTask -Path $Path

        .Notes

    #>
    [cmdletbinding()]
    param()

    end
    {
        try
        {
            $ManifestPath = (Get-KmtBuildVariable).ManifestPath
            $ModuleName = (Get-KmtBuildVariable).ModuleName
            $Source = (Get-KmtBuildVariable).Source

            Write-Verbose "Updating [$ManifestPath]..."
            Copy-Item -Path "$Source\$ModuleName.psd1" -Destination $ManifestPath

            $functions = Get-ChildItem -Path "$ModuleName\Public" -Recurse -Filter *.ps1 -ErrorAction 'Ignore' |
                Where-Object 'Name' -notmatch 'Tests'

            if ($functions)
            {
                Write-Verbose 'Setting FunctionsToExport...'
                Set-ModuleFunction -Name $ManifestPath -FunctionsToExport $functions.BaseName
            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSItem )
        }
    }
}
