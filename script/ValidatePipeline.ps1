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
    Write-Host "##vso[task.logissue type=error]The pipelineVersion parameter must be supplied to Carpenter Azure Pipelines template."
    Throw "The pipelineVersion parameter must be supplied to Carpenter Azure Pipelines template."
}
