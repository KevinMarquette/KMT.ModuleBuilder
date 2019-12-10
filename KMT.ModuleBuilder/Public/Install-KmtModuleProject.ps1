function Install-KmtModuleProject
{
    <#
        .Synopsis
        Installs the current module project if it is built

        .Example
        Install-KmtModuleProject

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
            foreach ($folder in $Path)
            {
                Initialize-KmtModuleProject -Path $Folder
                $moduleName = (Get-KmtBuildVariable).ModuleName

                if ($DevelopmentVersion)
                {
                    $moduleFolder = (Get-KmtBuildVariable).Source
                    $manifestPath = (Get-KmtBuildVariable).ModulePath
                }
                else
                {
                    $manifestPath = (Get-KmtBuildVariable).ManifestPath
                    $moduleFolder = (Get-KmtBuildVariable).Destination
                }

                $version = [version] (Get-Metadata -Path $manifestPath -PropertyName 'ModuleVersion')

                # Get the users module folder
                $modulePath = $env:PSModulePath.Split(';').Where( {
                        $_ -like 'C:\Users\*'
                    }, 'First', 1)

                if ($modulePath -and (Test-Path -Path $modulePath))
                {
                    Write-Verbose "Using [$modulePath] as base path..."
                    $modulePath = Join-Path -Path $modulePath -ChildPath $ModuleName
                    $modulePath = Join-Path -Path $modulePath -ChildPath $version

                    Write-Verbose "Creating directory at [$modulePath]..."
                    New-Item -Path $modulePath -ItemType 'Directory' -Force -ErrorAction 'Ignore' | Out-Null

                    Write-Verbose "Copying items from [$moduleFolder] to [$modulePath]..."
                    Copy-Item -Path "$moduleFolder\*" -Destination $modulePath -Recurse -Force | Out-Null
                }
            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSItem )
        }
    }
}
