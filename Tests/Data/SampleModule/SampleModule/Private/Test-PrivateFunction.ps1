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
