Write-Verbose "Initializing build variables" -Verbose
Write-Verbose "  Existing BuildRoot [$BuildRoot]" -Verbose

Initialize-KmtModuleProject -ModuleName SampleModule -BuildRoot "$testdrive\SampleModule"
$init = Get-KmtBuildVariable
foreach($key in $init.Keys)
{
    Write-Verbose "  $key [$($init[$key])]" -Verbose
}

function taskx($Name, $Parameters) { task $Name @Parameters -Source $MyInvocation }
task Analyze {
    Invoke-KmtAnalyzeTask
}

taskx BuildManifest @{
    Inputs  = (Get-ChildItem -Path (Get-KmtBuildVariable).Source -Recurse -File)
    Outputs = (Get-KmtBuildVariable).ManifestPath
    Jobs    = {
        Invoke-KmtBuildManifestTask
    }
}

taskx BuildModule @{
    Inputs  = (Get-ChildItem -Path (Get-KmtBuildVariable).Source -Recurse -Filter *.ps1)
    Outputs = (Get-KmtBuildVariable).ModulePath
    Jobs    = {
        Invoke-KmtBuildModuleTask
    }
}

task Clean {
    Invoke-KmtCleanTask
}

taskx Compile @{
    Inputs = {
        Get-ChildItem (Get-KmtBuildVariable).BuildRoot -Recurse -File -Include *.cs
    }
    Outputs = "{0}\bin\{1}.dll" -f (Get-KmtBuildVariable).Destination,(Get-KmtBuildVariable).ModuleName
    Jobs = {
        Invoke-KmtDotNetCompileTask
    }
}

task Copy {
    Invoke-KmtCopyTask
}

task GenerateHelp {
    Invoke-KmtGenerateHelpTask
}

task GenerateMarkdown {
    Invoke-KmtGenerateMarkdown
}

task ImportDevModule {
    Invoke-KmtImportDevModuleTask
}

task ImportModule {
    Invoke-KmtImportBuiltModuleTask
}

task Install Uninstall, {
    Invoke-KmtInstallModule
}

task Pester {
    Invoke-KmtPesterTask
}

task PublishModule {
    Invoke-KmtPublishModuleTask
}

task PublishVersion {
    Invoke-KmtPublishVersionTask
}

task SetVersion {
    Invoke-KmtSemVerTask
}


task Uninstall {
    Invoke-KtmUninstallModule
}

task UpdateSource {
    Invoke-KmtUpdateSourceTask
}
