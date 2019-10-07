taskx Compile @{
    Inputs = {
        Get-ChildItem (Get-KmtBuildVariable).BuildRoot -Recurse -File -Include *.cs
    }
    Outputs = "{0}\bin\{1}.dll" -f (Get-KmtBuildVariable).Destination,(Get-KmtBuildVariable).ModuleName
    Jobs = {
        Invoke-KmtDotNetCompileTask
    }
}
