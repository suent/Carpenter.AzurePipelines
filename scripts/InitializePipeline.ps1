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
	[string] $PipelineVersion = $env:CARPENTER_PIPELINE_VERSION,
	[string] $Operations = $env:CARPENTER_PIPELINE_OPERATIONS,
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
	[string] $RevisionOffset = $env:CARPENTER_VERSION_REVISIONOFFSET,
	[string] $ContinuousIntegrationDate = $env:CARPENTER_CONTINUOUSINTEGRATION_DATE,
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

# Carpenter.Pipeline.Version (pipelineVersion)
Write-Verbose "Validating pipelineVersion"
if ((-not ($PipelineVersion | IsNumeric -Verbose:$false)) -or (-not ($PipelineVersion -gt 0))) {
	Write-PipelineError "The pipelineVersion parameter must be supplied to the Carpenter Azure Pipelines template."
}
$pipelineVersion = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.Version" -OutputVariableName "pipelineVersion" -Value $PipelineVersion

# Carpenter.Pipeline.Operations (operations)
Write-Verbose "Validating Carpenter.Pipeline.Operations (operations)"
$ops = ConvertFrom-Json $Operations

if ($ops.Count -eq 0) {
	Write-PipelineWarning "No operations have been defined in this Carpenter Pipeline. For more information: https://github.com/suent/Carpenter.AzurePipelines/blob/main/docs/configuration.md#carpenterpipelineoperations-operations"
}
Write-Host $Operations
Write-Host $ops.Count
Write-Host $ops
Write-Host $ops[0].Count
Write-Host $ops[0]
Write-Host $ops[1].Count
Write-Host $ops[1]

# Carpenter.Project
if (-Not $Project) {
	$Project = $BuildDefinitionName
}
$project = Set-CarpenterVariable -VariableName "Carpenter.Project" -OutputVariableName "project" -Value $Project


# Carpenter.Project.Path
if ($IncludePipeline -eq 'true') {
	$projectPath = "$AgentBuildDirectory/s/$project"
} else {
	$projectPath = "$AgentBuildDirectory/s"
}
$projectPath = Set-CarpenterVariable -VariableName "Carpenter.Project.Path"  -OutputVariableName "projectPath" -Value $projectPath

# Other pipeline paths
if ($BuildDotNet -eq 'true') {

	# Carpenter.DotNet.Path
	$dotNetPath = Set-CarpenterVariable -VariableName "Carpenter.DotNet.Path" -OutputVariableName "dotNetPath" -Value "$AgentToolsDirectory/dotnet"

	# Carpenter.Solution.Path
	$solutionPath = Set-CarpenterVariable -VariableName "Carpenter.Solution.Path" -OutputVariableName "solutionPath" -Value "$projectPath/$project.sln"

	# Carpenter.Output.Path
	$outputPath = Set-CarpenterVariable -VariableName "Carpenter.Output.Path" -OutputVariableName "outputPath" -Value "$SystemDefaultWorkingDirectory/out"

	# Carpenter.Output.Binaries.Path
	$binariesPath = Set-CarpenterVariable -VariableName "Carpenter.Output.Binaries.Path" -OutputVariableName "binariesPath" -Value "$outputPath/bin"

	# Carpenter.Output.NuGet.Path
	$nuGetPath = Set-CarpenterVariable -VariableName "Carpenter.Output.NuGet.Path" -OutputVariableName "nuGetPath" -Value "$outputPath/nuget"

	if ($ExecuteUnitTests -eq 'true') {

		# Carpenter.Output.Tests.Path
		$testPath = Set-CarpenterVariable -VariableName "Carpenter.Output.Tests.Path" -OutputVariableName "testsPath" -Value "$outputPath/tests"

		# Carpenter.Output.TestCoverage.Path
		$testCoveragePath = Set-CarpenterVariable -VariableName "Carpenter.Output.TestCoverage.Path" -OutputVariableName "testCoveragePath" -Value "$outputPath/testCoverage"
	}
}


# Carpenter.Pipeline (includePipeline)
$includePipeline = Set-CarpenterVariable -VariableName "Carpenter.Pipeline" -OutputVariableName "includePipeline" -Value $IncludePipeline

# Carpenter.Pipeline.Path
$pipelinePath = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.Path" -OutputVariableName "pipelinePath" -Value $PipelinePath

# Carpenter.Pipeline.ScriptPath
$pipelineScriptPath = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.ScriptPath" -OutputVariableName "pipelineScriptPath" -Value $PipelineScriptPath


