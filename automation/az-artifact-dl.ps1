<#
.SYNOPSIS
    Downloads Azure DevOps universal package artifacts, with version-aware caching.

.DESCRIPTION
    PowerShell equivalent of az-artifact-dl.sh. Downloads a universal package from
    an Azure DevOps feed, but only if the remote version is newer than the version
    currently on disk. Requires the Azure CLI with the azure-devops extension.

    If az login or az devops login haven't been used, all az devops commands will try
    to sign in using a PAT stored in the AZURE_DEVOPS_EXT_PAT environment variable.

.PARAMETER OutputDirectory
    Root directory for downloads and version tracking.

.PARAMETER ArtifactName
    Name of the universal package artifact (e.g. swift_deb).

.PARAMETER ArtifactVersionName
    Name of the version-tracking artifact (e.g. swift_deb_version).

.PARAMETER FeedName
    Azure DevOps artifacts feed name (e.g. hydro_forecast_deb).

.PARAMETER OrgName
    Azure DevOps organization URL.

.PARAMETER ProjectName
    Azure DevOps project name.

.EXAMPLE
    .\az-artifact-dl.ps1 -OutputDirectory C:\tmp\blah_setup -ArtifactName blah_debian `
        -ArtifactVersionName blah_debian_version -FeedName debian_feed_name `
        -OrgName my_org_name -ProjectName blah_project
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$OutputDirectory,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$ArtifactName,

    [Parameter(Mandatory = $true, Position = 2)]
    [string]$ArtifactVersionName,

    [Parameter(Mandatory = $true, Position = 3)]
    [string]$FeedName,

    [Parameter(Mandatory = $true, Position = 4)]
    [string]$OrgName,

    [Parameter(Mandatory = $true, Position = 5)]
    [string]$ProjectName
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Check for AZURE_DEVOPS_EXT_PAT
# ---------------------------------------------------------------------------
if ([string]::IsNullOrEmpty($env:AZURE_DEVOPS_EXT_PAT)) {
    Write-Error "ERROR: env variable AZURE_DEVOPS_EXT_PAT must be defined"
    exit 1
}
else {
    Write-Host "INFO: variable AZURE_DEVOPS_EXT_PAT already defined"
}

# ---------------------------------------------------------------------------
# Directory setup
# ---------------------------------------------------------------------------
$currentVersionDir = Join-Path $OutputDirectory 'setup_version_current'
$setupVersionDir   = Join-Path $OutputDirectory 'setup_version'
$versionDir        = Join-Path $OutputDirectory 'version' 'latest'

foreach ($dir in @($currentVersionDir, $setupVersionDir, $versionDir)) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

$currentVersionFile = Join-Path $currentVersionDir 'version.txt'
if (-not (Test-Path $currentVersionFile)) {
    Set-Content -Path $currentVersionFile -Value '0.0.1' -NoNewline
}

# ---------------------------------------------------------------------------
# Version comparison
# Replicates the vercomp() function from the bash script.
# Returns: 0 if equal, 1 if $Ver1 > $Ver2, 2 if $Ver1 < $Ver2
# ---------------------------------------------------------------------------
function Compare-VersionStrings {
    param(
        [string]$Ver1,
        [string]$Ver2
    )

    if ($Ver1 -eq $Ver2) { return 0 }

    $parts1 = $Ver1.Split('.')
    $parts2 = $Ver2.Split('.')

    $maxLen = [Math]::Max($parts1.Length, $parts2.Length)

    for ($i = 0; $i -lt $maxLen; $i++) {
        $v1 = if ($i -lt $parts1.Length) { [int]$parts1[$i] } else { 0 }
        $v2 = if ($i -lt $parts2.Length) { [int]$parts2[$i] } else { 0 }

        if ($v1 -gt $v2) { return 1 }
        if ($v1 -lt $v2) { return 2 }
    }

    return 0
}

# ---------------------------------------------------------------------------
# Download helpers
# ---------------------------------------------------------------------------
function Get-VersionArtifact {
    az artifacts universal download `
        --organization $OrgName `
        --scope project `
        --project $ProjectName `
        --feed $FeedName `
        --name $ArtifactVersionName `
        --version '*' `
        --path $setupVersionDir

    if ($LASTEXITCODE -ne 0) {
        Write-Error "FAILED: setup_version download"
        return $false
    }
    return $true
}

function Get-SetupArtifact {
    az artifacts universal download `
        --organization $OrgName `
        --scope project `
        --project $ProjectName `
        --feed $FeedName `
        --name $ArtifactName `
        --version '*' `
        --path $versionDir

    if ($LASTEXITCODE -ne 0) {
        Write-Error "FAILED: version download"
        return $false
    }
    return $true
}

# ---------------------------------------------------------------------------
# Main logic
# ---------------------------------------------------------------------------

# 1. Download the version artifact
if (-not (Get-VersionArtifact)) {
    exit 1
}

# 2. Read and sanitise version strings
#    Work around for https://github.com/csiro-hydroinformatics/config-utils/issues/2
#    (remove carriage returns and spaces)
$currentVer = (Get-Content -Path $currentVersionFile -Raw).Trim("`r", "`n", ' ')
$newVer     = (Get-Content -Path (Join-Path $setupVersionDir 'version.txt') -Raw).Trim("`r", "`n", ' ')

# 3. Compare versions and act accordingly
$cmp = Compare-VersionStrings -Ver1 $currentVer -Ver2 $newVer

switch ($cmp) {
    0 {
        Write-Host "Version number on disk ${currentVer} is already the remote version ${newVer}"
        Write-Host "Stopping the download and exiting"
        # exit 0
    }
    1 {
        Write-Host "Version number on disk ${currentVer} is newer than the remote version ${newVer}!"
        Write-Host "Stopping the download and exiting"
        # exit 0
    }
    2 {
        Write-Host "Version number on disk ${currentVer} is older than the remote version ${newVer}!"
        Write-Host "Downloading..."

        # Clean up existing files in the version directory
        $existingFiles = Get-ChildItem -Path $versionDir -File -ErrorAction SilentlyContinue
        if ($existingFiles) {
            $existingFiles | Remove-Item -Force
        }

        if (-not (Get-SetupArtifact)) {
            Write-Error "Download of version ${newVer} failed!"
            exit 1
        }

        Write-Host "Download of version ${newVer} complete."
        # Update the current version marker
        Set-Content -Path $currentVersionFile -Value $newVer -NoNewline
        exit 0
    }
}
