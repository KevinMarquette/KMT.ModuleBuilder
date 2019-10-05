function Get-KmtBuildVariable
{
    <#
        .Synopsis
        Retreives initialization variables
        .Example
        $buildVar = Get-KmtBuildVariable

        .Notes

    #>
    [cmdletbinding()]
    param()

    end
    {
        $script:buildInit
    }
}
