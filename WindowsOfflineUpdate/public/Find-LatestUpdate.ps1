function Find-LatestUpdate {
<#

    .SYNOPSIS
Finds the latest delta or cumulative update for Windows or Windows Server operating system


    .DESCRIPTION
This script will return the list of Cumulative updates for Windows 10 and Windows Server 2016 from the Microsoft Update Catalog.


    .PARAMETER Build
Windows 10 Build Number used to filter avaible Downloads

    10240 - Windows 10 Version 1507
    10586 - Windows 10 Version 1511
    14393 - Windows 10 Version 1607 and Windows Server 2016
    15063 - Windows 10 Version 1703
    16299 - WIndows 10 Version 1709


    .PARAMETER Filter
Search filter for updates. The default filter will find Cumulative updates for x86 and x64 platforms.

If multiple strings are specified, only update that match *ALL* strings will be found.

    Cumulative: find only Cumulative updates
    Delta:  find only Delta updates
    x86:    find only updates for x86 platform
    x64:    find only updates for x64 platform


    .NOTES
Copyright Keith Garner (KeithGa@DeploymentLive.com), All rights reserved.

Contributors:
    Andriy Melnyk (mao@bebee.xyz)


    .LINK
https://support.microsoft.com/en-us/help/4000823


    .EXAMPLE
Get link to the latest Cumulative update for Windows 10, both for x86 and x64 platforms

    Find-LatestUpdate -verbose


    .EXAMPLE
Get link to the latest Cumulative update for Windows 10 x86

    Find-LatestUpdate -filter Cumulative, x86


    .EXAMPLE
Get the latest Cumulative Update for Windows Server 2016

    Find-LatestUpdate -filter Cumulative, x64 -build 14393


    .EXAMPLE
Get the latest Cumulative Updates for Windows 10 (both x86 and x64) and download to the %TEMP% directory.

    Find-LatestUpdate | %{ Start-BitsTransfer -Source $_ -Destination $ENV:Temp }

#>

    [CmdletBinding()]
    Param(
        [String]
            [Parameter( HelpMessage = "Windows build number." )]
            [ValidateSet( '16299', '15063', '14393', '10586', '10240' )]
        $Build = '16299',

        [String[]]
            [Parameter( HelpMessage = "Windows update Catalog Search Filter." )]
            [ValidateSet( 'x64', 'x86', 'Cumulative', 'Delta', $null )]
        $Filter = @( "Cumulative", "x64" )
    )


    # link to JSON with the list of KB articles with updates
    $startKB = 'https://support.microsoft.com/app/content/api/content/asset/en-us/4000816'


    # download JSON with updates
    Write-Verbose "Downloading $startKB to retrieve the list of updates"
    $updates = Invoke-WebRequest -Uri $startKB |
        Select-Object -ExpandProperty Content


    # Get list of all articles related to the requested build
    $articles = Find-KBArticleWithUpdate -source $updates -build $Build -verbose


    # Extract urls from the list of Article objects and select the latest one
    $kbId = Find-ArticleUri -article $articles |
        Sort-Object -Property Version -Descending |
        Select-Object -First 1


    # Get the article's content
    Write-Verbose "Found article: KB$( $kbId.articleId ), $( $kbId.Uri )"
    $kbContent = Invoke-WebRequest -Uri $kbId.Uri


    # Get html element IDs of buttons labeled as 'Download'
    $elementIDs = $kbContent.InputFields |
        Where-Object { $_.Type -eq 'Button' -and $_.Value -eq 'Download' } |
        Select-Object -ExpandProperty ID


    # Get GUIDs of assets which match all patterns in $Filter argument
    $kbGUIDs = $kbContent.Links |
        Where-Object ID -match '_link' |
        Where-Object { $_.OuterHTML -match ($Filter -join '.*') } |
        ForEach-Object { $_.Id.Replace('_link','') } |
        Where-Object { $_ -in $elementIDs }



    # Get direct download links for all GUIDs of assets and
    $kbGUIDs |
        Find-AssetUri |
        Select-Object -Unique


    <#
        ForEach-Object {
            [psCustomObject] @{ Source = $_ }
        }
    #>

}
