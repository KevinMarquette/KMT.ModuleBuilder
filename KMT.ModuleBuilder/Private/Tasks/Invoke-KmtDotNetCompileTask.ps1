function Invoke-KmtDotNetCompileTask
{
    <#
        .Synopsis
        Compiles DotNet binary module
        .Example
        Invoke-KmtDotNetCompileTask -Path $Path

        .Notes

    #>
    [cmdletbinding()]
    param()

    end
    {
        try
        {
            $buildRoot = (Get-KmtBuildVariable).BuildRoot
            $destination = (Get-KmtBuildVariable).Destination

            $csproj = Get-ChildItem -Path $buildRoot -Include *.csproj -Recurse
            if ($csproj)
            {

                # This build command requires .Net Core
                # TODO add check for dotnet
                Write-Verbose "Building Binary Module"
                $csproj = Get-ChildItem -Path $BuildRoot -Include *.csproj -Recurse
                $folder = Split-Path $csproj
                dotnet build $folder -c Release -o $Destination\bin
            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSItem )
        }
    }
}
