function Invoke-KmtCleanTask
{
    <#
        .Synopsis
        Cleans the project

        .Example
        Invoke-KmtCleanTask

        .Notes

    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '')]
    [cmdletbinding(SupportsShouldProcess)]
    param()

    try
    {
        Initialize-KmtModuleProject -Path "$testdrive\SampleModule"
        $Output = (Get-KmtBuildVariable).Output
        if (Test-Path $Output)
        {
            Write-Verbose "Cleaning Output files in [$Output]..."
            $null = Get-ChildItem -Path $Output -File -Recurse |
                Remove-Item -Force -ErrorAction 'Ignore'

            Write-Verbose "Cleaning Output directories in [$Output]..."
            $null = Get-ChildItem -Path $Output -Directory -Recurse |
                Remove-Item -Recurse -Force -ErrorAction 'Ignore'
        }
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError( $PSItem )
    }

}
