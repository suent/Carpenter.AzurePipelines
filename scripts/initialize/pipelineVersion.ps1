Write-Verbose "Validating pipelineVersion"
if ((-not ($PipelineVersion | IsNumeric -Verbose:$false)) -or (-not ($PipelineVersion -gt 0))) {
	Write-PipelineError "The pipelineVersion parameter must be supplied to Carpenter Azure Pipelines template."
}

$pipelineVersion = Set-CarpenterVariable -VariableName "Carpenter.PipelineVersion" -OutputVariableName "pipelineVersion" -Value $PipelineVersion
