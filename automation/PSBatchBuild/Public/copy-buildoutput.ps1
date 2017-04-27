function Copy-BuildOutput {

    <#
    .SYNOPSIS
        Copies the build output of a typical compilation

    .DESCRIPTION
        Copies the build output of a typical compilation

    .PARAMETER FromDir
        string. From directory

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
        [string]$FromDir = '.',
        [string]$ToDir = '.',
        [string]$FnNoExt = "my_lib_name"
    )

    #$FromDir=$BuildOutputDir
    cp -Path ($FromDir + "/" + $FnNoExt + ".dll") -Destination $ToDir
    cp -Path ($FromDir + "/" + $FnNoExt + ".lib") -Destination $ToDir
    $pdb = $FromDir + "/" + $FnNoExt + ".pdb"
    if (Test-Path -Path $pdb) {
        cp -Path ($pdb) -Destination $ToDir
    }
}

