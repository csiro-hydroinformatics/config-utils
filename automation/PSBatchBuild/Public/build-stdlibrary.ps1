function Build-StdLibrary {

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

    .PARAMETER BuildMode
        Build mode. Default 'Build'

    .PARAMETER ToolsVersion
        MSBuild version. Default '14.0'

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
        [string]$BuildMode = 'Build',
        [string]$ToolsVersion = "14.0"
    )

    $success = [Microsoft.Build.Execution.BuildResultCode]::Success
    :iterSln foreach ($solution in $solutions.values)
    {
        foreach ($BuildPlatform in $BuildPlatforms)
        {
            # have yet to find how to pass consoleloggerparameters:ErrorsOnly
            $buildResults = Invoke-MSBuild -Project $solution -Target $BuildMode -Verbosity Quiet -DefaultLogger Host -Property @{Configuration=$BuildConfiguration;Platform=$BuildPlatform} -ToolsVersion $ToolsVersion
            if ($buildResults.OverallResult -ne $success) {break iterSln} 
        }
    }
}

