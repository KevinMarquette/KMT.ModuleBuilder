function Build-KmtModuleProject
{
    <#
        .Synopsis
        Executes all the build actions for a module

        .Example
        Build-KmtModuleProject -Path $Path

        .Notes

    #>
    [cmdletbinding()]
    param(
        [Alias('FullName')]
        [Parameter(
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Path = (Get-Location)
    )


    try
    {
        #$Script:ModuleName = Get-ChildItem .\*\*.psm1 | Select-object -ExpandProperty BaseName
        #$Script:CodeCoveragePercent = 0.0 # 0 to 1

        Initialize-KmtModuleProject -Path $Path
        $init = Get-KmtBuildVariable
        foreach($key in $init.Keys)
        {
            Write-Verbose "  $key [$($init[$key])]" -Verbose
        }
        #Build
        Write-Verbose 'Copy'
        Invoke-KmtCopyTask
        Write-Verbose 'Compile'
        Invoke-KmtDotNetCompileTask
        Write-Verbose 'BuildModule'
        Invoke-KmtBuildModuleTask
        Write-Verbose 'BuildManifest'
        Invoke-KmtBuildManifestTask
        Write-Verbose 'SetVersion'
        Invoke-KmtSemVerTask
        Write-Verbose 'GenerateMarkdown'
        Invoke-KmtGenerateMarkdown
        Write-Verbose 'GenerateHelp'
        Invoke-KmtGenerateHelpTask
        Write-Verbose 'ImportModule'
        Invoke-KmtImportBuiltModuleTask
        Write-Verbose 'Analyze'
        Invoke-KmtAnalyzeTask
        Write-Verbose 'Pester'
        Invoke-KmtPesterTask
        Write-Verbose 'UpdateSource'
        Invoke-KmtUpdateSourceTask
    }
    catch
    {
        #Write-Error -ErrorRecord $PSItem -ErrorAction Stop
        $PSCmdlet.ThrowTerminatingError( $PSItem )
    }
}
