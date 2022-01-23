#Requires -Version 3
<#
	.SYNOPSIS
	
	Validates the pipeline.
#>

[CmdletBinding()]
param(
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"

Write-Verbose "Validating pipelineVersion"
if (-not ($env:CARPENTER_PIPELINEVERSION -gt 0)) {
	Write-PipelineError "The pipelineVersion parameter must be supplied to Carpenter Azure Pipelines template."
}
