function Find-LatestUpdate {
<#

    .SYNOPSIS
Finds the latest delta or cumulative update for Windows or Windows Server operating system


    .DESCRIPTION
This script will return the list of links to updates for Windows 10 and Windows Server 2016 from the Microsoft Update Catalog.


    .PARAMETER Build
Windows 10 Build Number used to filter available Downloads

    10240 - Windows 10 Version 1507
    10586 - Windows 10 Version 1511
    14393 - Windows 10 Version 1607 and Windows Server 2016
    15063 - Windows 10 Version 1703
    16299 - WIndows 10 Version 1709


    .PARAMETER Platform
Windows hardware platform to select updates for.  Parameter can take the following values:

    x64         (default value)
    x86
    arm64


    .PARAMETER Type
Update type. Parameter can take the following values:

    Cumulative  (dafault)
    Delta


    .NOTES
Copyright Keith Garner (KeithGa@DeploymentLive.com), All rights reserved.
Copyright Andriy Melnyk (mao@bebee.xyz), all rights reserved


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


    .EXAMPLE
Get the latest cumulative update for x64 platform
    Find-LatestUpdate -build 16299 | ? { ($_.Platform -eq x64) -and ($_.Type -eq Cumulative) }

#>

    [CmdletBinding()]
    Param(
        [String]
            [Parameter(
                HelpMessage = "Windows build number.",
                Position = 0
            )]
            [ValidateSet( '16299', '15063', '14393', '10586', '10240' )]
        $Build = '16299',

        [String]
            [Parameter(
                HelpMessage = "Hardware platform.",
                Position = 1
            )]
            [ValidateSet( 'x64', 'x86', 'arm64' )]
        $Platform = 'x64',

        [String]
            [Parameter(
                HelpMessage = "Update type (Cumulative or Delta).",
                Position = 2
            )]
            [ValidateSet( 'Cumulative', 'Delta' )]
        $Type = 'Cumulative'
    )

    Begin {}

    Process {
        # Find KB article for the latest update for selected build
        $article = Find-UpdateMetadata |
            Where-Object { $_.Version.Major -eq $Build } |
            Sort-Object Version |
            Select-Object -Last 1
        Write-Verbose "Found article: KB$( $article.articleId )"

        $article |
            Find-ArticleUri |
            Find-AssetGuid |
            Where-Object {
                ($_.Platform -eq $Platform) -and
                ($_.Type -eq $Type)
            } |
            Find-AssetUri |
            Select-Object -Unique
    }

    End {}
}
