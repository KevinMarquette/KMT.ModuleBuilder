using namespace System.IO
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
        $BuildVariables = Get-KmtBuildVariable

        $scripts = Get-ChildItem -Path (Join-Path $PSModuleRoot 'Pester') |
            Foreach-Object {@{
                Path       = $_.FullName
                Parameters = @{BuildVariables = $BuildVariables}
            }}

        $pester = @{
            Script = $scripts
            PassThru = $true
            Show     = 'Failed', 'Fails', 'Summary'
        }
        $results = Invoke-Pester @pester
        if ($results.FailedCount -gt 0)
        {
            Write-Error -Message "Failed [$($results.FailedCount)] Ktm Pester tests." -ErrorAction Stop
        }
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError( $PSItem )
    }
}
