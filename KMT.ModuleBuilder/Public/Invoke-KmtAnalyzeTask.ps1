function Invoke-KmtAnalyzeTask
{
    <#
        .Synopsis
        Invokes script analzer
        .Example
        Invoke-KmtAnalyzeTask -Path $Path

        .Notes

    #>
    [cmdletbinding()]
    param()

    try
    {
        $ManifestPath = (Get-KmtBuildVariable).ManifestPath
        $BuildRoot = (Get-KmtBuildVariable).BuildRoot

        $params = @{
            IncludeDefaultRules = $true
            Path                = $ManifestPath
            Settings            = "$BuildRoot\ScriptAnalyzerSettings.psd1"
            Severity            = 'Warning'
        }

        Write-Verbose "Analyzing [$ManifestPath]..."
        $results = Invoke-ScriptAnalyzer @params
        if ($results)
        {
            Write-Verbose 'One or more PSScriptAnalyzer errors/warnings were found.'
            Write-Verbose 'Please investigate or add the required SuppressMessage attribute.'
            $results | Format-Table -AutoSize
        }
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError( $PSItem )
    }

}
