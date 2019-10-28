function Invoke-KmtInstallModule
{
    <#
        .Synopsis
        Installs this module to the system

        .Example
        Invoke-KmtInstallModule

        .Notes

    #>
    [cmdletbinding()]
    param(
        # Parameter help description
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Path
    )


    try
    {
        $manifestPath = (Get-KmtBuildVariable).ManifestPath
        $moduleName = (Get-KmtBuildVariable).ModuleName
        $destination = (Get-KmtBuildVariable).Destination

        $version = [version] (Get-Metadata -Path $manifestPath -PropertyName 'ModuleVersion')

        $path = $env:PSModulePath.Split(';').Where( {
                $_ -like 'C:\Users\*'
            }, 'First', 1)

        if ($path -and (Test-Path -Path $path))
        {
            Write-Verbose "Using [$path] as base path..."
            $path = Join-Path -Path $path -ChildPath $ModuleName
            $path = Join-Path -Path $path -ChildPath $version

            Write-Verbose "Creating directory at [$path]..."
            New-Item -Path $path -ItemType 'Directory' -Force -ErrorAction 'Ignore'

            Write-Verbose "Copying items from [$Destination] to [$path]..."
            Copy-Item -Path "$Destination\*" -Destination $path -Recurse -Force
        }
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError( $PSItem )
    }
}
