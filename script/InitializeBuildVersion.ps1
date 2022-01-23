#Requires -Version 3
<#
	.SYNOPSIS
	
	Initializes the build version.
#>

[CmdletBinding()]
param(
	[string] $SourcesDirectory = $env:BUILD_SOURCESDIRECTORY,
	[string] $VersionFile = $env:CARPENTER_VERSION_VERSIONFILE,
	[string] $BuildType = $env:CARPENTER_BUILD_TYPE,
	[string] $ContinuousIntegrationDate = $env:CARPENTER_CONTINUOUSINTEGRATION_DATE,
	[string] $ContinuousIntegrationRevision = $env:CARPENTER_CONTINUOUSINTEGRATION_REVISION,
	[string] $PullRequestNumber = $env:SYSTEM_PULLREQUEST_PULLREQUESTNUMBER,
	[string] $PullRequestRevision = $env:CARPENTER_PULLREQUEST_REVISION,
	[string] $PrereleaseLabel = $env:CARPENTER_PRERELEASE_LABEL,
	[string] $PrereleaseRevision = $env:CARPENTER_PRERELEASE_REVISION
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"

$versionFilePath = "$SourcesDirectory/$VersionFile"
If (-Not (Test-Path -Path $versionFilePath -PathType Leaf)) {
	Write-Error "VERSION file does not exist at expected path. Path: $versionFilePath"
} else {
	Write-Verbose "Using version file: $versionFilePath"
	$versionFileContent = Get-Content -Path $versionFilePath
	Write-Verbose "VersionFile: $versionFileContent"
	$targetVersion = [Version]::new($versionFileContent)
	$baseVersion = Set-CarpenterVariable -VariableName "Carpenter.Version.BaseVersion" -Value "$($targetVersion.Major).$($targetVersion.Minor).$($targetVersion.Build)"
	$majorVersion = Set-CarpenterVariable -VariableName "Carpenter.Version.Major" -Value $targetVersion.Major
	$minorVersion = Set-CarpenterVariable -VariableName "Carpenter.Version.Minor" -Value $targetVersion.Minor
	$patchVersion = Set-CarpenterVariable -VariableName "Carpenter.Version.Patch" -Value $targetVersion.Build
	if ($BuildType -eq "CI") {
		$versionLabel = Set-CarpenterVariable -VariableName Carpenter.Version.Label -Value "CI.$($ContinuousIntegrationDate).$($ContinuousIntegrationRevision)"
	}
	if ($BuildType -eq "PR") {
		$versionLabel = Set-CarpenterVariable -VariableName Carpenter.Version.Label -Value "PR.$($PullRequestNumber).$($PullRequestRevision)"
	}
	if ($BuildType -eq "Prerelease") {
		$versionLabel = Set-CarpenterVariable -VariableName Carpenter.Version.Label -Value "$($PrereleaseLabel).$($PrereleaseRevision)"
	}
    $version = Set-CarpenterVariable -VariableName "Carpenter.Version" -Value "$($baseVersion)-$($versionLabel)"
	Write-Host "##vso[build.updatebuildnumber]$version"
}

