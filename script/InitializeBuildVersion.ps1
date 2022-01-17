#Requires -Version 3
<#
	.SYNOPSIS
	
	Initializes the build version.
#>

[CmdletBinding()]
param(
	[string] $SourcesDirectory = $env:BUILD_SOURCESDIRECTORY,
	[string] $VersionFile = $env:CARPENTER_VERSION_VERSIONFILE
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"

$versionFilePath = "$SourcesDirectory/$VersionFile"
If (-Not (Test-Path -Path $versionFilePath -PathType Leaf)) {
	Write-Error "VERSION file does not exist at expected path. Path: $versionFilePath"
} else {
	Write-Verbose "Using version file: $versionFilePath"
	$targetVersion = Get-Content -Path $versionFilePath
	Write-Verbose "Base Version: $targetVersion"
	$version = [Version]::new($targetVersion)
	$baseVersion = Set-CarpenterVariable -VariableName "Carpenter.Version.BaseVersion" -Value "$($version.Major).$($version.Minor).$($version.Build)"
	$majorVersion = Set-CarpenterVariable -VariableName "Carpenter.Version.Major" -Value $version.Major
	$minorVersion = Set-CarpenterVariable -VariableName "Carpenter.Version.Minor" -Value $version.Minor
	$patchVersion = Set-CarpenterVariable -VariableName "Carpenter.Version.Patch" -Value $version.Build
}

