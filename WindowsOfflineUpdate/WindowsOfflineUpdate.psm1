#region Module internal variables

#endregion


foreach ($subDir in "private", "public")
{
    Get-ChildItem -path (Join-Path -path $PSScriptRoot -childPath $subDir) -filter *.ps1 -file -recurse |
        ForEach-Object {  . $_.FullName  }
}



#region Exporting module members

#endregion
