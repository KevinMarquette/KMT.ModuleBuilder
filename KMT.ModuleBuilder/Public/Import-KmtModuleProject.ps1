function Import-KmtModuleProject
{
    <#
        .Synopsis
        Imports the current module project if it is built

        .Example
        Import-KmtModuleProject

        .Notes
        Must run the build first
    #>
    [cmdletbinding()]
    param(
        [Alias('FullName')]
        [Parameter(
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Path = (Get-Location),

        [switch]$DevelopmentVersion
    )

    process
    {
        try
        {
            foreach($folder in $Path)
            {
                Initialize-KmtModuleProject -Path $Folder
                if($DevelopmentVersion)
                {
                    Invoke-KmtImportDevModuleTask
                }
                else
                {
                    Invoke-KmtImportBuiltModuleTask
                }
            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSItem )
        }
    }
}
