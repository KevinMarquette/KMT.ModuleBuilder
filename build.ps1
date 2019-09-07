[CmdletBinding()]

param($Task = 'Default')

$Script:Modules = @(
    'BuildHelpers',
    'InvokeBuild',
    'LDModuleBuilder',
    'Pester',
    'platyPS',
    'PSScriptAnalyzer',
    'DependsOn'
)

$Script:ModuleInstallScope = 'CurrentUser'

'Starting build...'
'Installing module dependencies...'

Get-PackageProvider -Name 'NuGet' -ForceBootstrap | Out-Null

Update-LDModule -Name $Script:Modules -Scope $Script:ModuleInstallScope

Set-BuildEnvironment
Get-ChildItem Env:BH*
Get-ChildItem Env:APPVEYOR*

$Error.Clear()

'Invoking build...'

Invoke-Build $Task -Result 'Result'
if ($Result.Error)
{
    $Error[-1].ScriptStackTrace | Out-String
    exit 1
}

exit 0
