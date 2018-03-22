function Find-ArticleUri {

    [CmdletBinding()]
        Param(
            [Parameter(
                HelpMessage = "Microsoft KnowledgeBase (KB) article Id.",
                Mandatory,
                Position = 0,
                ValueFromPipeline,
                ValueFromPipelineByPropertyName
            )]
            [Alias( 'id', 'KBId' )]
            [String[]] $articleId
        )

    Begin {
        # Endpoint for searching article by its ID
        $updateCatalogSearchLink =   'http://www.catalog.update.microsoft.com/Search.aspx?q=KB{0}'
    }

    Process {
        foreach ($id in $articleId) {
            $updateCatalogSearchLink -f $id
        }
    }

    End {}

}
