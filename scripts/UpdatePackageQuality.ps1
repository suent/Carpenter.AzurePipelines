[CmdletBinding()]
param(
	[Parameter(Mandatory=$True)]
	[string] $PackagePath,
	[string] $CollectionUri = $env:SYSTEM_COLLECTIONURI,
	[Parameter(Mandatory=$True)]
	[string] $FeedName,
	[string] $PackageVersion = $env:CARPENTER_VERSION,
	[Parameter(Mandatory=$True)]
	[string] $PackageQuality
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
	  $requestUri = $CollectionUri + "/_apis/packaging/feeds/$feedName/nuget/packages/$packageName/versions/$packageVersion" + "?api-version=5.0-preview.1"
	  Write-Verbose -Message $requestUri
	  $head = @{ Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN" }
	  $reponse = Invoke-RestMethod -Uri $requestUri -Headers $head -ContentType "application/json" -Method Patch -Body $json
	  Write-Verbose -Message "Response: '$reponse'"
	}
}
finally {
	Pop-Location
}

