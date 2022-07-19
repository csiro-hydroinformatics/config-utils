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

    :iterSln foreach ($solution in $solutions.values)
    {
        foreach ($BuildPlatform in $BuildPlatforms)
        {
            # have yet to find how to pass consoleloggerparameters:ErrorsOnly
            # public string Parameters { get; set; }
            # Member of Microsoft.Build.Logging.ConsoleLogger
            # Summary:
            # A semi-colon delimited list of "key[=value]" parameter pairs.
            # $msb_params = "/target:$BuildMode /property:Configuration=$BuildConfiguration;Platform=$BuildPlatform /toolsversion:$ToolsVersion /consoleloggerparameters:ErrorsOnly"
            # NOTE: if using /toolsversion, the build fails, because error MSB4019: The imported project "C:\Microsoft.Cpp.Default.props" was not found
            # Specifying these tools version thing may be deprecated after moving to https://github.com/deadlydog/Invoke-MsBuild
            $msb_params = "/target:$BuildMode /property:Configuration=$BuildConfiguration;Platform=$BuildPlatform /consoleloggerparameters:ErrorsOnly"
            $msb_params = "/target:$BuildMode /property:Configuration=$BuildConfiguration;Platform=$BuildPlatform"
            $blah = "Invoke-MSBuild -Path $solution -MsBuildParameters '$msb_params' -LogVerbosity d"
            echo ($blah)
            $buildResults = Invoke-MSBuild -Path $solution -MsBuildParameters "$msb_params" -LogVerbosity d
            if ($buildResults.BuildSucceeded -eq $false) 
            {
                $exitCode = $?

                # Write-Error -Message $buildResult.Message

                Get-Content -Path $buildResult.BuildErrorsLogFilePath

                Get-Content -Path $buildResult.BuildLogFilePath

                exit $exitCode
                # TODO: used to be the case, but probably not the best option for most use cases
                # break iterSln 
            }
            elseif ($buildResult.BuildSucceeded -eq $true)
            {
                Write-Output ("Build completed successfully in {0:N1} seconds." -f $buildResult.BuildDuration.TotalSeconds)
            }
            elseif ($null -eq $buildResult.BuildSucceeded)
            {
                Write-Output "Unsure if build passed or failed: $($buildResult.Message)"
            }
        }
    }
}
