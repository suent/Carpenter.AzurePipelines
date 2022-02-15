#Requires -Version 3
<#
	.SYNOPSIS
	
	Initializes the build version.
#>

[CmdletBinding()]
param(
	[string] $BuildDirectory = $env:AGENT_BUILDDIRECTORY,
	[string] $DefinitionName = $env:BUILD_DEFINITIONNAME,
	[string] $BuildType = $env:CARPENTER_BUILD_TYPE,
	[string] $Project = $env:CARPENTER_PROJECT,
	[string] $ProjectDirectory = $env:CARPENTER_PROJECT_PATH,
	[string] $VersionType = $env:CARPENTER_VERSION_TYPE,
	[string] $VersionFile = $env:CARPENTER_VERSION_VERSIONFILE,
	[string] $RevisionOffset = $env:CARPENTER_VERSION_REVISIONOFFSET,
	[string] $ContinuousIntegrationDate = $env:CARPENTER_CONTINUOUSINTEGRATION_DATE,
	[string] $PullRequestSemantic = $env:CARPENTER_PULLREQUEST_SEMANTIC,
	[string] $PullRequestRevision = $env:CARPENTER_PULLREQUEST_REVISION,
	[string] $PrereleaseLabel = $env:CARPENTER_PRERELEASE_LABEL,
	[string] $IncrementVersionOnRelease = $env:CARPENTER_VERSION_INCREMENTONRELEASE
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"

$versionFile = Set-CarpenterVariable -VariableName "Carpenter.Version.VersionFile" -OutputVariableName "versionFile" -Value $VersionFile
$versionFilePath = Set-CarpenterVariable -VariableName "Carpenter.Version.VersionFilePath" -OutputVariableName "versionFilePath" -Value "$BuildDirectory/$ProjectDirectory/$versionFile"

If (-Not (Test-Path -Path $versionFilePath -PathType Leaf)) {
	Write-PipelineError "VERSION file does not exist at expected path. Path: $versionFilePath"
} else {
	$versionFileContent = Get-Content -Path $versionFilePath
	$targetVersion = [Version]::new($versionFileContent)
	$baseVersion = Set-CarpenterVariable -VariableName "Carpenter.Version.BaseVersion" -OutputVariableName "baseVersion" -Value "$($targetVersion.Major).$($targetVersion.Minor).$($targetVersion.Build)"
	$majorVersion = Set-CarpenterVariable -VariableName "Carpenter.Version.Major" -OutputVariableName "majorVersion" -Value $targetVersion.Major
	$minorVersion = Set-CarpenterVariable -VariableName "Carpenter.Version.Minor" -OutputVariableName "minorVersion" -Value $targetVersion.Minor
	$patchVersion = Set-CarpenterVariable -VariableName "Carpenter.Version.Patch" -OutputVariableName "patchVersion" -Value $targetVersion.Build
}

$revisionOffset = Set-CarpenterVariable -VariableName "Carpenter.Version.RevisionOffset" -OutputVariableName "revisionOffset" -Value $RevisionOffset
$revisionKey = "suent_carpenter_$($DefinitionName)_$($Project)_revision"
$revision = Get-NextCounterValue -Key $revisionKey -Offset $revisionOffset
$revision = Set-CarpenterVariable -VariableName "Carpenter.Version.Revision" -OutputVariableName "revision" -Value $revision

If ($BuildType -eq "CI") {
	$continuousIntegrationDate = Set-CarpenterVariable -OutputVariableName "continuousIntegrationDate" -Value $ContinuousIntegrationDate
	$continuousIntegrationRevisionKey = "suent_carpenter_$($DefinitionName)_$($Project)_CI_$($continuousIntegrationDate)"
	$continuousIntegrationRevision = Get-NextCounterValue -Key $continuousIntegrationRevisionKey
	$continuousIntegrationRevision = Set-CarpenterVariable -OutputVariableName "continuousIntegrationRevision" -Value $continuousIntegrationRevision
}

If ($BuildType -eq "PR") {
	$pullRequestSemantic = Set-CarpenterVariable -OutputVariableName "pullRequestSemantic" -Value $PullRequestSemantic
	$pullRequestRevision = Set-CarpenterVariable -OutputVariableName "pullRequestRevision" -Value $PullRequestRevision
}

If ($BuildType -eq "Prerelease") {
	$prereleaseLabel = Set-CarpenterVariable -OutputVariableName "prereleaseLabel" -Value $PrereleaseLabel
}

If ($BuildType -eq "Release") {
	$versionType = Set-CarpenterVariable -OutputVariableName "incrementVersionOnRelease" -Value $IncrementVersionOnRelease
}
