#Requires -Version 3
<#
	.SYNOPSIS
	
	Initializes the pipeline.
#>

[CmdletBinding()]
param(
	[string] $PipelineVersion = $env:CARPENTER_PIPELINEVERSION,
	[string] $IncludePipeline = $env:CARPENTER_PIPELINE,
	[string] $PipelinePath = $env:CARPENTER_PIPELINE_PATH,
	[string] $PipelineScriptPath = $env:CARPENTER_PIPELINE_SCRIPTPATH,
	[string] $DotNetPath = $env:CARPENTER_DOTNET_PATH,
	[string] $BuildReason = $env:BUILD_REASON,
	[string] $BuildPurpose = $env:CARPENTER_BUILD_PURPOSE,
	[string] $Project = $env:CARPENTER_PROJECT,
	[string] $PipelineBot = $env:CARPENTER_PIPELINE_BOT,
	[string] $PipelineBotEmail = $env:CARPENTER_PIPELINE_BOTEMAIL,
	[string] $ProjectPath = $env:CARPENTER_PROJECT_PATH,
	[string] $DefaultPoolType = $env:CARPENTER_POOL_DEFAULT_TYPE,
	[string] $DefaultPoolName = $env:CARPENTER_POOL_DEFAULT_NAME,
	[string] $DefaultPoolDemands = $env:CARPENTER_POOL_DEFAULT_DEMANDS,
	[string] $DefaultPoolVMImage = $env:CARPENTER_POOL_DEFAULT_VMIMAGE,
	[string] $VersionType = $env:CARPENTER_VERSION_TYPE,
	[string] $BuildDotNet = $env:CARPENTER_BUILD_DOTNET,
	[string] $ExecuteUnitTests = $env:CARPENTER_TEST_UNIT
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"

$pipelineVersion = Set-CarpenterVariable -VariableName "Carpenter.PipelineVersion" -OutputVariableName "pipelineVersion" -Value $PipelineVersion
$includePipeline = Set-CarpenterVariable -VariableName "Carpenter.Pipeline" -OutputVariableName "includePipeline" -Value $IncludePipeline
$pipelinePath = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.Path" -OutputVariableName "pipelinePath" -Value $PipelinePath
$pipelineScriptPath = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.ScriptPath" -OutputVariableName "pipelineScriptPath" -Value $PipelineScriptPath
$dotNetPath = Set-CarpenterVariable -VariableName "Carpenter.DotNet.Path" -OutputVariableName "dotNetPath" -Value $DotNetPath

If (($BuildReason -eq "IndividualCI") -or ($BuildReason -eq "BatchedCI") -or (($BuildReason -eq "Manual") -and ($BuildPurpose -eq "CI"))) {
	$buildPurpose = Set-CarpenterVariable -VariableName "Carpenter.Build.Purpose" -OutputVariableName "buildPurpose" -Value "CI"
} 
ElseIf ($BuildReason -eq "PullRequest") {
	$buildPurpose = Set-CarpenterVariable -VariableName "Carpenter.Build.Purpose" -OutputVariableName "buildPurpose" -Value "PR"
}
ElseIf (($BuildReason -eq "Manual") -and ($BuildPurpose -eq "Prerelease")) {
	$buildPurpose = Set-CarpenterVariable -VariableName "Carpenter.Build.Purpose" -OutputVariableName "buildPurpose" -Value "Prerelease"
}
ElseIf (($BuildReason -eq "Manual") -and ($BuildPurpose -eq "Release")) {
	$buildPurpose = Set-CarpenterVariable -VariableName "Carpenter.Build.Purpose" -OutputVariableName "buildPurpose" -Value "Release"
}
Else {
	Write-PipelineError "Build type not implemented. BuildReason=$BuildReason, BuildPurpose=$BuildPurpose"
}

# Add build purpose as tag
Write-Host "##vso[build.addbuildtag]Build-$buildPurpose"

$project = Set-CarpenterVariable -VariableName "Carpenter.Project" -OutputVariableName "project" -Value $Project
$projectPath = Set-CarpenterVariable -VariableName "Carpenter.Project.Path"  -OutputVariableName "projectPath" -Value $ProjectPath

$defaultPoolType = Set-CarpenterVariable -VariableName "Carpenter.Pool.Default.Type" -OutputVariableName defaultPoolType -Value $DefaultPoolType
if ($defaultPoolType -eq "Private") {
	$defaultPoolName = Set-CarpenterVariable -VariableName "Carpenter.Pool.Default.Name" -OutputVariableName defaultPoolName -Value $DefaultPoolName
	$defaultPoolDemands = Set-CarpenterVariable -VariableName "Carpenter.Pool.Default.Demands" -OutputVariableName defaultPoolDemands -Value $DefaultPoolDemands
}
if ($defaultPoolType -eq "Hosted") {
	$defaultPoolVMImage = Set-CarpenterVariable -VariableName "Carpenter.Pool.Default.VMImage" -OutputVariableName defaultPoolVMImage -Value $DefaultPoolVMImage
}

$versionType = Set-CarpenterVariable -VariableName "Carpenter.Version.Type" -OutputVariableName "versionType" -Value $VersionType

$buildDotNet = Set-CarpenterVariable -VariableName "Carpenter.Build.DotNet" -OutputVariableName "buildDotNet" -Value $BuildDotNet

$executeUnitTests = Set-CarpenterVariable -VariableName "Carpenter.Test.Unit" -OutputVariableName "executeUnitTests" -Value $ExecuteUnitTests
