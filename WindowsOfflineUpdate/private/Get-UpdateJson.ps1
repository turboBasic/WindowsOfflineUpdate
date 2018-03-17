function Get-UpdateJson {

    Param( [String] $jsonUri )

    # download JSON with updates
    Write-Verbose "Downloading $jsonUri to retrieve the list of updates"
    Invoke-WebRequest -Uri $jsonUri |
        Select-Object -ExpandProperty Content

}
