function Assert-Psm1Equality
{
    param(
        [Parameter(ValueFromPipeline)]
        $TargetFile,

        [Parameter(Position=0)]
        $ReferenceFile
    )

    $TargetFile | Should -Exist

    $referenceData = Get-Content -Path $ReferenceFile -ErrorAction Stop |
        Where {$_ -notmatch '^#'}

    $destinationData = Get-Content -Path $TargetFile -ErrorAction Stop |
        Where {$_ -notmatch '^#'}

    $destinationData | Should -BeExactly $referenceData
}
