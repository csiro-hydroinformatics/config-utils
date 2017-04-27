function Build-Library {

    <#
    .SYNOPSIS
        Copies the build output of a typical compilation

    .DESCRIPTION
        Copies the build output of a typical compilation

    .PARAMETER Solutions
        Hashtable, string to path to the solution file

    .PARAMETER BuildConfiguration
        Build configuration. Defaults to Release

    .PARAMETER BuildPlatforms
        Build platform. Default 'x64'

    .PARAMETER LibNames
        string[]. short file names without extension of the build output 

    .PARAMETER LibDir
        string. Root folder under which the binary outputs will be copied to. 

    .EXAMPLE
        TODO

    .LINK
        http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module

    #>

    [cmdletbinding()]
    param(
        [string]$BuildConfiguration = 'Release',
        [Hashtable]$Solutions = @{},
        [string[]]$BuildPlatforms = @(),
        [string[]]$LibNames = @(),
        [string]$LibDir = "."
    )

    :iterSln foreach ($libname in $LibNames)
    {
        if(!$Solutions.Contains($libname)) {
            echo ('Solution for libname not found: ' + $libname)
            break iterSln
        } 
        $solution=$Solutions[$libname]
        $slnFile = New-Object -TypeName "System.IO.FileInfo" -ArgumentList $solution
        $slnDir = $slnFile.Directory
        foreach ($buildPlatform in $BuildPlatforms)
        {
            $todir = $LibDir + "\" + $archTable[$buildPlatform]
            $BuildOutputDir=$slnDir.FullName + "\" + $buildPlatform + "\" + $BuildConfiguration
            Copy-BuildOutput -FromDir $BuildOutputDir -ToDir $todir -FnNoExt $libname
        }
    }
}

