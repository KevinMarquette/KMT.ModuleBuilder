$Script:ModuleName = Get-ChildItem .\*\*.psm1 | Select-object -ExpandProperty BaseName
$Script:CodeCoveragePercent = 0.0 # 0 to 1


task Default Build, Helpify, Test, UpdateSource
task Build Copy, Compile, BuildModule, BuildManifest, SetVersion
task Helpify GenerateMarkdown, GenerateHelp
task Test Build, ImportModule, Pester
task Publish Build, PublishVersion, Helpify, Test, PublishModule
task TFS Clean, Build, PublishVersion, Helpify, Test
task DevTest ImportDevModule, Pester

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
    Jobs    = {
        Invoke-KmtBuildManifestTask
    }
}

taskx BuildModule @{

    Jobs    = {
        Invoke-KmtBuildModuleTask
    }
}

task Clean {
    Invoke-KmtCleanTask
}

taskx Compile @{
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
