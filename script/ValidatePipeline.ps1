#Requires -Version 3
<#
	.SYNOPSIS
	
	Validates the pipeline.
#>

[CmdletBinding()]
param(
	[string] $BuildReason = $env:BUILD_REASON,
	[string] $PipelineVersion = $env:CARPENTER_PIPELINEVERSION,
	[string] $BuildType = $env:CARPENTER_BUILD_TYPE,
	[string] $Project = $env:CARPENTER_PROJECT,
	[string] $DefaultPoolType = $env:CARPENTER_POOL_DEFAULT_TYPE,
	[string] $DefaultPoolName = $env:CARPENTER_POOL_DEFAULT_NAME,
	[string] $DefaultPoolDemands = $env:CARPENTER_POOL_DEFAULT_DEMANDS,
	[string] $DefaultPoolVMImage = $env:CARPENTER_POOL_DEFAULT_VMIMAGE,
	[string] $BuildVersionType = $env:CARPENTER_VERSION_TYPE,
	[string] $BuildVersionFile = $env:CARPENTER_VERSION_VERSIONFILE,
	[string] $RevisionOffset = $env:CARPENTER_VERSION_REVISIONOFFSET
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"

Write-Verbose "Validating pipelineVersion"
if ((-not ($PipelineVersion | IsNumeric -Verbose:$false)) -or (-not ($PipelineVersion -gt 0))) {
	Write-PipelineError "The pipelineVersion parameter must be supplied to Carpenter Azure Pipelines template."
}

Write-Verbose "Validating buildType"
if ($BuildReason -eq "Manual") {
	if (($BuildType -ne "CI") -and ($BuildType -ne "Prerelease")) {
		Write-PipelineError "Unrecognized buildType parameter '$BuildType'."
	}
} else {
	if ($BuildType -ne "") {
		Write-PipelineWarning "The buildType parameter '$BuildType' is being ignored because Build.Reason is not Manual."
	}
}

Write-Verbose "Validating project"
if (-Not ($Project)) {
	Write-PipelineError "The project parameter must be supplied to Carpenter Azure Pipelines template."
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
		Write-Warning "The defaultPoolName parameter '$DefaultPoolName' is being ignored because defaultPoolType is not Private."
	}
}

Write-Verbose "Validating defaultPoolDemands"
if ($DefaultPoolType -eq "Private") {
	if (($DefaultPoolDemands -ne "True") -and ($DefaultPoolDemands -ne "False")) {
		Write-PipelineError "The defaultPoolDemands parameter must either be True or False."
	}
} else {
	if ($DefaultPoolDemands) {
		Write-Warning "The defaultPoolDemands parameter '$DefaultPoolDemands' is being ignored because defaultPoolType is not Private."
	}
}

Write-Verbose "Validating defaultPoolVMImage"
if ($DefaultPoolType -eq "Hosted") {
	if (-Not ($DefaultPoolVMImage)) {
		Write-PipelineError "The defaultPoolVMImage parameter must be supplied to Carpenter Azure Pipelines template."
	}
} else {
	if ($DefaultPoolVMImage) {
		Write-Warning "The defaultPoolVMImage parameter '$DefaultPoolVMImage' is being ignored because defaultPoolType is not Hosted."
	}
}

Write-Verbose "Validating buildVersionType"
if (-Not ($BuildVersionType)) {
	Write-PipelineError "The buildVersionType parameter must be supplied to Carpenter Azure Pipelines template."
} else {
	if (($BuildVersionType -ne "None") -and ($BuildVersionType -ne "SemVer")) {
		Write-PipelineError "Unrecognized buildVersionType parameter '$BuildVersionType'."
	}
}

Write-Verbose "Validating buildVersionFile"
if (-Not ($BuildVersionFile)) {
	Write-PipelineError "The buildVersionFile parameter must be supplied to Carpenter Azure Pipelines template."
}

Write-Verbose "Validating revisionOffset"
if ((-not ($RevisionOffset | IsNumeric -Verbose:$false)) -or (-not ($RevisionOffset -ge 0))) {
	Write-PipelineError "The revisionOffset parameter must be supplied to Carpenter Azure Pipelines template."
}

Write-Verbose "Validating prereleaseLabel"
if ($BuildType -eq "Prerelease") {
	if (-Not ($PrereleaseLabel)) {
		Write-PipelineError "The prereleaseLabel parameter must be supplied to Carpenter Azure Pipelines template."
	}
} else {
	if ($PrereleaseLabel) {
		Write-Warning "The prereleaseLabel parameter '$PrereleaseLabel' is being ignored because buildType is not Prerelease."
	}
}
