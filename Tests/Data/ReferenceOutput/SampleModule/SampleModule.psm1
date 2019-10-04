$Script:PSModuleRoot = $PSScriptRoot
# .C:\source\KMT.ModuleBuilder\Tests\Data\SampleModule\SampleModule\Classes\CClass.ps1
Class CClass {
    [void] TestFuncitonC(){}
}

# .C:\source\KMT.ModuleBuilder\Tests\Data\SampleModule\SampleModule\Classes\BClass.ps1
Class BClass : CClass {
    [void] TestFuncitonB(){}
}

# .C:\source\KMT.ModuleBuilder\Tests\Data\SampleModule\SampleModule\Classes\AClass.ps1
class AClass {
    [BClass] TestFunction()
    {
        return $null
    }
}

# Importing from [C:\source\KMT.ModuleBuilder\Tests\Data\SampleModule\SampleModule\Private]
# .\SampleModule\Private\Test-PrivateFunction.ps1
function Test-PrivateFunction
{
    <#
        .Synopsis
        Test Private Function Synopsis

        .Example
        Test-PrivateFunction -Path $Path

        .Notes

    #>
    [cmdletbinding()]
    param(
        # Parameter help description
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Path
    )

    begin
    {

    }

    process
    {
        try
        {
            foreach ( $node in $Path )
            {
                Write-Debug $node

            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSItem )
        }
    }

    end
    {

    }
}

# Importing from [C:\source\KMT.ModuleBuilder\Tests\Data\SampleModule\SampleModule\Public]
# .\SampleModule\Public\Test-PublicFunction.ps1
function Test-PublicFunction
{
    <#
        .Synopsis
        Example Public Function

        .Example
        Test-PublicFunction -Path $Path

        .Notes

    #>
    [cmdletbinding()]
    param(
        # Parameter help description
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Path
    )

    begin
    {

    }

    process
    {
        try
        {
            foreach ( $node in $Path )
            {
                Write-Debug $node

            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError( $PSItem )
        }
    }

    end
    {

    }
}