# Carpenter.Pipeline.Reason
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


# Validate defaultPool parameters
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

# Carpenter.Pool.Default.Type
$defaultPoolType = Set-CarpenterVariable -VariableName "Carpenter.Pool.Default.Type" -OutputVariableName defaultPoolType -Value $DefaultPoolType
if ($defaultPoolType -eq "Private") {
	# Carpenter.Pool.Default.Name
	$defaultPoolName = Set-CarpenterVariable -VariableName "Carpenter.Pool.Default.Name" -OutputVariableName defaultPoolName -Value $DefaultPoolName
	# Carpenter.Pool.Default.Demands
	$defaultPoolDemands = Set-CarpenterVariable -VariableName "Carpenter.Pool.Default.Demands" -OutputVariableName defaultPoolDemands -Value $DefaultPoolDemands
}
if ($defaultPoolType -eq "Hosted") {
	# Carpenter.Pool.Default.VMImage
	$defaultPoolVMImage = Set-CarpenterVariable -VariableName "Carpenter.Pool.Default.VMImage" -OutputVariableName defaultPoolVMImage -Value $DefaultPoolVMImage
}

# Carpenter.Version.Type
Write-Verbose "Validating versionType"
if (-Not ($VersionType)) {
	Write-PipelineError "The versionType parameter must be supplied to Carpenter Azure Pipelines template."
} else {
	if (($VersionType -ne "None") -and ($VersionType -ne "SemVer")) {
		Write-PipelineError "Unrecognized versionType parameter '$VersionType'."
	}
}
$versionType = Set-CarpenterVariable -VariableName "Carpenter.Version.Type" -OutputVariableName "versionType" -Value $VersionType

