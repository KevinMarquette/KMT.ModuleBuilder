function Import-KmtModuleProject
{
    <#
        .SYNOPSIS
        Unloads existing module before importing from a path

        .Example
        Import-KmtModuleProject -Path $Path
    #>
    param(
        [string]$path,
        [switch]$PassThru
    )

    if (-not(Test-Path -Path $path))
    {
        Write-Verbose "Cannot find [$path]."
        Write-Error -Message "Could not find module manifest [$path]"
    }
    else
    {
        $file = Get-Item $path
        $name = $file.BaseName

        $loaded = Get-Module -Name $name -All -ErrorAction Ignore
        if ($loaded)
        {
            Write-Verbose "Unloading Module [$name] from a previous import..."
            $loaded | Remove-Module -Force
        }

        Write-Verbose "Importing Module [$name] from [$($file.fullname)]..."
        $splat = @{
            Name = $file.fullname
            Force = $true
            PassThru = $PassThru
            Scope = 'Global'
            Verbose = $false
        }
        Import-Module @splat
    }
}
