#Requires -Version 3
<#
	.SYNOPSIS
	
	Validates the pipeline.
#>

[CmdletBinding()]
param(
	[string] $BuildReason = $env:BUILD_REASON,
	[string] $PipelineVersion = $env:CARPENTER_PIPELINEVERSION,
	[string] $BuildType = $env:CARPENTER_BUILD_TYPE
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
