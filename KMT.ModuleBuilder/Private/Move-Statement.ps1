using namespace System.Collections.Generic
using namespace System.IO
using namespace System.Management.Automation

function Move-Statement
{
<#
.SYNOPSIS
    Moves statements containing a specified token to the specified index in a file.
.DESCRIPTION
    Move-Statement moves statements containing a specified token, to the specified index
    in a file. This can be used when building a module to move any using directives and
    #Requires statements to the top of a file.
.PARAMETER Path
    Specifies the path to an item to get its contents.
.PARAMETER Type
    Specifies the type of tokens to examine. Accepted values include "Comment" and "Keyword".
.PARAMETER Token
    Specifies the contents to filter on when examining a supplied token.
.PARAMETER Index
    Specifies the line to move a statement to. Each line in an item has a corresponding
    index, starting from 0.
.EXAMPLE
    Move-Statement -Path $Path -Type 'Comment', 'Keyword' -Token '#Requires', 'using' -Index 0

    Moves any using directives or #Requires statements to the top of a file.
.NOTES
    Copy/Paste from LDModuleBuilder
#>
    [CmdletBinding(SupportsShouldProcess)]

    param(
        [Parameter(Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path -Path $PSItem })]
        [string] $Path,

        [Parameter(Position = 1,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Comment', 'Keyword')]
        [string[]] $Type = ('Comment', 'Keyword'),

        [Parameter(Position = 2,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string[]] $Token = ('#Requires', 'using'),

        [Parameter(Position = 3,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [int] $Index = 0
    )

    process
    {
        try
        {
            $statements = [SortedSet[String]]::new(
                [StringComparer]::InvariantCultureIgnoreCase
            )

            Write-Verbose -Message "Reading content from $Path..."
            $content = [List[String]] (Get-Content $Path)

            Write-Verbose -Message "Tokenizing content from $Path..."
            $tokens = [PSParser]::Tokenize($content, [ref] $null)

            $match = $Token -join '|'

            Write-Verbose -Message 'Matching tokens...'
            Write-Verbose -Message "Type = [$Type]; Token = [$Token]"
            $keywords = $tokens.Where( {
                    $PSItem.Type -in $Type -and
                    $PSItem.Content -imatch "^(?:$match)"
                })

            if (-not $keywords)
            {
                Write-Verbose -Message 'No matching tokens found! Returning...'
                return
            }

            $offset = 1
            foreach ($keyword in $keywords)
            {
                $line = $keyword.StartLine - $offset

                Write-Verbose -Message "Moving [$($content[$line])] to Index [$Index]..."
                $null = $statements.Add($content[$line]),
                $content.RemoveAt($line)
                $offset++
            }

            [string[]] $comments, [string[]] $statements = $statements.Where( {
                    $PSItem -match '^#'
                }, 'Split')

            foreach ($item in ($statements, $comments))
            {
                $content.Insert($Index, '')
                $content.InsertRange($Index, $item)
            }

            if ($PSCmdlet.ShouldProcess($Path, $MyInvocation.MyCommand.Name))
            {
                Write-Verbose -Message "Writing content to $Path..."
                Set-Content -Path  $Path -Value $content -Encoding 'UTF8'
            }
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
