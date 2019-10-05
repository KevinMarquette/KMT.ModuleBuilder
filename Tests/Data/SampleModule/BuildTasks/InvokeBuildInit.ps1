Write-Verbose "Initializing build variables" -Verbose
Write-Verbose "  Existing BuildRoot [$BuildRoot]" -Verbose

$init = Initialize-KTMModuleProject -ModuleName SampleModule -BuildRoot "$testdrive\SampleModule"

$Script:DocsPath = $init.DocsPath
Write-Verbose "  DocsPath [$DocsPath]" -Verbose

$Script:Output = $init.Output
Write-Verbose "  Output [$Output]" -Verbose

$Script:Source = $init.Source
Write-Verbose "  Source [$Source]" -Verbose

$Script:Destination = $init.Destination
Write-Verbose "  Destination [$Destination]" -Verbose

$Script:ManifestPath = $init.ManifestPath
Write-Verbose "  ManifestPath [$ManifestPath]" -Verbose

$Script:ModulePath = $init.ModulePath
Write-Verbose "  ModulePath [$ModulePath]" -Verbose

$Script:Folders = $init.Folders
Write-Verbose "  Folders [$Folders]" -Verbose

$Script:TestFile = $init.TestFile
Write-Verbose "  TestFile [$TestFile]" -Verbose

$Script:PSRepository = $init.PSRepository
Write-Verbose "  PSRepository [$TestFile]" -Verbose

function taskx($Name, $Parameters) { task $Name @Parameters -Source $MyInvocation }
