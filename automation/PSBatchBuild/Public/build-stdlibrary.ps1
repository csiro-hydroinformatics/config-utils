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

    :iterSln foreach ($solution in $solutions.values)
    {
        foreach ($BuildPlatform in $BuildPlatforms)
        {
            # have yet to find how to pass consoleloggerparameters:ErrorsOnly
            # $msb_params = "/target:$BuildMode /property:Configuration=$BuildConfiguration;Platform=$BuildPlatform /toolsversion:$ToolsVersion /consoleloggerparameters:ErrorsOnly"
            # NOTE: if using /toolsversion, the build fails, because error MSB4019: The imported project "C:\Microsoft.Cpp.Default.props" was not found
            # Specifying these tools version thing may be deprecated after moving to https://github.com/deadlydog/Invoke-MsBuild
            $msb_params = "/target:$BuildMode /property:Configuration=$BuildConfiguration;Platform=$BuildPlatform /consoleloggerparameters:ErrorsOnly"
            $buildResults = Invoke-MSBuild -Path $solution -MsBuildParameters "$msb_params" -LogVerbosity q 
            if ($buildResults.BuildSucceeded -eq $false) {break iterSln} 
        }
    }
}

