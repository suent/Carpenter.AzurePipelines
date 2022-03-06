#Requires -Version 3
<#
	.SYNOPSIS
	
	Validates the pipeline.
#>

[CmdletBinding()]
param(
	[string] $BuildReason = $env:BUILD_REASON,
	[string] $PipelineVersion = $env:CARPENTER_PIPELINEVERSION,
	[string] $PipelineReason = $env:CARPENTER_PIPELINE_REASON,
	[string] $DefaultPoolType = $env:CARPENTER_POOL_DEFAULT_TYPE,
	[string] $DefaultPoolName = $env:CARPENTER_POOL_DEFAULT_NAME,
	[string] $DefaultPoolDemands = $env:CARPENTER_POOL_DEFAULT_DEMANDS,
	[string] $DefaultPoolVMImage = $env:CARPENTER_POOL_DEFAULT_VMIMAGE,
	[string] $versionType = $env:CARPENTER_VERSION_TYPE,
	[string] $versionFile = $env:CARPENTER_VERSION_VERSIONFILE,
	[string] $RevisionOffset = $env:CARPENTER_VERSION_REVISIONOFFSET,
	[string] $PrereleaseLabel = $env:CARPENTER_PRERELEASE_LABEL,
	[string] $BuildDotNet = $env:CARPENTER_BUILD_DOTNET,
	[string] $ExecuteUnitTests = $env:CARPENTER_TEST_UNIT,
	[string] $SonarCloud = $env:CARPENTER_SONARCLOUD,
	[string] $SonarCloudOrganization = $env:CARPENTER_SONARCLOUD_ORGANIZATION,
	[string] $SonarCloudProjectKey = $env:CARPENTER_SONARCLOUD_PROJECTKEY,
	[string] $SonarCloudServiceConnection = $env:CARPENTER_SONARCLOUD_SERVICECONNECTION,
	[string] $deployNuGet = $env:CARPENTER_DEPLOY_NUGET,
	[string] $nuGetTargetFeedDev = $env:CARPENTER_DEPLOY_NUGET_TARGETFEED_DEV,
	[string] $nuGetTargetFeedTest1 = $env:CARPENTER_DEPLOY_NUGET_TARGETFEED_TEST1,
	[string] $nuGetTargetFeedTest2 = $env:CARPENTER_DEPLOY_NUGET_TARGETFEED_TEST2,
	[string] $nuGetTargetFeedStage = $env:CARPENTER_DEPLOY_NUGET_TARGETFEED_STAGE,
	[string] $nuGetTargetFeedProd = $env:CARPENTER_DEPLOY_NUGET_TARGETFEED_PROD,
	[string] $UpdateNuGetQuality = $env:CARPENTER_NUGET_QUALITY,
	[string] $NuGetQualityFeed = $env:CARPENTER_NUGET_QUALITY_FEED,
	[string] $NuGetQualityDev = $env:CARPENTER_NUGET_QUALITY_DEV,
	[string] $NuGetQualityTest1 = $env:CARPENTER_NUGET_QUALITY_TEST1,
	[string] $NuGetQualityTest2 = $env:CARPENTER_NUGET_QUALITY_TEST2,
	[string] $NuGetQualityStage = $env:CARPENTER_NUGET_QUALITY_STAGE,
	[string] $NuGetQualityProd = $env:CARPENTER_NUGET_QUALITY_PROD
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"

Write-Verbose "Validating pipelineVersion"
if ((-not ($PipelineVersion | IsNumeric -Verbose:$false)) -or (-not ($PipelineVersion -gt 0))) {
	Write-PipelineError "The pipelineVersion parameter must be supplied to Carpenter Azure Pipelines template."
}

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

Write-Verbose "Validating versionType"
if (-Not ($VersionType)) {
	Write-PipelineError "The versionType parameter must be supplied to Carpenter Azure Pipelines template."
} else {
	if (($VersionType -ne "None") -and ($VersionType -ne "SemVer")) {
		Write-PipelineError "Unrecognized versionType parameter '$VersionType'."
	}
}

if ($VersionType -ne "None") {
	Write-Verbose "Validating versionFile"
	if (-Not ($VersionFile)) {
		Write-PipelineError "The versionFile parameter must be supplied to Carpenter Azure Pipelines template."
	}

	Write-Verbose "Validating revisionOffset"
	if ((-not ($RevisionOffset | IsNumeric -Verbose:$false)) -or (-not ($RevisionOffset -ge 0))) {
		Write-PipelineError "The revisionOffset parameter must be supplied to Carpenter Azure Pipelines template."
	}

	Write-Verbose "Validating prereleaseLabel"
	if ($PipelineReason -eq "Prerelease") {
		if (-Not ($PrereleaseLabel)) {
			Write-PipelineError "The prereleaseLabel parameter must be supplied to Carpenter Azure Pipelines template."
		}
	} else {
		if ($PrereleaseLabel) {
			Write-PipelineWarning "The prereleaseLabel parameter '$PrereleaseLabel' is being ignored because pipelineReason is not Prerelease."
		}
	}
}

Write-Verbose "Validating executeUnitTests"
if (($ExecuteUnitTests -eq "true") -and ($BuildDotNet -ne "true")) {
	Write-PipelineWarning "The executeUnitTests parameter is being ignored because buildDotNet is not true."
}

if ($SonarCloud -eq "true") {
	Write-Verbose "Validating sonarCloudOrganization"
	if (-Not ($SonarCloudOrganization)) {
		Write-PipelineError "The sonarCloudOrganization parameter is required when sonarCloud is true."
	}

	Write-Verbose "Validating sonarCloudProjectKey"
	if (-Not ($SonarCloudProjectKey)) {
		Write-PipelineError "The sonarCloudProjectKey parameter is required when sonarCloud is true."
	}

	Write-Verbose "Validating sonarCloudServiceConnection"
	if (-Not ($SonarCloudServiceConnection)) {
		Write-PipelineError "The sonarCloudServiceConnection parameter is required when sonarCloud is true."
	}
}

if ((($DeployNuGet -Split ",").Trim()) -Contains "dev") {
	Write-Verbose "Validating nuGetTargetFeedDev"
	if (-Not ($NuGetTargetFeedDev)) {
		Write-PipelineError "The nuGetTargetFeedDev parameter is required when deployNuGet contains dev."
	}
}

if ((($DeployNuGet -Split ",").Trim()) -Contains "test1") {
	Write-Verbose "Validating nuGetTargetFeedTest1"
	if (-Not ($NuGetTargetFeedTest1)) {
		Write-PipelineError "The nuGetTargetFeedDev parameter is required when deployNuGet contains test1."
	}
}

if ((($DeployNuGet -Split ",").Trim()) -Contains "test2") {
	Write-Verbose "Validating nuGetTargetFeedTest2"
	if (-Not ($NuGetTargetFeedTest2)) {
		Write-PipelineError "The nuGetTargetFeedDev parameter is required when deployNuGet contains test2."
	}
}

if ((($DeployNuGet -Split ",").Trim()) -Contains "stage") {
	Write-Verbose "Validating nuGetTargetFeedStage"
	if (-Not ($NuGetTargetFeedStage)) {
		Write-PipelineError "The nuGetTargetFeedStage parameter is required when deployNuGet contains stage."
	}
}

if ((($DeployNuGet -Split ",").Trim()) -Contains "prod") {
	Write-Verbose "Validating nuGetTargetFeedProd"
	if (-Not ($NuGetTargetFeedProd)) {
		Write-PipelineError "The nuGetTargetFeedDev parameter is required when deployNuGet contains prod."
	}
}

if ($UpdateNuGetQuality) {
	Write-Verbose "Validating nuGetQualityFeed"
	if (-Not ($NuGetQualityFeed)) {
		Write-PipelineError "The nuGetQualityFeed parameter is required when updateNuGetQuality is populated."
	}
}

if ((($UpdateNuGetQuality -Split ",").Trim()) -Contains "dev") {
	Write-Verbose "Validating nuGetQualityDev"
	if (-Not ($NuGetQualityDev)) {
		Write-PipelineError "The nuGetQualityDev parameter is required when updateNuGetQuality contains dev."
	}
}

if ((($UpdateNuGetQuality -Split ",").Trim()) -Contains "test1") {
	Write-Verbose "Validating nuGetQualityTest1"
	if (-Not ($NuGetQualityTest1)) {
		Write-PipelineError "The nuGetQualityTest1 parameter is required when updateNuGetQuality contains test1."
	}
}

if ((($UpdateNuGetQuality -Split ",").Trim()) -Contains "test2") {
	Write-Verbose "Validating nuGetQualityTest2"
	if (-Not ($NuGetQualityTest2)) {
		Write-PipelineError "The nuGetQualityTest2 parameter is required when updateNuGetQuality contains test2."
	}
}

if ((($UpdateNuGetQuality -Split ",").Trim()) -Contains "stage") {
	Write-Verbose "Validating nuGetQualityStage"
	if (-Not ($NuGetQualityStage)) {
		Write-PipelineError "The nuGetQualityStage parameter is required when updateNuGetQuality contains stage."
	}
}

if ((($UpdateNuGetQuality -Split ",").Trim()) -Contains "prod") {
	Write-Verbose "Validating nuGetQualityProd"
	if (-Not ($NuGetQualityProd)) {
		Write-PipelineError "The nuGetQualityProd parameter is required when updateNuGetQuality contains prod."
	}
}
