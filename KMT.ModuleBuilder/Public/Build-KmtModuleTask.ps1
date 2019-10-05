function Build-KmtModuleTask
{
    <#
        .Synopsis
        Combines module source files into a psm1

        .Example
        Build-KmtModuleTask -Path $Path

        .Notes

    #>
    [cmdletbinding()]
    param(
        [string]
        $SourcePath,

        [string]
        $OutputFileName
    )

    begin
    {

    }

    process
    {
        try
        {
            $source = $SourcePath
            $buildRoot = (Get-KmtBuildVariable).BuildRoot
            $modulePath = $OutputFileName
            $folders = (Get-KmtBuildVariable).Folders

            $sb = [Text.StringBuilder]::new()
            $null = $sb.AppendLine('$Script:PSModuleRoot = $PSScriptRoot')

            # Class importer
            $root = Join-Path -Path $source -ChildPath 'Classes'
            "Load classes from [$root]"
            $classFiles = Get-ChildItem -Path $root -Filter '*.ps1' -Recurse |
                Where-Object Name -notlike '*.Tests.ps1'

            $classes = @{ }

            foreach ($file in $classFiles)
            {
                $name = $file.BaseName
                $classes[$name] = @{
                    Name = $name
                    Path = $file.FullName
                }
                $data = Get-Content $file.fullname
                foreach ($line in $data)
                {
                    if ($line -match "\s+($Name)\s*(:|requires)\s*(?<baseclass>\w*)|\[(?<baseclass>\w+)\]")
                    {
                        $classes[$name].Base += @($Matches.baseclass)
                    }
                }
            }

            $importOrder = $classes.GetEnumerator() | Resolve-DependencyOrder  -Key { $_.Name } -DependsOn { $_.Value.Base }

            foreach ($class in $importOrder)
            {
                $classPath = $class.Value.Path
                "Importing [$classPath]..."
                $null = $sb.AppendLine("# .$classPath")
                $null = $sb.AppendLine([IO.File]::ReadAllText($classPath))
            }

            foreach ($folder in ($Folders -ne 'Classes'))
            {
                if (Test-Path -Path "$Source\$folder")
                {
                    $null = $sb.AppendLine("# Importing from [$Source\$folder]")
                    $files = Get-ChildItem -Path "$Source\$folder" -Recurse -Filter *.ps1 |
                        Where-Object 'Name' -notlike '*.Tests.ps1'

                    foreach ($file in $files)
                    {
                        $name = $file.Fullname.Replace($buildroot, '')

                        "Importing [$($file.FullName)]..."
                        $null = $sb.AppendLine("# .$name")
                        $null = $sb.AppendLine([IO.File]::ReadAllText($file.FullName))
                    }
                }
            }

            "Creating Module [$ModulePath]..."
            $null = New-Item -Path (Split-path $ModulePath) -ItemType Directory -ErrorAction SilentlyContinue -Force
            Set-Content -Path  $ModulePath -Value $sb.ToString() -Encoding 'UTF8'

            'Moving "#Requires" statements and "using" directives...'
            Move-Statement -Path $ModulePath -Type 'Comment', 'Keyword' -Token '#Requires', 'using' -Index 0
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSItem )
        }
    }

    end
    {

    }
}
