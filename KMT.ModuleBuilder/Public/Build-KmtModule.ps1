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
        Invoke-KmtPesterTask
        #UpdateSource
        Invoke-KmtUpdateSourceTask

    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError( $PSItem )
    }

}
