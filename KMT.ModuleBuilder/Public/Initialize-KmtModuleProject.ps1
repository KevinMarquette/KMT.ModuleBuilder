function Initialize-KmtModuleProject
{
    <#
        .Synopsis
        Initializes several project values used by other functions

        .Example
        Initialize-KmtModuleProject -Path $Path

        .Notes

    #>
    [cmdletbinding()]
    param(
        [string]
        # Root folder of the project
        $Path = (Get-Location)
    )

    end
    {
        try
        {
            $spec = Get-KmtSpecification -Path $Path
            $moduleName = $spec.moduleName
            $buildRoot = Split-Path -Path $spec.specificationPath
            $folders = $spec.folders

            Write-Verbose "Initializing build variables"
            $output = Join-Path -Path $buildRoot -ChildPath 'Output'
            $destination = Join-Path -Path $Output -ChildPath $moduleName
            $script:buildInit = @{
                ModuleName   = $moduleName
                BuildRoot    = $buildRoot
                DocsPath     = Join-Path -Path $buildRoot -ChildPath 'Docs'
                Output       = $output
                Source       = Join-Path -Path $buildRoot -ChildPath $moduleName
                Destination  = $destination
                ManifestPath = Join-Path -Path $destination -ChildPath "$moduleName.psd1"
                ModulePath   = Join-Path -Path $destination -ChildPath "$moduleName.psm1"
                Folders      = $folders
                TestFile     = Join-Path -Path $output -ChildPath "TestResults_PS${PSVersion}_$TimeStamp.xml"
                PSRepository = 'PSGallery'
            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSItem )
        }
    }
}
