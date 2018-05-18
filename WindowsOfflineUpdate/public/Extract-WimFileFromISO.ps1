function Extract-WimFileFromISO
{
    Param(
        [Parameter( Mandatory )]
        [String] $path,

        [String] $destinationPath = '.',

        [Switch] $installWIM,

        [Switch] $bootWIM
    )



    $arguments = @( 
        'e', 
        "`"$path`"", 
        "-o`"$destinationPath`""  
    )

    if ( $installWIM ) {
        $arguments += 'sources\install.wim'
    }
    if ( $bootWIM ) {
        $arguments += 'sources\boot.wim'
    }

    $result = Start-Process -filePath 7z -argumentList $arguments -wait -passThru
    
}