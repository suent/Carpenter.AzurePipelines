#Requires -Version 3
<#
	.SYNOPSIS
	
	Initializes the pipeline.
#>

[CmdletBinding()]
param(
	[string] $BuildReason = $env:BUILD_REASON
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"

If (($BuildReason -eq "IndividualCI") -or ($BuildReason -eq "BatchedCI")) {
	$buildType = Set-CarpenterVariable -VariableName "Carpenter.Build.Type" -Value "CI"
} 
ElseIf ($BuildReason -eq "PullRequest") {
	$buildType = Set-CarpenterVariable -VariableName "Carpenter.Build.Type" -Value "PR"
}
