Write-Verbose "Initializing build variables" -Verbose
Write-Verbose "  Existing BuildRoot [$BuildRoot]" -Verbose

Initialize-KmtModuleProject -ModuleName SampleModule -BuildRoot "$testdrive\SampleModule"
$init = Get-KmtBuildVariable
foreach($key in $init.Keys)
{
    Write-Verbose "  $key [$($init[$key])]" -Verbose
}

function taskx($Name, $Parameters) { task $Name @Parameters -Source $MyInvocation }
