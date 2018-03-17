#region Module internal variables

# link to JSON with the list of KB articles with updates
$startKB = 'https://support.microsoft.com/app/content/api/content/asset/en-us/4000816'

$updateCatalogDownloadLink = 'http://www.catalog.update.microsoft.com/DownloadDialog.aspx'
$updateCatalogSearchLink =   'http://www.catalog.update.microsoft.com/Search.aspx?q=KB{0}'

#endregion


foreach ($subDir in "private", "public")
{
    Get-ChildItem -path (Join-Path -path $PSScriptRoot -childPath $subDir) -filter *.ps1 -file -recurse |
        ForEach-Object {  . $_.FullName  }
}



#region Exporting module members

#endregion
