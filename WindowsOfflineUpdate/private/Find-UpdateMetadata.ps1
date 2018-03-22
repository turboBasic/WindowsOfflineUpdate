function Find-UpdateMetadata {
    <#
        Get metadata for all updates/all builds
    #>
        [CmdletBinding()]
        Param()

    Begin {
        # link to JSON with the list of KB articles with updates
        $startKBarticle = 'https://support.microsoft.com/app/content/api/content/asset/en-us/4000816'
    }

    Process {
        (   (Invoke-WebRequest -Uri $startKBarticle).Content |
            ConvertFrom-Json
        ).Links |
        Select-Object `
            articleId,
            Text,
            @{  Name = 'Version'
                Expression = {
                    ($_.Text -replace '(?x) ^.* Builds? \s+ ([.0-9]+) .* $', '$1') -as [Version]
            }
        } |
        Where-Object Version
    }

    End {}

}
