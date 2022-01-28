#Requires -Version 3
<#
	.SYNOPSIS
	
	Finalizes the build version.
#>

[CmdletBinding()]
param(
	[string] $BuildType = $env:CARPENTER_BUILD_TYPE,
	[string] $ContinuousIntegrationDate = $env:CARPENTER_CONTINUOUSINTEGRATION_DATE,
	[string] $ContinuousIntegrationRevision = $env:CARPENTER_CONTINUOUSINTEGRATION_REVISION,
	[string] $PullRequestNumber = $env:SYSTEM_PULLREQUEST_PULLREQUESTNUMBER,
	[string] $PullRequestRevision = $env:CARPENTER_PULLREQUEST_REVISION,
	[string] $PrereleaseLabel = $env:CARPENTER_PRERELEASE_LABEL,
	[string] $PrereleaseSemantic = $env:CARPENTER_PRERELEASE_SEMANTIC,
	[string] $PrereleaseRevision = $env:CARPENTER_PRERELEASE_REVISION,
	[string] $BaseVersion = $env:CARPENTER_VERSION_BASEVERSION
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"


if ($BuildType -eq "CI") {
	$versionLabel = Set-CarpenterVariable -OutputVariableName "versionLabel" -Value "CI.$($ContinuousIntegrationDate).$($ContinuousIntegrationRevision)"
}
if ($BuildType -eq "PR") {
	$versionLabel = Set-CarpenterVariable -OutputVariableName "versionLabel" -Value "PR.$($PullRequestNumber).$($PullRequestRevision)"
}
if ($BuildType -eq "Prerelease") {
	$prereleaseSemantic = Set-CarpenterVariable -OutputVariableName "prereleaseSemantic" -Value $PrereleaseSemantic
	$prereleaseRevision = Set-CarpenterVariable -OutputVariableName "prereleaseRevision" -Value $PrereleaseRevision
	$versionLabel = Set-CarpenterVariable -OutputVariableName "versionLabel" -Value "$($PrereleaseLabel).$($PrereleaseRevision)"
}
If ($BuildType -eq "Release") {
	$versionLabel = Set-CarpenterVariable -OutputVariableName versionLabel -Value $null
	$version = Set-CarpenterVariable -OutputVariableName "version" -Value $BaseVersion
} else {
	$version = Set-CarpenterVariable -OutputVariableName "version" -Value "$($BaseVersion)-$($versionLabel)"
}
Write-Host "##vso[build.updatebuildnumber]$version"
