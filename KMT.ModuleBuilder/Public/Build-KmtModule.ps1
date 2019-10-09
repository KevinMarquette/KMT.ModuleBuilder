function Build-KmtModule
{
    <#
        .Synopsis
        Executes all the build actions for a module

        .Example
        Build-KmtModule -Path $Path

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
        $Script:ModuleName = Get-ChildItem .\*\*.psm1 | Select-object -ExpandProperty BaseName
        $Script:CodeCoveragePercent = 0.0 # 0 to 1

        Initialize-KmtModuleProject -Path "$testdrive\SampleModule"
        $init = Get-KmtBuildVariable
        foreach($key in $init.Keys)
        {
            Write-Verbose "  $key [$($init[$key])]" -Verbose
        }
        #Build
        #Copy
        Invoke-KmtCopyTask
        #Compile
        Invoke-KmtDotNetCompileTask
        #BuildModule
        Invoke-KmtBuildModuleTask
        #Buildmanifest
        Invoke-KmtBuildManifestTask
        #SetVersion
        Invoke-KmtSemVerTask
        #Helpify
        #GenerateMarkdown
        Invoke-KmtGenerateMarkdown
        #GenerateHelp
        Invoke-KmtGenerateHelpTask
        #Test
        #ImportModule
        Invoke-KmtImportBuiltModuleTask
        #Pester
        Invoke-KmtAnalyzeTask
        Invoke-KmtPesterTask
        #UpdateSource
        Invoke-KmtUpdateSourceTask

    }
    catch
    {
        Write-Error -ErrorRecord $PSItem -ErrorAction Stop
        #$PSCmdlet.ThrowTerminatingError( $PSItem )
    }

}
