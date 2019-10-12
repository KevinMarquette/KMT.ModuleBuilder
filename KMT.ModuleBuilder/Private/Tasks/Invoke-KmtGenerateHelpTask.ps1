function Invoke-KmtGenerateHelpTask
{
    <#
        .Synopsis
        Generates help from markdown files

        .Example
        Invoke-KmtGenerateHelpTask

        .Notes

    #>
    [cmdletbinding()]
    param()


    try
    {
        $docsPath = (Get-KmtBuildVariable).DocsPath
        $destination = (Get-KmtBuildVariable).Destination
        $moduleName = (Get-KmtBuildVariable).ModuleName

        if (-not(Get-ChildItem -Path $DocsPath -Filter '*.md' -Recurse -ErrorAction 'Ignore'))
        {
            Write-Verbose "No Markdown help files to process. Skipping help file generation..."
            return
        }

        $locales = (Get-ChildItem -Path $DocsPath -Directory).Name
        foreach ($locale in $locales)
        {
            $params = @{
                ErrorAction = 'SilentlyContinue'
                Force       = $true
                OutputPath  = "$Destination\en-US"
                Path        = "$DocsPath\en-US"
            }

            # Generate the module's primary MAML help file.
            Write-Verbose "Creating new External help for [$ModuleName]..."
            $null = New-ExternalHelp @params
        }
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError( $PSItem )
    }

}
