function Get-KTMBuildVariable
{
    <#
        .Synopsis
        Retreives initialization variables
        .Example
        $buildVar = Get-KTMBuildVariable

        .Notes

    #>
    [cmdletbinding()]
    param()

    end
    {
        $script:buildInit
    }
}
