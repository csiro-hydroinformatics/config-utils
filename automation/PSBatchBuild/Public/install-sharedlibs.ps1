
function Install-SharedLibs
{

    <#
    .SYNOPSIS
        Build one or more solutions and copy outputs to a DLL library location 

    .DESCRIPTION
        Build one or more solutions and copy outputs to a DLL library location 

    .PARAMETER Solutions
        Hashtable, string to path to the solution file

    .PARAMETER BuildConfiguration
        Build configuration. Defaults to Release

    .PARAMETER BuildPlatforms
        Build platform. Default 'x64'

    .PARAMETER BuildMode
        Build mode. Default 'Build'

    .PARAMETER LibNames
        string[]. short file names without extension of the build output 

    .PARAMETER LibDir
        string. Root folder under which the binary outputs will be copied to. 

    .PARAMETER ToolsVersion
        MSBuild version. Default '14.0'

    .EXAMPLE
        TODO

    .LINK
        http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module

    #>

    [cmdletbinding()]
    param(
        [Hashtable]$Solutions = @{},
        [string]$BuildConfiguration = 'Release',
        [string[]]$BuildPlatforms = @(),
        [string]$BuildMode = 'Build',
        [string[]]$LibNames = @(),
        [string]$LibDir = ".",
        [string]$ToolsVersion = "14.0"
    )
    Build-Solutions -Solutions $Solutions -BuildConfiguration $BuildConfiguration -BuildPlatforms $BuildPlatforms -BuildMode $BuildMode -ToolsVersion $ToolsVersion
    Build-Library  -Solutions $Solutions -BuildConfiguration $BuildConfiguration -BuildPlatforms $BuildPlatforms -LibNames $LibNames -LibDir $LibDir
}

