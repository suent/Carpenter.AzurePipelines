[CmdletBinding()]
param(
    [string] $AgentBuildDirectory = $env:AGENT_BUILDDIRECTORY,
    [string] $BuildRepositoryUri = $env:BUILD_REPOSITORY_URI,
    [string] $BuildSourceBranch = $env:BUILD_SOURCEBRANCH,
    [string] $BuildSourceVersion = $env:BUILD_SOURCEVERSION,
    [string] $HttpProxy = $env:http_proxy,
    [string] $HttpsProxy = $env:https_proxy,
    [string] $PipelineBotName = $env:CARPENTER_PIPELINEBOT_NAME,
    [string] $PipelineBotEmail = $env:CARPENTER_PIPELINEBOT_EMAIL,
    [string] $PipelineBotGitHubUsername = $env:CARPENTER_PIPELINEBOT_GITHUB_USERNAME,
    [string] $PipelineBotGitHubToken = $env:CARPENTER_PIPELINEBOT_GITHUB_TOKEN,
    [string] $Version = $env:CARPENTER_VERSION
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"


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

# add tags
git tag v$($Version)

# push tags
git push --tags origin HEAD:$BuildSourceBranch

Pop-Location
