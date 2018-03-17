function Find-ArticleUri {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [Array] $Article
    )

    Begin {}

    Process {
        foreach ($oneArticle in $Article) {
            [psCustomObject] @{
                articleId = $oneArticle.articleId

                version = $oneArticle.Text |
                    Select-String -allMatches -pattern '(?x) (\d+ \.){1,3} (\* | \d+)' |
                    ForEach-Object { $_.Matches.Value -as [Version] }

                uri = $script:updateCatalogSearchLink -f $oneArticle.articleId
            }
        }
    }

    End {}
}
