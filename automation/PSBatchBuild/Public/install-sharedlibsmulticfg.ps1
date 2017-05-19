function Install-SharedLibsMultiCfg
{

    <#
    .SYNOPSIS
        Batch build combinations of solutions/buildconfigurations/platforms and copy outputs to different library locations 

    .DESCRIPTION
        High level function to batch build and deploy dlls. The end result is e.g. DLLs under c:\lib\64, c:\lib\32, c:\libdev\64, c:\libdev\32

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

    .PARAMETER LibsDirs
        string[]. Root folders under which the binary outputs will be copied to. 

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
        [Hashtable]$LibsDirs = @{},
        [string[]]$BuildPlatforms = @(),
        [string]$BuildMode = 'Build',
        [string[]]$LibNames = @(),
        [Hashtable]$ArchTable = @{x64 = '64';Win32 = '32'},
        [string]$ToolsVersion = "14.0"
    )
    foreach ($cfg in $LibsDirs.keys)
    {
        # echo ("Install-SharedLibsMultiCfg cfg="+$cfg)
        Install-SharedLibs -Solutions $Solutions -BuildConfiguration $cfg -BuildPlatforms $BuildPlatforms -BuildMode $BuildMode -ToolsVersion $ToolsVersion -LibNames $LibNames -LibDir $LibsDirs[$cfg]  -ArchTable $ArchTable
    }
}
