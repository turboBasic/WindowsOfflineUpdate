function Find-AssetUri {
<#
    Get uri of Microsoft download asset specified by its GUID
#>
    [CmdletBinding()]
    Param(
        [String]
            [Parameter(
                Mandatory,
                ValueFromPipeline,
                HelpMessage = "GUID of Microsoft download asset."
            )]
        $GUID
    )

    BEGIN {
        $updateCatalogDownloadLink = 'http://www.catalog.update.microsoft.com/DownloadDialog.aspx'

        $assetUriPattern =  "https?://download\.windowsupdate\.com\/[^ \'\""]+"
        $postBodyTemplate = '"size": 0,  "uidInfo": "{0}",  "updateID": "{0}"' -replace ' ', ''
    }

    PROCESS {
        $postBody = @{ updateIDs = "[{$( $postBodyTemplate -f $GUID )}]" }

        Write-Verbose "Download description of asset $GUID"
        if ( ( Invoke-WebRequest -Uri $updateCatalogDownloadLink -Method Post -Body $postBody
             ).Content -match $assetUriPattern
        ) {
            $Matches[0]
        }
    }

    END {}
}
