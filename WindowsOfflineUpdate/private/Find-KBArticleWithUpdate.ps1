function Find-KBArticleWithUpdate {

    [CmdletBinding()]
    Param(
        [Parameter( Mandatory ) ]
        [String]
        $source,         # JSON with the list of all available updates

        [Parameter( Mandatory ) ]
        [String]
        $Build
    )


    $source |
    ConvertFrom-Json |
    Select-Object -ExpandProperty Links |
    Where-Object Level -eq 2 |
    Where-Object Text -match $Build
}