# Versioning
if ($versionType -ne "None") {

	# Carpenter.Version.RevisionOffset
	if (-not ($RevisionOffset)) { $RevisionOffset = 0 } # Default value
	Write-Verbose "Validating Carpenter.Version.RevisionOffset"
	if ((-not ($RevisionOffset | IsNumeric -Verbose:$false)) -or (-not ($RevisionOffset -ge 0))) {
		Write-PipelineError "The Carpenter.Version.RevisionOffset variable supplied to the Carpenter Azure Pipelines template must be a number greater than or equal to zero."
	}
	$revisionOffset = Set-CarpenterVariable -VariableName "Carpenter.Version.RevisionOffset" -OutputVariableName "revisionOffset" -Value $RevisionOffset
	
	# Carpenter.Version.Revision
	$revisionKey = "suent_carpenter_$($BuildDefinitionName)_$($Project)_revision"
	$revision = Get-NextCounterValue -Key $revisionKey -Offset $revisionOffset
	$revision = Set-CarpenterVariable -VariableName "Carpenter.Version.Revision" -OutputVariableName "revision" -Value $revision

	# Semantic Versioning
	if ($VersionType -eq "SemVer") {
		if (-not ($VersionFile)) { $VersionFile = "VERSION" } # Default value

		# Carpenter.Version.VersionFile
		$versionFile = Set-CarpenterVariable -VariableName "Carpenter.Version.VersionFile" -OutputVariableName "versionFile" -Value $VersionFile
		# Carpenter.Version.VersionFile.Path
		$versionFilePath = Set-CarpenterVariable -VariableName "Carpenter.Version.VersionFile.Path" -OutputVariableName "versionFilePath" -Value "$projectPath/$versionFile"

		If (-Not (Test-Path -Path $versionFilePath -PathType Leaf)) {
			Write-PipelineError "VERSION file does not exist at expected path. Path: $versionFilePath"
		} else {
			$versionFileContent = Get-Content -Path $versionFilePath
			$targetVersion = [Version]::new($versionFileContent)
			
			# Carpenter.Version.BaseVersion
			$baseVersion = Set-CarpenterVariable -VariableName "Carpenter.Version.BaseVersion" -OutputVariableName "baseVersion" -Value "$($targetVersion.Major).$($targetVersion.Minor).$($targetVersion.Build)"
			
			# Carpenter.Version.Major
			$majorVersion = Set-CarpenterVariable -VariableName "Carpenter.Version.Major" -OutputVariableName "majorVersion" -Value $targetVersion.Major

			# Carpenter.Version.Minor
			$minorVersion = Set-CarpenterVariable -VariableName "Carpenter.Version.Minor" -OutputVariableName "minorVersion" -Value $targetVersion.Minor

			# Carpenter.Version.Patch
			$patchVersion = Set-CarpenterVariable -VariableName "Carpenter.Version.Patch" -OutputVariableName "patchVersion" -Value $targetVersion.Build
		}

		# Continuous integration
		If ($PipelineReason -eq "CI") {

			# Carpenter.ContinuousIntegration.Date
			$continuousIntegrationDate = Set-CarpenterVariable -VariableName "Carpenter.ContinuousIntegration.Date" -OutputVariableName "continuousIntegrationDate" -Value $ContinuousIntegrationDate

			# Carpenter.ContinuousIntegration.Revision
			$continuousIntegrationRevisionKey = "suent_carpenter_$($BuildDefinitionName)_$($Project)_CI_$($continuousIntegrationDate)"
			$continuousIntegrationRevision = Get-NextCounterValue -Key $continuousIntegrationRevisionKey
			$continuousIntegrationRevision = Set-CarpenterVariable -VariableName "Carpenter.ContinuousIntegration.Revision" -OutputVariableName "continuousIntegrationRevision" -Value $continuousIntegrationRevision

			# Carpenter.Version.Label [CI]
			$versionLabel = Set-CarpenterVariable -VariableName "Carpenter.Version.Label" -OutputVariableName "versionLabel" -Value "CI.$($continuousIntegrationDate).$($continuousIntegrationRevision)"
		}

		# Pull request
		If ($PipelineReason -eq "PR") {
			
			# Carpenter.PullRequest.Revision
			$pullRequestRevisionKey = "suent_carpenter_$($BuildDefinitionName)_$($Project)_PR_$($PullRequestNumber)"
			$pullRequestRevision = Get-NextCounterValue -Key $pullRequestRevisionKey
			$pullRequestRevision = Set-CarpenterVariable -VariableName "Carpenter.PullRequest.Revision" -OutputVariableName "pullRequestRevision" -Value $pullRequestRevision
		
			# Carpenter.Version.Label [PR]
			$versionLabel = Set-CarpenterVariable -VariableName "Carpenter.Version.Label" -OutputVariableName "versionLabel" -Value "PR.$($PullRequestNumber).$($PullRequestRevision)"
		}

		# Prerelease
		If ($PipelineReason -eq "Prerelease") {
			Write-Verbose "Validating prereleaseLabel"
			if (-Not ($PrereleaseLabel)) {
				Write-PipelineError "The prereleaseLabel parameter must be supplied to Carpenter Azure Pipelines template."
			}
			# Carpenter.Prerelease.Label
			$prereleaseLabel = Set-CarpenterVariable -VariableName "Carpenter.Prerelease.Label" -OutputVariableName "prereleaseLabel" -Value $PrereleaseLabel

			# Carpenter.Prerelease.Revision
			$prereleaseRevisionKey = "suent_carpenter_$($BuildDefinitionName)_$($Project)_$($baseVersion)-$($prereleaseLabel)"
			$prereleaseRevision = Get-NextCounterValue -Key $prereleaseRevisionKey
			$prereleaseRevision = Set-CarpenterVariable -VariableName "Carpenter.Prerelease.Revision" -OutputVariableName "prereleaseRevision" -Value $prereleaseRevision

			# Carpenter.Version.Label [Prerelease]
			$versionLabel = Set-CarpenterVariable -VariableName "Carpenter.Version.Label" -OutputVariableName "versionLabel" -Value "$($prereleaseLabel).$($prereleaseRevision)"
		}

		# Release
		If ($PipelineReason -eq "Release") {
			
			# Carpenter.Version.IncrementOnRelease
			$incrementVersionOnRelease = Set-CarpenterVariable -VariableName "Carpenter.Version.IncrementOnRelease" -OutputVariableName "incrementVersionOnRelease" -Value $IncrementVersionOnRelease
			
			# Carpenter.Version.Label [Release]
			$versionLabel = Set-CarpenterVariable -OutputVariableName versionLabel -Value $null

			# Carpenter.Version [Release]
			$version = Set-CarpenterVariable -VariableName "Carpenter.Version" -OutputVariableName "version" -Value $BaseVersion

		} else {

			# Carpenter.Version [All others]
			$version = Set-CarpenterVariable -VariableName "Carpenter.Version" -OutputVariableName "version" -Value "$($BaseVersion)-$($versionLabel)"

		}

	}

	# Update Build Number
	Write-Host "##vso[build.updatebuildnumber]$version"
}


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
