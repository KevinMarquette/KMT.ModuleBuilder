function Invoke-KmtGenerateMarkdown
{
    <#
        .Synopsis
        Generates mardown files for all functions

        .Example
        Invoke-KmtGenerateMarkdown

        .Notes

    #>
    [cmdletbinding()]
    param(

    )


    try
    {
        $manifestPath = (Get-KmtBuildVariable).ManifestPath
        $docsPath = (Get-KmtBuildVariable).DocsPath
        $moduleName = (Get-KmtBuildVariable).ModuleName

        $module = Import-KmtModule -Path $ManifestPath -PassThru

        try
        {
            if ($module.ExportedFunctions.Count -eq 0)
            {
                Write-Verbose 'No functions have been exported for this module. Skipping Markdown generation...'
                return
            }

            if (Get-ChildItem -Path $DocsPath -Filter '*.md' -Recurse)
            {
                $items = Get-ChildItem -Path $DocsPath -Directory -Recurse
                foreach ($item in $items)
                {
                    Write-Verbose "Updating Markdown help in [$($item.BaseName)]..."
                    $null = Update-MarkdownHelp -Path $item.FullName -AlphabeticParamsOrder
                }
            }

            $params = @{
                AlphabeticParamsOrder = $true
                ErrorAction           = 'SilentlyContinue'
                Locale                = 'en-US'
                Module                = $ModuleName
                OutputFolder          = "$DocsPath\en-US"
                WithModulePage        = $true
            }

            # ErrorAction is set to SilentlyContinue so this
            # command will not overwrite an existing Markdown file.
            Write-Verbose "Creating new Markdown help for [$ModuleName]..."
            $null = New-MarkdownHelp @params
        }
        finally
        {
            Remove-Module -Name $ModuleName -Force
        }
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError( $PSItem )
    }


}
