function Invoke-KtmUninstallModule
{
    <#
        .Synopsis
        Uninstalls this module

        .Example
        Invoke-KtmUninstallModule -Path $Path

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
        $path = $env:PSModulePath.Split(';').Where( {
                $_ -like 'C:\Users\*'
            }, 'First', 1)

        $path = Join-Path -Path $path -ChildPath $ModuleName
        if ($path -and (Test-Path -Path $path))
        {
            Write-Verbose 'Removing files... (This may fail if any DLLs are in use.)'
            Get-ChildItem -Path $path -File -Recurse |
                Remove-Item -Force | ForEach-Object 'FullName'

            Write-Verbose 'Removing folders... (This may fail if any DLLs are in use.)'
            Remove-Item $path -Recurse -Force
        }
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError( $PSItem )
    }
}


