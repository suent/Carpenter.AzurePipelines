#Requires -Version 3
<#
	.SYNOPSIS
	
	Initializes the pipeline.
#>

[CmdletBinding()]
param(
	[string] $BuildReason = $env:BUILD_REASON,
	[string] $BuildType = $env:CARPENTER_BUILD_TYPE
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"

If (($BuildReason -eq "IndividualCI") -or ($BuildReason -eq "BatchedCI") -or (($BuildReason -eq "Manual") -and ($BuildType -eq "Manual")) {
	$buildType = Set-CarpenterVariable -VariableName "Carpenter.Build.Type" -Value "CI"
} 
ElseIf ($BuildReason -eq "PullRequest") {
	$buildType = Set-CarpenterVariable -VariableName "Carpenter.Build.Type" -Value "PR"
}
Else {
	Write-PipelineError "Build type not implemented. BuildReason=$BuildReason, BuildType=$BuildType"
}