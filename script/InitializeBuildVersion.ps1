#Requires -Version 3
<#
	.SYNOPSIS
	
	Initializes the build version.
#>

[CmdletBinding()]
param(
	[string] $SourcesDirectory = $env:BUILD_SOURCESDIRECTORY,
	[string] $BuildType = $env:CARPENTER_BUILD_TYPE,
	[string] $VersionType = $env:CARPENTER_VERSION_TYPE,
	[string] $VersionFile = $env:CARPENTER_VERSION_VERSIONFILE,
	[string] $RevisionOffset = $env:CARPENTER_VERSION_REVISIONOFFSET,
	[string] $Revision = $env:CARPENTER_VERSION_REVISION,
	[string] $ContinuousIntegrationDate = $env:CARPENTER_CONTINUOUSINTEGRATION_DATE,
	[string] $ContinuousIntegrationRevision = $env:CARPENTER_CONTINUOUSINTEGRATION_REVISION,
	[string] $PullRequestSemantic = $env:CARPENTER_PULLREQUEST_SEMANTIC,
	[string] $PullRequestRevision = $env:CARPENTER_PULLREQUEST_REVISION,
	[string] $PrereleaseLabel = $env:CARPENTER_PRERELEASE_LABEL
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"

$versionType = Set-CarpenterVariable -OutputVariableName "versionType" -Value $VersionType
$versionFile = Set-CarpenterVariable -OutputVariableName "versionFile" -Value $VersionFile
$versionFilePath = Set-CarpenterVariable -OutputVariableName "versionFilePath" -Value "$SourcesDirectory/$versionFile"

If (-Not (Test-Path -Path $versionFilePath -PathType Leaf)) {
	Write-Error "VERSION file does not exist at expected path. Path: $versionFilePath"
} else {
	Write-Verbose "Using version file: $versionFilePath"
	$versionFileContent = Get-Content -Path $versionFilePath
	Write-Verbose "VersionFile: $versionFileContent"
	$targetVersion = [Version]::new($versionFileContent)
	$baseVersion = Set-CarpenterVariable -OutputVariableName "baseVersion" -Value "$($targetVersion.Major).$($targetVersion.Minor).$($targetVersion.Build)"
	$majorVersion = Set-CarpenterVariable -OutputVariableName "majorVersion" -Value $targetVersion.Major
	$minorVersion = Set-CarpenterVariable -OutputVariableName "minorVersion" -Value $targetVersion.Minor
	$patchVersion = Set-CarpenterVariable -OutputVariableName "patchVersion" -Value $targetVersion.Build
}

$revisionOffset = Set-CarpenterVariable -OutputVariableName "revisionOffset" -Value $RevisionOffset
$revision = Set-CarpenterVariable -OutputVariableName "revision" -Value $Revision

If ($BuildType -eq "CI") {
	$continuousIntegrationDate = Set-CarpenterVariable -OutputVariableName "continuousIntegrationDate" -Value $ContinuousIntegrationDate
	$continuousIntegrationRevision = Set-CarpenterVariable -OutputVariableName "continuousIntegrationRevision" -Value $ContinuousIntegrationRevision
}

If ($BuildType -eq "PR") {
	$pullRequestSemantic = Set-CarpenterVariable -OutputVariableName "pullRequestSemantic" -Value $PullRequestSemantic
	$pullRequestRevision = Set-CarpenterVariable -OutputVariableName "pullRequestRevision" -Value $PullRequestRevision
}

If ($BuildType -eq "Prerelease") {
	$prereleaseLabel = Set-CarpenterVariable -OutputVariableName "prereleaseLabel" -Value $PrereleaseLabel
}
