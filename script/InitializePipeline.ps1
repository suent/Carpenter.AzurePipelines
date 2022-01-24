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
	[string] $Project = $env:CARPENTER_PROJECT
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"

$pipelineVersion = Set-CarpenterVariable -OutputVariableName "pipelineVersion" -Value $PipelineVersion

If (($BuildReason -eq "IndividualCI") -or ($BuildReason -eq "BatchedCI") -or (($BuildReason -eq "Manual") -and ($BuildType -eq "Manual"))) {
	$buildType = Set-CarpenterVariable -OutputVariableName "buildType" -Value "CI"
} 
ElseIf ($BuildReason -eq "PullRequest") {
	$buildType = Set-CarpenterVariable -OutputVariableName "buildType" -Value "PR"
}
ElseIf (($BuildReason -eq "Manual") -and ($BuildType -eq "Prerelease")) {
	$buildType = Set-CarpenterVariable -OutputVariableName "buildType" -Value "Prerelease"
}
Else {
	Write-PipelineError "Build type not implemented. BuildReason=$BuildReason, BuildType=$BuildType"
}

$project = Set-CarpenterVariable -OutputVariableName project -Value $Project