function Build-Solutions {

    <#
    .SYNOPSIS
        Build one or more visual studio solution

    .DESCRIPTION
        Build one or more visual studio solution

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
        Get-SEQuestion -Featured -Tag PowerShell -Site StackOverflow -MaxResults 20

        # Get featured questions...
        #    Tagged PowerShell...
        #    From the stackoverflow site
        #    Limited to 20 items

    .FUNCTIONALITY
        MSBuild

    .LINK
        http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module

    .LINK
        Invoke-MSBuild
    #>

    [cmdletbinding()]
    param(
        [Hashtable]$Solutions = @{},
        [string]$BuildConfiguration = 'Release',
        [string[]]$BuildPlatforms = @('x64'),
        [string]$BuildMode = 'Build',
        [string]$ToolsVersion = "14.0"
    )

    $success = [Microsoft.Build.Execution.BuildResultCode]::Success
    :iterSln foreach ($solution in $solutions.values)
    {
        foreach ($BuildPlatform in $BuildPlatforms)
        {
            # have yet to find how to pass consoleloggerparameters:ErrorsOnly
            # public string Parameters { get; set; }
            # Member of Microsoft.Build.Logging.ConsoleLogger
            # Summary:
            # A semi-colon delimited list of "key[=value]" parameter pairs.

            # but using the following still outputs warnings to the console -DefaultLoggerParameters 'consoleloggerparameters=ErrorsOnly'

            $buildResults = Invoke-MSBuild -Project $solution -Target $BuildMode -Verbosity Quiet -DefaultLogger Host -Property @{Configuration=$BuildConfiguration;Platform=$BuildPlatform} -ToolsVersion $ToolsVersion
            if ($buildResults.OverallResult -ne $success) {break iterSln} 
        }
    }
}
