function Copy-HeaderFiles {

    <#
    .SYNOPSIS
        Copies C++ header files

    .DESCRIPTION
        Copies C++ header files

    .PARAMETER HeaderDirectories
        hashtable. lib name to paths to header locations.

    .PARAMETER ToDir
        string. Receiving directory

    .PARAMETER FnNoExt
        string short file name without extension of the build output 

    .EXAMPLE
        TODO

    .LINK
        http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module

    #>

    [cmdletbinding()]
    param(
        [Hashtable]$HeaderDirectories = @{},
        [string]$ToDir = '.'
    )
    foreach ($hd in $HeaderDirectories.values) 
    {
        cp -Path $hd -Destination $ToDir -Recurse -Force 
    }
}

