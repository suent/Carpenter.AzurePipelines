#Requires -Version 3
<#
	.SYNOPSIS
	
	Initializes the build version.
#>

[CmdletBinding()]
param(
	[string] $DefinitionName = $env:BUILD_DEFINITIONNAME,
	[string] $BuildPurpose = $env:CARPENTER_BUILD_PURPOSE,
	[string] $Project = $env:CARPENTER_PROJECT,
	[string] $ProjectDirectory = $env:CARPENTER_PROJECT_PATH,
	[string] $VersionType = $env:CARPENTER_VERSION_TYPE,
	[string] $VersionFile = $env:CARPENTER_VERSION_VERSIONFILE,
	[string] $RevisionOffset = $env:CARPENTER_VERSION_REVISIONOFFSET,
	[string] $ContinuousIntegrationDate = $env:CARPENTER_CONTINUOUSINTEGRATION_DATE,
	[string] $PullRequestNumber = $env:SYSTEM_PULLREQUEST_PULLREQUESTNUMBER,
	[string] $PrereleaseLabel = $env:CARPENTER_PRERELEASE_LABEL,
	[string] $IncrementVersionOnRelease = $env:CARPENTER_VERSION_INCREMENTONRELEASE
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"

$versionFile = Set-CarpenterVariable -VariableName "Carpenter.Version.VersionFile" -OutputVariableName "versionFile" -Value $VersionFile
$versionFilePath = Set-CarpenterVariable -VariableName "Carpenter.Version.VersionFilePath" -OutputVariableName "versionFilePath" -Value "$ProjectDirectory/$versionFile"

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

If ($BuildPurpose -eq "CI") {
	$continuousIntegrationDate = Set-CarpenterVariable -VariableName "Carpenter.ContinuousIntegration.Date" -OutputVariableName "continuousIntegrationDate" -Value $ContinuousIntegrationDate
	$continuousIntegrationRevisionKey = "suent_carpenter_$($DefinitionName)_$($Project)_CI_$($continuousIntegrationDate)"
	$continuousIntegrationRevision = Get-NextCounterValue -Key $continuousIntegrationRevisionKey
	$continuousIntegrationRevision = Set-CarpenterVariable -VariableName "Carpenter.ContinuousIntegration.Revision" -OutputVariableName "continuousIntegrationRevision" -Value $continuousIntegrationRevision
	$versionLabel = Set-CarpenterVariable -VariableName "Carpenter.Version.Label" -OutputVariableName "versionLabel" -Value "CI.$($continuousIntegrationDate).$($continuousIntegrationRevision)"
}

If ($BuildPurpose -eq "PR") {
	$pullRequestRevisionKey = "suent_carpenter_$($DefinitionName)_$($Project)_PR_$($PullRequestNumber)"
	$pullRequestRevision = Get-NextCounterValue -Key $pullRequestRevisionKey
	$pullRequestRevision = Set-CarpenterVariable -VariableName "Carpenter.PullRequest.Revision" -OutputVariableName "pullRequestRevision" -Value $pullRequestRevision
	$versionLabel = Set-CarpenterVariable -VariableName "Carpenter.Version.Label" -OutputVariableName "versionLabel" -Value "PR.$($PullRequestNumber).$($PullRequestRevision)"
}

If ($BuildPurpose -eq "Prerelease") {
	$prereleaseLabel = Set-CarpenterVariable -VariableName "Carpenter.Prerelease.Label" -OutputVariableName "prereleaseLabel" -Value $PrereleaseLabel
	$prereleaseRevisionKey = "suent_carpenter_$($DefinitionName)_$($Project)_$($baseVersion)-$($prereleaseLabel)"
	$prereleaseRevision = Get-NextCounterValue -Key $prereleaseRevisionKey
	$prereleaseRevision = Set-CarpenterVariable -VariableName "Carpenter.Prerelease.Revision" -OutputVariableName "prereleaseRevision" -Value $prereleaseRevision
	$versionLabel = Set-CarpenterVariable -VariableName "Carpenter.Version.Label" -OutputVariableName "versionLabel" -Value "$($prereleaseLabel).$($prereleaseRevision)"
}

If ($BuildPurpose -eq "Release") {
	$versionType = Set-CarpenterVariable -VariableName "Carpenter.Version.IncrementOnRelease" -OutputVariableName "incrementVersionOnRelease" -Value $IncrementVersionOnRelease
	$versionLabel = Set-CarpenterVariable -OutputVariableName versionLabel -Value $null
	$version = Set-CarpenterVariable -VariableName "Carpenter.Version" -OutputVariableName "version" -Value $BaseVersion
} else {
	$version = Set-CarpenterVariable -VariableName "Carpenter.Version" -OutputVariableName "version" -Value "$($BaseVersion)-$($versionLabel)"
}

Write-Host "##vso[build.updatebuildnumber]$version"
