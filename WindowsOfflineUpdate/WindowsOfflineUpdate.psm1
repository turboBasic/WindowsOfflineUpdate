# Module internal variables



# Module initialization

foreach ($subDir in "private", "public")
{
    $currentFunctions = @()

    Get-ChildItem -path (Join-Path -path $PSScriptRoot -childPath $subDir) `
                  -filter *.ps1 -file -recurse |
        ForEach-Object {
            . $_.FullName
            $currentFunctions += $_.BaseName
        }

    # create constants $privateFunctions and $publicFunctions
    New-Variable -Name "${subDir}Functions" -Value $currentFunctions -Scope Script -Option ReadOnly
}

# $privateFunctions: list of all functions in .\private directory
# $publicFunctions:  list of all functions in .\public directory



