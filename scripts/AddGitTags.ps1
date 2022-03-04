[CmdletBinding()]
param(
    [string] $Version = $env:CARPENTER_VERSION,
    [string] $AgentBuildDirectory = $env:AGENT_BUILDDIRECTORY,
    [string] $PipelineBotTokenSecret = $env:CARPENTER_PIPELINEBOT_TOKENSECRET,
    [string] $PipelineBotToken = $env:CARPENTER_PIPELINEBOT_TOKEN,
    [string] $RepositoryUri = $env:BUILD_REPOSITORY_URI,
    [string] $PipelineBot = $env:CARPENTER_PIPELINEBOT,
    [string] $PipelineBotName = $env:CARPENTER_PIPELINEBOT_NAME,
    [string] $PipelineBotEmail = $env:CARPENTER_PIPELINEBOT_EMAIL,
    [string] $RequestedFor = $env:BUILD_REQUESTEDFOR,
    [string] $RequestedForEmail = $env:BUILD_REQUESTEDFOREMAIL,
    [string] $SourceVersion = $env:BUILD_SOURCEVERSION,
    [string] $SourceBranch = $env:BUILD_SOURCEBRANCH,
    [string] $HttpProxy = $env:http_proxy,
    [string] $HttpsProxy = $env:https_proxy
)

$scriptName = Split-Path $PSCommandPath -Leaf

. "$PSScriptRoot/include/Carpenter.AzurePipelines.Common.ps1"

Write-ScriptHeader "$scriptName"


# create working directory
$workingDirectory = "$AgentBuildDirectory/bot-project"
New-Item -Path $workingDirectory -ItemType Directory
Push-Location $workingDirectory
Write-Host "Current path: $workingDirectory"
        
# initialize repository
git config --global init.defaultBranch main
git init "$workingDirectory"
git config advice.detachedHead false

# determine authorization
if ($PipelineBotTokenSecret) {
    if ($PipelineBotTokenSecret -eq "`$(PipelineBot-GitHub-PAT)") {
        Write-PipelineError "The PipelineBot-GitHub-PAT secret variable could not be found."
    }
    Write-Host "Using: PipelineBot-GitHub-PAT"
    $token = $PipelineBotTokenSecret
} else {
    Write-Host "Using: Carpenter.PipelineBot.Token"
    $token = $PipelineBotToken
}
$repositoryUri = $repositoryUri -replace "github.com","$($PipelineBot):$($token)@github.com"

# configure user
if ($PipelineBotName -and $PipelineBotEmail) {
    $gitUserEmail = $PipelineBotEmail
    $gitUser = $PipelineBotName
} else {
    $gitUserEmail = $RequestedForEmail
    $gitUser = $RequestedFor
}
git config user.email "$gitUserEmail"
git config user.name "$gitUser"

# configure proxy
if ($HttpProxy) {
    git config http.proxy "$HttpProxy"
}
if ($HttpsProxy) {
    git config https.proxy "$HttpsProxy"
}

# clone repository
git remote add origin $repositoryUri
git config gc.auto 0
git fetch --force --tags --prune --prune-tags --progress --no-recurse-submodules origin
git fetch --force --tags --prune --prune-tags --progress --no-recurse-submodules origin  +$SourceVersion
git checkout --progress --force $SourceVersion

# add tags
git tag v$($Version)

# push tags
git push --tags origin HEAD:$SourceBranch

Pop-Location