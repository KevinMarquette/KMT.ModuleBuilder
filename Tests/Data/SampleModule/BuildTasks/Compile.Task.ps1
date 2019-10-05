taskx Compile @{
    If = (Get-ChildItem -Path (Get-KTMBuildVariable).BuildRoot -Include *.csproj -Recurse)
    Inputs = {
        Get-ChildItem (Get-KTMBuildVariable).BuildRoot -Recurse -File -Include *.cs
    }
    Outputs = "{0}\bin\{1}.dll" -f (Get-KTMBuildVariable).Destination,(Get-KTMBuildVariable).ModuleName
    Jobs = {
        $buildRoot = (Get-KTMBuildVariable).BuildRoot
        $destination = (Get-KTMBuildVariable).Destination

        # This build command requires .Net Core
        "Building Module"
        $csproj = Get-ChildItem -Path $BuildRoot -Include *.csproj -Recurse
        $folder = Split-Path $csproj
        dotnet build $folder -c Release -o $Destination\bin
    }
}
