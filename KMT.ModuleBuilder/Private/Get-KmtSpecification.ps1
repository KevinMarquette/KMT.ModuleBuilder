function Get-KmtSpecification
{
    <#
        .Synopsis
        Gets the module.kmt.json file for the module

        .Example
        Get-KmtSpecification -Path $Path

        .Notes
        Searches specified folder first
        Then sub folders
        Then parent folders
    #>

    [cmdletbinding()]
    param(
        [Parameter(
            Position = 0,
            ValueFromPipeline
        )]
        [string]
        $Path = (Get-Location)
    )

    process
    {
        try
        {
            $filter = @{filter = 'module.kmt.json'}

            Write-Debug "Load from local folder [$path]"
            $specFile = Get-ChildItem $Path @filter
            if(-not $specFile)
            {
                Write-Debug 'Check all child folders'
                $specFile = Get-ChildItem $Path @filter -Recurse |
                    Select -First 1
            }

            if(-not $specFile)
            {
                while($Path = Split-Path $Path)
                {
                    Write-Debug "Walk parent folders [$Path]"
                    $specFile = Get-ChildItem $Path @filter
                }
            }

            if(-not $specFile)
            {
                Write-Debug 'Specification was not found'
                throw [System.IO.FileNotFoundException]::new(
                    'Unable to find [module.kmt.json] specification',
                    'module.kmt.json'
                )
            }

            Write-Verbose "Loading KMT Specification [$($specFile.FullName)]"
            $specification = Get-Content -Path $specFile -Raw |
                ConvertFrom-Json

            # attach spec path so we can find the root of the project
            $member = @{
                MemberType = 'NoteProperty'
                Name = 'specificationPath'
                Value = $specFile.FullName
            }
            $specification | Add-Member @member

            $specification
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSItem )
        }
    }
}
