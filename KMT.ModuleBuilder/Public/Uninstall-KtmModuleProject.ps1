function Uninstall-KtmModuleProject
{
    <#
        .Synopsis
        Uninstalls this module from the system

        .Example
        Uninstall-KtmModuleProject

        .Notes

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
        $Path = (Get-Location)
    )


    try
    {
        foreach ($folder in $Path)
        {
            Initialize-KmtModuleProject -Path $Folder

            $moduleName = (Get-KmtBuildVariable).ModuleName

            Write-Verbose 'Unloading Modules...'
            Get-Module -Name $ModuleName -ErrorAction 'Ignore' | Remove-Module -Force

            Write-Verbose 'Uninstalling Module packages...'
            $modules = Get-Module $ModuleName -ErrorAction 'Ignore' -ListAvailable
            foreach ($module in $modules)
            {
                Uninstall-Module -Name $module.Name -RequiredVersion $module.Version -ErrorAction 'Ignore'
            }

            Write-Verbose 'Cleaning up manually installed Modules...'
            $modulePath = $env:PSModulePath.Split(';').Where( {
                    $_ -like 'C:\Users\*'
                }, 'First', 1)

            $modulePath = Join-Path -Path $modulePath -ChildPath $ModuleName
            if ($ModuleName -and $modulePath -and (Test-Path -Path $modulePath))
            {
                Write-Verbose 'Removing files... (This may fail if any DLLs are in use.)'
                Get-ChildItem -Path $modulePath -File -Recurse |
                    Remove-Item -Force | ForEach-Object 'FullName'

                Write-Verbose 'Removing folders... (This may fail if any DLLs are in use.)'
                Remove-Item $modulePath -Recurse -Force
            }
        }

    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError( $PSItem )
    }
}
