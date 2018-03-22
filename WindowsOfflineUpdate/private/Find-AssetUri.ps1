function Find-AssetUri {
<#
    Get Uri of Microsoft download asset specified by its GUID
#>
    [CmdletBinding()]
    Param(
        [String[]]
            [Parameter(
                Mandatory,
                Position = 0,
                ValueFromPipeline,
                ValueFromPipelineByPropertyName,
                HelpMessage = "GUID of Microsoft download asset."
            )]
            [Alias( 'Id' )]
        $GUID
    )

    Begin {
        $updateCatalogDownloadLink = 'http://www.catalog.update.microsoft.com/DownloadDialog.aspx'

        $assetUriPattern =  "https?://download\.windowsupdate\.com\/[^ \'\""]+"
        $postBodyTemplate = '"size": 0,  "uidInfo": "{0}",  "updateID": "{0}"' -replace ' ', ''
    }

    Process {
        foreach ($oneGUID in $GUID) {
            Write-Verbose "Download description of asset $oneGUID"
            $postBody = @{ updateIDs = "[{$( $postBodyTemplate -f $oneGUID )}]" }

            if (    ( Invoke-WebRequest -Uri $updateCatalogDownloadLink -Method Post -Body $postBody
                    ).Content -match $assetUriPattern
            ) {
                $Matches[0]
            }
        }
    }

    End {}
}
