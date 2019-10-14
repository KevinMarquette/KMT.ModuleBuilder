function Reset-KtmModule
{
    <#
        .Synopsis
        Clears the build output for the module

        .Example
        Reset-KtmModule -Path $Path

        .Notes

    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '')]
    [Alias('Clean-KtmModule')]
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [Alias('FullName')]
        [Parameter(
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Path = (Get-Location)
    )

    process
    {
        try
        {
            foreach($folder in $Path)
            {
                Initialize-KmtModuleProject -Path $Folder
                Invoke-KmtCleanTask
            }

        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSItem )
        }
    }

    end
    {

    }
}
