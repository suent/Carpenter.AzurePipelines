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
	[string] $PipelineOperations = $env:CARPENTER_PIPELINE_OPERATIONS,
	[string] $PipelinePath = $env:CARPENTER_PIPELINE_PATH,
	[string] $PipelineScriptPath = $env:CARPENTER_PIPELINE_SCRIPTPATH,
	[string] $PipelineReason = $env:CARPENTER_PIPELINE_REASON,
	[string] $DefaultPoolType = $env:CARPENTER_POOL_DEFAULT_TYPE,
	[string] $DefaultPoolVMImage = $env:CARPENTER_POOL_DEFAULT_VMIMAGE,
	[string] $DefaultPoolName = $env:CARPENTER_POOL_DEFAULT_NAME,
	[string] $DefaultPoolDemands = $env:CARPENTER_POOL_DEFAULT_DEMANDS,
	[string] $Project = $env:CARPENTER_PROJECT,
	[string] $SolutionPath = $env:CARPENTER_SOLUTION_PATH,
	[string] $PipelineBot = $env:CARPENTER_PIPELINE_BOT,
	[string] $PipelineBotEmail = $env:CARPENTER_PIPELINE_BOTEMAIL,
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

######################################################################################################################
# Pipeline Settings
######################################################################################################################

# Carpenter.Pipeline.Version (pipelineVersion)
Write-Verbose "Validating Carpenter.Pipeline.Version (pipelineVersion)"
if ((-not ($PipelineVersion | IsNumeric -Verbose:$false)) -or (-not ($PipelineVersion -gt 0))) {
	Write-PipelineError "The pipelineVersion parameter must be supplied to the Carpenter Azure Pipelines template."
}
$pipelineVersion = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.Version" -OutputVariableName "pipelineVersion" -Value $PipelineVersion

# Carpenter.Pipeline.Operations (operations)
Write-Verbose "Validating Carpenter.Pipeline.Operations (pipelineOperations)"
$ops = ConvertFrom-Json $PipelineOperations
if ($ops.Count -eq 0) {
	Write-PipelineWarning "No pipelineOperations have been defined in the pipeline extending Carpenter.AzurePipelines. For more information: https://github.com/suent/Carpenter.AzurePipelines/blob/main/docs/configuration.md#carpenterpipelineoperations-pipelineoperations"
}
$validOps = "ExcludePipeline",`
			"PublishSourceArtifact",`
			"VersionSemVer",`
			"BuildDotNet",`
			"PackageNuGet",`
			"TestDotNet",`
			"CollectTestCoverage",`
			"AnalyzeSonar",`
			"IncrementVersionOnRelease"
foreach ($op in $ops) {
	if (-not ($validOps -contains $op)) {
		Write-PipelineError "Unrecognized pipelineOperation parameter '$op'."
	}
}
if ($ops -contains "CollectTestCoverage") {
	if (-not ($ops -contains "TestDotNet")) {
		Write-PipelineError "The CollectTestCoverage pipelineOperations option depends on the TestDotNet pipelineOperations option."
	}
}
if ($ops -contains "TestDotNet") {
	if (-not ($ops -contains "BuildDotNet")) {
		Write-PipelineError "The TestDotNet pipelineOperations option depends on the BuildDotNet pipelineOperations option."
	}
}
if ($ops -contains "PackageNuGet") {
	if (-not ($ops -contains "BuildDotNet")) {
		Write-PipelineError "The PackageNuGet pipelineOperations option depends on the BuildDotNet pipelineOperations option."
	}
}
$pipelineOperations = Set-CarpenterVariable -VariableName Carpenter.Pipeline.Operations -OutputVariableName "pipelineOperations" -Value $($PipelineOperations -replace "  ","" -replace "`n"," " -replace "`r","")

# Carpenter.Pipeline.Path
$pipelinePath = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.Path" -OutputVariableName "pipelinePath" -Value $PipelinePath

# Carpenter.Pipeline.ScriptPath
$pipelineScriptPath = Set-CarpenterVariable -VariableName "Carpenter.Pipeline.ScriptPath" -OutputVariableName "pipelineScriptPath" -Value $PipelineScriptPath

