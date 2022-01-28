#Requires -Version 3
<#
	.SYNOPSIS
	
	Initializes the pipeline.
#>

[CmdletBinding()]
param(
	[string] $PipelineVersion = $env:CARPENTER_PIPELINEVERSION,
	[string] $BuildReason = $env:BUILD_REASON,
	[string] $BuildType = $env:CARPENTER_BUILD_TYPE,
	[string] $Project = $env:CARPENTER_PROJECT,
	[string] $DefaultPoolType = $env:CARPENTER_POOL_DEFAULT_TYPE,
	[string] $DefaultPoolName = $env:CARPENTER_POOL_DEFAULT_NAME,
	[string] $DefaultPoolDemands = $env:CARPENTER_POOL_DEFAULT_DEMANDS,
	[string] $DefaultPoolVMImage = $env:CARPENTER_POOL_DEFAULT_VMIMAGE
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"

$pipelineVersion = Set-CarpenterVariable -OutputVariableName "pipelineVersion" -Value $PipelineVersion

If (($BuildReason -eq "IndividualCI") -or ($BuildReason -eq "BatchedCI") -or (($BuildReason -eq "Manual") -and ($BuildType -eq "Manual"))) {
	$buildType = Set-CarpenterVariable -VariableName "Carpenter.Build.Type" -OutputVariableName "buildType" -Value "CI"
} 
ElseIf ($BuildReason -eq "PullRequest") {
	$buildType = Set-CarpenterVariable -VariableName "Carpenter.Build.Type" -OutputVariableName "buildType" -Value "PR"
}
ElseIf (($BuildReason -eq "Manual") -and ($BuildType -eq "Prerelease")) {
	$buildType = Set-CarpenterVariable -VariableName "Carpenter.Build.Type" -OutputVariableName "buildType" -Value "Prerelease"
}
Else {
	Write-PipelineError "Build type not implemented. BuildReason=$BuildReason, BuildType=$BuildType"
}

# Add buildType as tag
Write-Host "##vso[build.addbuildtag]$buildType"

$project = Set-CarpenterVariable -OutputVariableName project -Value $Project

$defaultPoolType = Set-CarpenterVariable -OutputVariableName defaultPoolType -Value $DefaultPoolType
if ($defaultPoolType -eq "Private") {
	$defaultPoolName = Set-CarpenterVariable -OutputVariableName defaultPoolName -Value $DefaultPoolName
	$defaultPoolDemands = Set-CarpenterVariable -OutputVariableDemands defaultPoolType -Value $DefaultPoolDemands
}
if ($defaultPoolType -eq "Hosted") {
	$defaultPoolVMImage = Set-CarpenterVariable -OutputVariableName defaultPoolVMImage -Value $DefaultPoolVMImage
}
