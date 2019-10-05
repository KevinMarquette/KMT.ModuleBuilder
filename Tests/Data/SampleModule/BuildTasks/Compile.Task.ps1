taskx Compile @{
    If = (Get-ChildItem -Path (Get-KmtBuildVariable).BuildRoot -Include *.csproj -Recurse)
    Inputs = {
        Get-ChildItem (Get-KmtBuildVariable).BuildRoot -Recurse -File -Include *.cs
    }
    Outputs = "{0}\bin\{1}.dll" -f (Get-KmtBuildVariable).Destination,(Get-KmtBuildVariable).ModuleName
    Jobs = {
        $buildRoot = (Get-KmtBuildVariable).BuildRoot
        $destination = (Get-KmtBuildVariable).Destination

        # This build command requires .Net Core
        "Building Module"
        $csproj = Get-ChildItem -Path $BuildRoot -Include *.csproj -Recurse
        $folder = Split-Path $csproj
        dotnet build $folder -c Release -o $Destination\bin
    }
}