# Carpenter.Pipeline.Reason (pipelineReason)
Write-Verbose "Validating Carpenter.Pipeline.Reason (pipelineReason)"
if ($BuildReason -eq "Manual") {
	$validReasons = "CI", "Prerelease", "Release"
	if (-not ($validReasons -contains $PipelineReason)) {
		Write-PipelineError "Unrecognized pipelineReason parameter '$PipelineReason'."
	}
} else {
	if ($PipelineReason -ne "CI") {
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


######################################################################################################################
# Pool Configuration
######################################################################################################################

# Validate defaultPool parameters

# Carpenter.Pool.Default.Type (defaultPoolType)
Write-Verbose "Validating Carpenter.Pool.Default.Type (defaultPoolType)"
if (-Not ($DefaultPoolType)) {
	Write-PipelineError "The defaultPoolType parameter must be supplied to Carpenter Azure Pipelines template."
}
if (($DefaultPoolType -ne "Hosted") -and ($DefaultPoolType -ne "Private")) {
	Write-PipelineError "Unrecognized defaultPoolType parameter '$DefaultPoolType'."
}
$defaultPoolType = Set-CarpenterVariable -VariableName "Carpenter.Pool.Default.Type" -OutputVariableName defaultPoolType -Value $DefaultPoolType


# Carpenter.Pool.Default.VMImage (defaultPoolVMImage)
Write-Verbose "Validating Carpenter.Pool.Default.VMImage (defaultPoolVMImage)"
if ($DefaultPoolType -eq "Hosted") {
	if (-Not ($DefaultPoolVMImage)) {
		Write-PipelineError "The defaultPoolVMImage parameter must be supplied to Carpenter Azure Pipelines template."
	}
	$defaultPoolVMImage = Set-CarpenterVariable -VariableName "Carpenter.Pool.Default.VMImage" -OutputVariableName defaultPoolVMImage -Value $DefaultPoolVMImage
} else {
	if ($DefaultPoolVMImage) {
		Write-PipelineWarning "The defaultPoolVMImage parameter '$DefaultPoolVMImage' is being ignored because defaultPoolType is not Hosted."
	}
}

# Carpenter.Pool.Default.Name (defaultPoolName)
Write-Verbose "Validating Carpenter.Pool.Default.Name (defaultPoolName)"
if ($DefaultPoolType -eq "Private") {
	if (-Not ($DefaultPoolName)) {
		Write-PipelineError "The defaultPoolName parameter must be supplied to Carpenter Azure Pipelines template when defaultPoolType is Private."
	}
	$defaultPoolName = Set-CarpenterVariable -VariableName "Carpenter.Pool.Default.Name" -OutputVariableName defaultPoolName -Value $DefaultPoolName
} else {
	if ($DefaultPoolName) {
		Write-PipelineWarning "The defaultPoolName parameter '$DefaultPoolName' is being ignored because defaultPoolType is not Private."
	}
}

# Carpenter.Pool.Default.Demands (defaultPoolDemands)
Write-Verbose "Validating Carpenter.Pool.Default.Demands (defaultPoolDemands)"
if ($DefaultPoolType -eq "Private") {
	$defaultPoolDemands = Set-CarpenterVariable -VariableName "Carpenter.Pool.Default.Demands" -OutputVariableName defaultPoolDemands -Value $($DefaultPoolDemands -replace "  ","" -replace "`n"," " -replace "`r","")
} else {
	if ($DefaultPoolDemands) {
		Write-PipelineWarning "The defaultPoolDemands parameter '$DefaultPoolDemands' is being ignored because defaultPoolType is not Private."
	}
}


######################################################################################################################
# Project Configuration
######################################################################################################################

# Carpenter.Project
if (-Not $Project) {
	$Project = $BuildDefinitionName
}
$project = Set-CarpenterVariable -VariableName "Carpenter.Project" -OutputVariableName "project" -Value $Project

# Carpenter.Project.Path
if ($ops -contains "ExcludePipeline") {
	$projectPath = "$AgentBuildDirectory/s"
} else {
	$projectPath = "$AgentBuildDirectory/s/$project"
}
$projectPath = Set-CarpenterVariable -VariableName "Carpenter.Project.Path"  -OutputVariableName "projectPath" -Value $projectPath

# Carpenter.Solution.Path
Write-Verbose "Validating Carpenter.Solution.Path"
if ($ops -contains "BuildDotNet") {
	if (-not ($SolutionPath)) { $SolutionPath = "$projectPath/$project.sln" } # Default value
	$solutionPath = Set-CarpenterVariable -VariableName "Carpenter.Solution.Path" -OutputVariableName "solutionPath" -Value $SolutionPath
} else {
	if ($SolutionPath) {
		Write-PipelineWarning "The Carpenter.Solution.Path variable '$SolutionPath' is being ignored because pipelineOperations does not contain BuildDotNet."
	}
}


######################################################################################################################
# Tools Configuration
######################################################################################################################

# Carpenter.DotNet.Path
if ($ops -contains "BuildDotNet") {
	# Carpenter.DotNet.Path
	$dotNetPath = Set-CarpenterVariable -VariableName "Carpenter.DotNet.Path" -OutputVariableName "dotNetPath" -Value "$AgentToolsDirectory/dotnet"
}


######################################################################################################################
# Output Paths
######################################################################################################################

if ($ops -contains "BuildDotNet") {

	# Carpenter.Output.Path
	$outputPath = Set-CarpenterVariable -VariableName "Carpenter.Output.Path" -OutputVariableName "outputPath" -Value "$SystemDefaultWorkingDirectory/out"

	# Carpenter.Output.Binaries.Path
	$binariesPath = Set-CarpenterVariable -VariableName "Carpenter.Output.Binaries.Path" -OutputVariableName "binariesPath" -Value "$outputPath/bin"

	if ($ops -contains "PackageNuGet") {

		# Carpenter.Output.NuGet.Path
		$nuGetPath = Set-CarpenterVariable -VariableName "Carpenter.Output.NuGet.Path" -OutputVariableName "nuGetPath" -Value "$outputPath/nuget"
	}

	if ($ops -contains "TestDotNet") {

		if ($ops -contains "CollectTestCoverage") {
			# Carpenter.Output.TestCoverage.Path
			$testCoveragePath = Set-CarpenterVariable -VariableName "Carpenter.Output.TestCoverage.Path" -OutputVariableName "testCoveragePath" -Value "$outputPath/testCoverage"
		}

		# Carpenter.Output.Tests.Path
		$testPath = Set-CarpenterVariable -VariableName "Carpenter.Output.Tests.Path" -OutputVariableName "testsPath" -Value "$outputPath/tests"
	}
}

######################################################################################################################
# Versioning
######################################################################################################################

if ($ops -contains "VersionSemVer") {

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

	# Carpenter.Version.VersionFile
	if (-not ($VersionFile)) { $VersionFile = "VERSION" } # Default value
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
