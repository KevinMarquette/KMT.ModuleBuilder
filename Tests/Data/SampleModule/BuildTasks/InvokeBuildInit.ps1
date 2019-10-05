Write-Verbose "Initializing build variables" -Verbose
Write-Verbose "  Existing BuildRoot [$BuildRoot]" -Verbose

Initialize-KTMModuleProject -ModuleName SampleModule -BuildRoot "$testdrive\SampleModule"
$init = Get-KTMBuildVariable
foreach($key in $init.Keys)
{
    Write-Verbose "  $key [$($init[$key])]" -Verbose
}

function taskx($Name, $Parameters) { task $Name @Parameters -Source $MyInvocation }
