[CmdletBinding()]
param(
    [string] $AgentBuildDirectory = $env:AGENT_BUILDDIRECTORY,
    [string] $BuildRepositoryUri = $env:BUILD_REPOSITORY_URI,
    [string] $BuildSourceBranch = $env:BUILD_SOURCEBRANCH,
    [string] $BuildSourceVersion = $env:BUILD_SOURCEVERSION,
    [string] $HttpProxy = $env:http_proxy,
    [string] $HttpsProxy = $env:https_proxy,
    [string] $PipelineBotGitHubUsername = $env:CARPENTER_PIPELINEBOT_GITHUB_USERNAME,
    [string] $PipelineBotGitHubToken = $env:CARPENTER_PIPELINEBOT_GITHUB_TOKEN,
    [string] $PipelineBotName = $env:CARPENTER_PIPELINEBOT_NAME,
    [string] $PipelineBotEmail = $env:CARPENTER_PIPELINEBOT_EMAIL,
    [string] $VersionPatch = $env:CARPENTER_VERSION_PATCH,
    [string] $VersionMajor = $env:CARPENTER_VERSION_MAJOR,
    [string] $VersionMinor = $env:CARPENTER_VERSION_MINOR,
    [string] $VersionFile = $env:CARPENTER_VERSION_VERSIONFILE
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"


# determine new version
$newPatch = ([int]$VersionPatch) + 1
$newVersion = "$($VersionMajor).$($VersionMinor).$newPatch"
Write-Host "Updating project version to $newVersion"

# create working directory
$workingDirectory = "$AgentBuildDirectory/bot-project"
if (Test-Path $workingDirectory) {
    Remove-Item -Path $workingDirectory -Recurse -Force
}
New-Item -Path $workingDirectory -ItemType Directory
Push-Location $workingDirectory
Write-Host "Current path: $workingDirectory"
        
# initialize repository
git config --global init.defaultBranch main
git init "$workingDirectory"
git config advice.detachedHead false

$buildRepositoryUri = $BuildRepositoryUri -replace "github.com","$($PipelineBotGitHubUsername):$($PipelineBotGitHubToken)@github.com"

git config user.email "$PipelineBotEmail"
git config user.name "$PipelineBotName"

# configure proxy
if ($HttpProxy) {
    git config http.proxy "$HttpProxy"
}
if ($HttpsProxy) {
    git config https.proxy "$HttpsProxy"
}

# clone repository
git remote add origin $buildRepositoryUri
git config gc.auto 0
git fetch --force --tags --prune --prune-tags --progress --no-recurse-submodules origin
git fetch --force --tags --prune --prune-tags --progress --no-recurse-submodules origin  +$BuildSourceVersion
git checkout --progress --force $BuildSourceVersion

# update VERSION file
$versionFile = "./$VersionFile"
Write-Host "Using VERSION file: $versionFile"
Set-Content -Path $versionFile -Value $newVersion -NoNewLine

# commit changes
git add .
git commit -m "Updating VERSION to $newVersion ***NO_CI***"
git push origin HEAD:$BuildSourceBranch

Pop-Location
