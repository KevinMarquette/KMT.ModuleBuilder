function Initialize-KTMModuleProject
{
    <#
        .Synopsis
        Initializes several project values used by other functions

        .Example
        Initialize-KTMModuleProject -Path $Path

        .Notes

    #>
    [cmdletbinding()]
    param(
        [string]
        # Root folder of the project
        $BuildRoot = (Get-Location),

        # Name of the module
        $ModuleName = 'None'
    )

    end
    {
        try
        {
            Write-Verbose "Initializing build variables"
            $output = Join-Path -Path $BuildRoot -ChildPath 'Output'
            $destination = Join-Path -Path $Output -ChildPath $ModuleName
            $script:buildInit = @{
                ModuleName = $ModuleName
                BuildRoot = $BuildRoot
                DocsPath = Join-Path -Path $BuildRoot -ChildPath 'Docs'
                Output = $output
                Source = Join-Path -Path $BuildRoot -ChildPath $ModuleName
                Destination = $destination
                ManifestPath = Join-Path -Path $destination -ChildPath "$ModuleName.psd1"
                ModulePath = Join-Path -Path $destination -ChildPath "$ModuleName.psm1"
                Folders = 'Classes', 'Includes', 'Internal', 'Private', 'Public', 'Resources'
                TestFile = Join-Path -Path $output -ChildPath "TestResults_PS${PSVersion}_$TimeStamp.xml"
                PSRepository = 'PSGallery'
            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSItem )
        }
    }
}
