using namespace System.Collections.Generic

function Update-KmtSemVerTask
{
    <#
        .Synopsis
        Calculates the SemVersion and instersts it into the manifest file
        .Example
        Update-KmtSemVerTask

        .Notes

    #>
    [cmdletbinding(SupportsShouldProcess)]
    param(

        $SourcePath,
        [parameter(Mandatory)]
        $ManifestPath,
        $ModuleName,
        $Repository = 'PSGallery'
    )

    end
    {
        try
        {
            if ($PSCmdlet.ShouldProcess($ManifestPath))
            {
                $output = (Get-KmtBuildVariable).Output

                $version = [version]"0.1.0"
                $publishedModule = $null
                $bumpVersionType = 'Patch'
                $versionStamp = (git rev-parse origin/master) + (git rev-parse head)

                Write-Verbose "Load current version from [$manifestPath]"
                [version] $sourceVersion = (Get-Metadata -Path $manifestPath -PropertyName 'ModuleVersion')
                Write-Verbose "  Source version [$sourceVersion]"

                $downloadFolder = Join-Path -Path $output downloads
                $null = New-Item -ItemType Directory -Path $downloadFolder -Force -ErrorAction Ignore

                $versionFile = Join-Path $downloadFolder versionfile
                if(Test-Path $versionFile)
                {
                    $versionFileData = Get-Content $versionFile -raw
                    if($versionFileData -eq $versionStamp)
                    {
                        continue
                    }
                }

                Write-Verbose "Checking for published version"
                $publishedModule = Find-Module -Name $ModuleName -ErrorAction 'Ignore' |
                    Sort-Object -Property {[version]$_.Version} -Descending |
                    Select -First 1

                if($null -ne $publishedModule)
                {
                    [version] $publishedVersion = $publishedModule.Version
                    Write-Verbose "  Published version [$publishedVersion]"

                    $version = $publishedVersion

                    Write-Verbose "Downloading published module to check for breaking changes"
                    $publishedModule | Save-Module -Path $downloadFolder

                    [HashSet[string]] $publishedInterface =
                        @(Get-ModulePublicInterfaceMap -Path (Join-Path $downloadFolder $ModuleName))
                    [HashSet[string]] $buildInterface =
                        @(Get-ModulePublicInterfaceMap -Path $ManifestPath)

                    if (-not $publishedInterface.IsSubsetOf($buildInterface))
                    {
                        $bumpVersionType = 'Major'
                    }
                    elseif ($publishedInterface.count -ne $buildInterface.count)
                    {
                        $bumpVersionType = 'Minor'
                    }
                }

                if ($version -lt ([version] '1.0.0'))
                {
                    Write-Verbose "Module is still in beta; don't bump major version."
                    if ($bumpVersionType -eq 'Major')
                    {
                        $bumpVersionType = 'Minor'
                    }
                    else
                    {
                        $bumpVersionType = 'Patch'
                    }
                }

                Write-Verbose "  Steping version [$bumpVersionType]"
                $version = [version] (Step-Version -Version $version -Type $bumpVersionType)

                Write-Verbose "  Comparing to source version [$sourceVersion]"
                if($sourceVersion -gt $version)
                {
                    Write-Verbose "    Using existing version"
                    $version = $sourceVersion
                }

                if ( -not [string]::IsNullOrEmpty( $env:Build_BuildID ) )
                {
                    $build = $env:Build_BuildID
                    $version = [version]::new($version.Major, $version.Minor, $version.Build, $build)
                }
                elseif ( -not [string]::IsNullOrEmpty( $env:APPVEYOR_BUILD_ID ) )
                {
                    $build = $env:APPVEYOR_BUILD_ID
                    $version = [version]::new($version.Major, $version.Minor, $version.Build, $build)
                }

                Write-Verbose "  Setting version [$version]"
                Update-Metadata -Path $ManifestPath -PropertyName 'ModuleVersion' -Value $version

                (Get-Content -Path $ManifestPath -Raw -Encoding UTF8) |
                    ForEach-Object {$_.TrimEnd()} |
                    Set-Content -Path $ManifestPath -Encoding UTF8

                Set-Content -Path $versionFile -Value $versionStamp -NoNewline -Encoding UTF8

            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSItem )
        }
    }
}
