[CmdletBinding()]
param(
	[Parameter(Mandatory=$True)]
	[string] $PackagePath,
	[string] $ArtifactFeed = "https://pkgs.dev.azure.com",
	[string] $PersonalAccessToken = $env:CARPENTER_NUGET_QUALITY_TOKEN,
	[string] $Organization = $env:SYSTEM_COLLECTIONURI.Split('/')[-2],
	[string] $TeamProject = $env:SYSTEM_TEAMPROJECT,
	[Parameter(Mandatory=$True)]
	[string] $FeedName,
	[string] $PackageVersion = $env:CARPENTER_VERSION,
	[Parameter(Mandatory=$True)]
	[string] $PackageQuality,
	[string] $FeedScope = "Organization"
)

$ErrorActionPreference = "Stop"

[regex]$nameExpression = "(?<name>[^0-9]*)\."
$json = '{ "views": { "op":"add", "path":"/views/-", "value":"' + $PackageQuality + '" } }'
Write-Verbose -Message $json

try {
	Push-Location $PackagePath
	Get-ChildItem . -Filter *.nupkg | Foreach-Object {
	  $matches = $nameExpression.Match($_.Name)
	  $packageName = $matches.groups['name']
	  if ($FeedScope -eq "Organization") {
		  $requestUri = $ArtifactFeed + "/$Organization/_apis/packaging/feeds/$feedName/nuget/packages/$packageName/versions/$packageVersion" + "?api-version=7.1-preview.1"
	  } else {
		  $requestUri = $ArtifactFeed + "/$Organization/$TeamProject/_apis/packaging/feeds/$feedName/nuget/packages/$packageName/versions/$packageVersion" + "?api-version=7.1-preview.1"
	  }
	  Write-Verbose -Message $requestUri
	  $head = @{ Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN" }
	  $reponse = Invoke-RestMethod -Uri $requestUri -Headers $head -ContentType "application/json" -Method Patch -Body $json
	  Write-Verbose -Message "Response: '$reponse'"
	}
}
finally {
	Pop-Location
}
