
Function Write-ScriptHeader {
	param(
		[string] $Name
	)
	Write-Verbose "$Name"
}

Function Set-CarpenterVariable {
	param(
		[string] $VariableName,
		[object] $Value
	)
	Write-Verbose "$VariableName: $Value"
	Write-Host "##vso[task.setvariable variable=$VariableName]$Value"
	Write-Host "##vso[task.setvariable variable=$VariableName;isOutput=true]$Value"
}