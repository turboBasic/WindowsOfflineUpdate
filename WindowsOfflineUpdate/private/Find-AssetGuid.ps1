function Find-AssetGuid {
    <#
        Find GUIDs of all asset types for selected Build update
    #>
        [CmdletBinding()]
        Param(
            [Parameter( Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName )]
            [String] $article
        )

    Begin {
        # Endpoint for searching article by its ID
        $updateCatalogSearchLink =   'http://www.catalog.update.microsoft.com/Search.aspx?q=KB{0}'
    }

    Process {
        $articleUri = $updateCatalogSearchLink -f $article

        (Invoke-WebRequest -Uri $articleUri).Links |
            Where-Object id -like '*_link' |
            Select-Object id, class, innerText, href |
            ForEach-Object {
                $_.Id = $_.Id -replace '_link', ''
                $_
            }
    }

    End {}

}
