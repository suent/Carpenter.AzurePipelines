#Requires -Version 3
<#
	.SYNOPSIS
	
	Initializes the pipeline.
#>

[CmdletBinding()]
param(
	[string] $AgentBuildDirectory = $env:AGENT_BUILDDIRECTORY,
	[string] $AgentToolsDirectory = $env:AGENT_TOOLSDIRECTORY,
	[string] $BuildDefinitionName = $env:BUILD_DEFINITIONNAME,
	[string] $BuildReason = $env:BUILD_REASON,
	[string] $SystemDefaultWorkingDirectory = $env:SYSTEM_DEFAULTWORKINGDIRECTORY,
	[string] $PipelineVersion = $env:CARPENTER_PIPELINEVERSION,
	[string] $Project = $env:CARPENTER_PROJECT,
	[string] $IncludePipeline = $env:CARPENTER_PIPELINE,
	[string] $PipelinePath = $env:CARPENTER_PIPELINE_PATH,
	[string] $PipelineScriptPath = $env:CARPENTER_PIPELINE_SCRIPTPATH,
	[string] $PipelineReason = $env:CARPENTER_PIPELINE_REASON,
	[string] $PipelineBot = $env:CARPENTER_PIPELINE_BOT,
	[string] $PipelineBotEmail = $env:CARPENTER_PIPELINE_BOTEMAIL,
	[string] $DefaultPoolType = $env:CARPENTER_POOL_DEFAULT_TYPE,
	[string] $DefaultPoolName = $env:CARPENTER_POOL_DEFAULT_NAME,
	[string] $DefaultPoolDemands = $env:CARPENTER_POOL_DEFAULT_DEMANDS,
	[string] $DefaultPoolVMImage = $env:CARPENTER_POOL_DEFAULT_VMIMAGE,
	[string] $VersionType = $env:CARPENTER_VERSION_TYPE,
	[string] $BuildDotNet = $env:CARPENTER_BUILD_DOTNET,
	[string] $ExecuteUnitTests = $env:CARPENTER_TEST_UNIT,
	[string] $SonarCloud = $env:CARPENTER_SONARCLOUD,
	[string] $SonarCloudOrganization = $env:CARPENTER_SONARCLOUD_ORGANIZATION,
	[string] $SonarCloudProjectKey = $env:CARPENTER_SONARCLOUD_PROJECTKEY,
	[string] $SonarCloudServiceConnection = $env:CARPENTER_SONARCLOUD_SERVICECONNECTION,
	[string] $DeployBranch = $env:CARPENTER_DEPLOY_BRANCH,
	[string] $DeployNuGet = $env:CARPENTER_DEPLOY_NUGET,
	[string] $NuGetTargetFeedDev = $env:CARPENTER_DEPLOY_NUGET_TARGETFEED_DEV,
	[string] $NuGetTargetFeedTest1 = $env:CARPENTER_DEPLOY_NUGET_TARGETFEED_TEST1,
	[string] $NuGetTargetFeedTest2 = $env:CARPENTER_DEPLOY_NUGET_TARGETFEED_TEST2,
	[string] $NuGetTargetFeedStage = $env:CARPENTER_DEPLOY_NUGET_TARGETFEED_STAGE,
	[string] $NuGetTargetFeedProd = $env:CARPENTER_DEPLOY_NUGET_TARGETFEED_PROD,
	[string] $UpdateNuGetQuality = $env:CARPENTER_NUGET_QUALITY,
	[string] $NuGetQualityFeed = $env:CARPENTER_NUGET_QUALITY_FEED,
	[string] $NuGetQualityDev = $env:CARPENTER_NUGET_QUALITY_DEV,
	[string] $NuGetQualityTest1 = $env:CARPENTER_NUGET_QUALITY_TEST1,
	[string] $NuGetQualityTest2 = $env:CARPENTER_NUGET_QUALITY_TEST2,
	[string] $NuGetQualityStage = $env:CARPENTER_NUGET_QUALITY_STAGE,
	[string] $NuGetQualityProd = $env:CARPENTER_NUGET_QUALITY_PROD,
	[string] $GitHubServiceConnection = $env:CARPENTER_GITHUB_SERVICECONNECTION
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"

. ./initialize/pipelineVersion.ps1

if (-Not $Project) {
	$project = Set-CarpenterVariable -VariableName "Carpenter.Project" -OutputVariableName "project" -Value $BuildDefinitionName
} else {
	$project = Set-CarpenterVariable -VariableName "Carpenter.Project" -OutputVariableName "project" -Value $Project
}

if ($IncludePipeline -eq 'true') {
	$projectPath = Set-CarpenterVariable -VariableName "Carpenter.Project.Path"  -OutputVariableName "projectPath" -Value "$AgentBuildDirectory/s/$project"
} else {
	$projectPath = Set-CarpenterVariable -VariableName "Carpenter.Project.Path"  -OutputVariableName "projectPath" -Value "$AgentBuildDirectory/s"
}

if ($BuildDotNet -eq 'true') {
	$dotNetPath = Set-CarpenterVariable -VariableName "Carpenter.DotNet.Path" -OutputVariableName "dotNetPath" -Value "$AgentToolsDirectory/dotnet"
	$solutionPath = Set-CarpenterVariable -VariableName "Carpenter.Solution.Path" -OutputVariableName "solutionPath" -Value "$projectPath/$project.sln"
	$outputPath = Set-CarpenterVariable -VariableName "Carpenter.Output.Path" -OutputVariableName "outputPath" -Value "$SystemDefaultWorkingDirectory/out"
	$binariesPath = Set-CarpenterVariable -VariableName "Carpenter.Output.Binaries.Path" -OutputVariableName "binariesPath" -Value "$outputPath/bin"
	$nuGetPath = Set-CarpenterVariable -VariableName "Carpenter.Output.NuGet.Path" -OutputVariableName "nuGetPath" -Value "$outputPath/nuget"
	if ($ExecuteUnitTests -eq 'true') {
		$testPath = Set-CarpenterVariable -VariableName "Carpenter.Output.Tests.Path" -OutputVariableName "testsPath" -Value "$outputPath/tests"
		$testCoveragePath = Set-CarpenterVariable -VariableName "Carpenter.Output.TestCoverage.Path" -OutputVariableName "testCoveragePath" -Value "$outputPath/testCoverage"
	}
}

$includePipeline = Set-CarpenterVariable -VariableName "Carpenter.Pipeline" -OutputVariableName "includePipeline" -Value $IncludePipeline
$pipelinePath = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.Path" -OutputVariableName "pipelinePath" -Value $PipelinePath
$pipelineScriptPath = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.ScriptPath" -OutputVariableName "pipelineScriptPath" -Value $PipelineScriptPath



Write-Verbose "Validating pipelineReason"
if ($BuildReason -eq "Manual") {
	if (($PipelineReason -ne "CI") -and ($PipelineReason -ne "Prerelease") -and ($PipelineReason -ne "Release")) {
		Write-PipelineError "Unrecognized pipelineReason parameter '$PipelineReason'."
	}
} else {
	if ($PipelineReason -ne "") {
		Write-PipelineWarning "The pipelineReason parameter '$PipelineReason' is being ignored because Build.Reason is not Manual."
	}
}
if (($BuildReason -eq "IndividualCI") -or ($BuildReason -eq "BatchedCI") -or (($BuildReason -eq "Manual") -and ($PipelineReason -eq "CI"))) {
	$pipelineReason = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.Reason" -OutputVariableName "pipelineReason" -Value "CI"
} 
ElseIf ($BuildReason -eq "PullRequest") {
	$pipelineReason = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.Reason" -OutputVariableName "pipelineReason" -Value "PR"
}
ElseIf (($BuildReason -eq "Manual") -and ($PipelineReason -eq "Prerelease")) {
	$pipelineReason = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.Reason" -OutputVariableName "pipelineReason" -Value "Prerelease"
}
ElseIf (($BuildReason -eq "Manual") -and ($PipelineReason -eq "Release")) {
	$pipelineReason = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.Reason" -OutputVariableName "pipelineReason" -Value "Release"
}
Else {
	Write-PipelineError "Build type not implemented. BuildReason=$BuildReason, PipelineReason=$PipelineReason"
}

# Add pipeline reason as tag
Write-Host "##vso[build.addbuildtag]Build-$pipelineReason"



Write-Verbose "Validating defaultPoolType"
if (-Not ($DefaultPoolType)) {
	Write-PipelineError "The defaultPoolType parameter must be supplied to Carpenter Azure Pipelines template."
}
if (($DefaultPoolType -ne "Hosted") -and ($DefaultPoolType -ne "Private")) {
	Write-PipelineError "Unrecognized defaultPoolType parameter '$DefaultPoolType'."
}

Write-Verbose "Validating defaultPoolName"
if ($DefaultPoolType -eq "Private") {
	if (-Not ($DefaultPoolName)) {
		Write-PipelineError "The defaultPoolName parameter must be supplied to Carpenter Azure Pipelines template when defaultPoolType is Private."
	}
} else {
	if ($DefaultPoolName) {
		Write-PipelineWarning "The defaultPoolName parameter '$DefaultPoolName' is being ignored because defaultPoolType is not Private."
	}
}

Write-Verbose "Validating defaultPoolDemands"
if ($DefaultPoolType -eq "Private") {
	if (($DefaultPoolDemands -ne "True") -and ($DefaultPoolDemands -ne "False")) {
		Write-PipelineError "The defaultPoolDemands parameter must either be True or False."
	}
} else {
	if ($DefaultPoolDemands) {
		Write-PipelineWarning "The defaultPoolDemands parameter '$DefaultPoolDemands' is being ignored because defaultPoolType is not Private."
	}
}

Write-Verbose "Validating defaultPoolVMImage"
if ($DefaultPoolType -eq "Hosted") {
	if (-Not ($DefaultPoolVMImage)) {
		Write-PipelineError "The defaultPoolVMImage parameter must be supplied to Carpenter Azure Pipelines template."
	}
} else {
	if ($DefaultPoolVMImage) {
		Write-PipelineWarning "The defaultPoolVMImage parameter '$DefaultPoolVMImage' is being ignored because defaultPoolType is not Hosted."
	}
}

$defaultPoolType = Set-CarpenterVariable -VariableName "Carpenter.Pool.Default.Type" -OutputVariableName defaultPoolType -Value $DefaultPoolType
if ($defaultPoolType -eq "Private") {
	$defaultPoolName = Set-CarpenterVariable -VariableName "Carpenter.Pool.Default.Name" -OutputVariableName defaultPoolName -Value $DefaultPoolName
	$defaultPoolDemands = Set-CarpenterVariable -VariableName "Carpenter.Pool.Default.Demands" -OutputVariableName defaultPoolDemands -Value $DefaultPoolDemands
}
if ($defaultPoolType -eq "Hosted") {
	$defaultPoolVMImage = Set-CarpenterVariable -VariableName "Carpenter.Pool.Default.VMImage" -OutputVariableName defaultPoolVMImage -Value $DefaultPoolVMImage
}

$versionType = Set-CarpenterVariable -VariableName "Carpenter.Version.Type" -OutputVariableName "versionType" -Value $VersionType

if ($BuildDotNet -eq 'true') {
	$buildDotNet = Set-CarpenterVariable -VariableName "Carpenter.Build.DotNet" -OutputVariableName "buildDotNet" -Value $BuildDotNet
}
$executeUnitTests = Set-CarpenterVariable -VariableName "Carpenter.Test.Unit" -OutputVariableName "executeUnitTests" -Value $ExecuteUnitTests

$sonarCloud = Set-CarpenterVariable -VariableName "Carpenter.SonarCloud" -OutputVariableName "sonarCloud" -Value $SonarCloud
if ($sonarCloud -eq 'true') {
	$sonarCloudOrganization = Set-CarpenterVariable -VariableName "Carpenter.SonarCloud.Organization" -OutputVariableName "sonarCloudOrganization" -Value $SonarCloudOrganization
	$sonarCloudProjectKey = Set-CarpenterVariable -VariableName "Carpenter.SonarCloud.ProjectKey" -OutputVariableName "sonarCloudProjectKey" -Value $SonarCloudProjectKey
	$sonarCloudServiceConnection = Set-CarpenterVariable -VariableName "Carpenter.SonarCloud.ServiceConnection" -OutputVariableName "sonarCloudServiceConnection" -Value $SonarCloudServiceConnection
}

$deployBranch = Set-CarpenterVariable -VariableName "Carpenter.Deploy.Branch" -OutputVariableName "deployBranch" -Value $DeployBranch
$deployNuGet = Set-CarpenterVariable -VariableName "Carpenter.Deploy.NuGet" -OutputVariableName "deployNuGet" -Value $DeployNuGet
$nuGetTargetFeedDev = Set-CarpenterVariable -VariableName "Carpenter.Deploy.NuGet.TargetFeed.Dev" -OutputVariableName "nuGetTargetFeedDev" -Value $NuGetTargetFeedDev
$nuGetTargetFeedTest1 = Set-CarpenterVariable -VariableName "Carpenter.Deploy.NuGet.TargetFeed.Test1" -OutputVariableName "nuGetTargetFeedTest1" -Value $NuGetTargetFeedTest2
$nuGetTargetFeedTest2 = Set-CarpenterVariable -VariableName "Carpenter.Deploy.NuGet.TargetFeed.Test2" -OutputVariableName "nuGetTargetFeedTest2" -Value $NuGetTargetFeedTest2
$nuGetTargetFeedStage = Set-CarpenterVariable -VariableName "Carpenter.Deploy.NuGet.TargetFeed.Stage" -OutputVariableName "nuGetTargetFeedStage" -Value $NuGetTargetFeedStage
$nuGetTargetFeedProd = Set-CarpenterVariable -VariableName "Carpenter.Deploy.NuGet.TargetFeed.Prod" -OutputVariableName "nuGetTargetFeedProd" -Value $NuGetTargetFeedProd

$updateNuGetQuality = Set-CarpenterVariable -VariableName "Carpenter.NuGet.Quality" -OutputVariableName "updateNuGetQuality" -Value $UpdateNuGetQuality
$nuGetQualityFeed = Set-CarpenterVariable -VariableName "Carpenter.NuGet.Quality.Feed" -OutputVariableName "nuGetQualityFeed" -Value $NuGetQualityFeed
$nuGetQualityDev = Set-CarpenterVariable -VariableName "Carpenter.NuGet.Quality.Dev" -OutputVariableName "nuGetQualityDev" -Value $NuGetQualityDev
$nuGetQualityTest1 = Set-CarpenterVariable -VariableName "Carpenter.NuGet.Quality.Test1" -OutputVariableName "nuGetQualityTest1" -Value $NuGetQualityTest1
$nuGetQualityTest2 = Set-CarpenterVariable -VariableName "Carpenter.NuGet.Quality.Test2" -OutputVariableName "nuGetQualityTest2" -Value $NuGetQualityTest2
$nuGetQualityStage = Set-CarpenterVariable -VariableName "Carpenter.NuGet.Quality.Stage" -OutputVariableName "nuGetQualityStage" -Value $NuGetQualityStage
$nuGetQualityProd = Set-CarpenterVariable -VariableName "Carpenter.NuGet.Quality.Prod" -OutputVariableName "nuGetQualityProd" -Value $NuGetQualityProd

$gitHubServiceConnection = Set-CarpenterVariable -VariableName "Carpenter.GitHub.ServiceConnection" -OutputVariableName "gitHubServiceConnection" -Value $GitHubServiceConnection
