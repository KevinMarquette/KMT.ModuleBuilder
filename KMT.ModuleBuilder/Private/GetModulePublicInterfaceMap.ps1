function Get-ModulePublicInterfaceMap
{
    <#
    .Notes
    Imports a module and build a map of the public interface that is easy to compareS
    #>
    param($Path)
    $module = ImportModule -Path $Path -PassThru
    $exportedCommands = @(
        $module.ExportedFunctions.values
        $module.ExportedCmdlets.values
        $module.ExportedAliases.values
    )

    foreach($command in $exportedCommands)
    {
        foreach ($parameter in $command.Parameters.Keys)
        {
            if($false -eq $command.Parameters[$parameter].IsDynamic)
            {
                '{0}:{1}' -f $command.Name, $command.Parameters[$parameter].Name
                foreach ($alias in $command.Parameters[$parameter].Aliases)
                {
                    '{0}:{1}' -f $command.Name, $alias
                }
            }
        }
    }
}
