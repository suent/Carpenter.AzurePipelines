#Requires -Version 3
<#
	.SYNOPSIS
	
	Validates the pipeline.
#>

[CmdletBinding()]
param(
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
