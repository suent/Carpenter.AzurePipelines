
Function Write-ScriptHeader {
	param(
		[string] $Name
	)
	Write-Verbose "$Name"
}

Function Set-CarpenterVariable {
	param(
		[string] $OutputVariableName,
		[string] $VariableName,
		[object] $Value
	)
	If ($VariableName) {
		Write-Verbose "$($VariableName): $Value"
		Write-Host "##vso[task.setvariable variable=$VariableName]$Value" 
	} elseif ($OutputVariableName) {
		Write-Verbose "$($OutputVariableName): $Value"
	}
	if ($OutputVariableName) { Write-Host "##vso[task.setvariable variable=$OutputVariableName;isOutput=true]$Value" }
	return $Value
}

Function Write-PipelineError {
	param(
		[string] $Message
	)
    Write-Host "##vso[task.logissue type=error]$Message"
	Throw $Message
}