function Find-AssetGuid {
    <#
        Find GUIDs of all asset types for KB article specified by its Uri
    #>

    [CmdletBinding()]
        Param(
            [Parameter(
                HelpMessage = 'Microsoft KnowledgeBase article Uri.',
                Mandatory,
                Position = 0,
                ValueFromPipeline,
                ValueFromPipelineByPropertyName
            )]
            [Alias( 'Uri' )]
            [String[]] $articleUri
        )

    Begin {}

    Process {
        foreach ($oneUri in $articleUri) {
            (Invoke-WebRequest -Uri $oneUri).Links |
            Where-Object id -like '*_link' |
            Select-Object @{
                    Name = 'GUID'
                    Expression = { $_.Id -replace '_link', '' }
                },
                @{
                    Name = 'platform'
                    Expression = {
                        if( $_.innerText -match '\b(x86|x64|arm64)\b' ) {
                            $Matches[1].ToLower()
                        }
                    }
                },
                @{
                    Name = 'type'
                    Expression = {
                        if( $_.innerText -match '\b(Cumulative|Delta)\b' ) {
                            $Matches[1].ToLower()
                        }
                    }
                },
                class,
                innerText,
                href
        }
    }

    End {}

}
