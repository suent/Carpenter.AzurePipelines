[CmdletBinding()]
param(
    [string] $VersionPatch = $env:CARPENTER_VERSION_PATCH,
    [string] $VersionMajor = $env:CARPENTER_VERSION_MAJOR,
    [string] $VersionMinor = $env:CARPENTER_VERSION_MINOR,
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
    [string] $VersionFile = $env:CARPENTER_VERSION_VERSIONFILE,
    [string] $SourceBranch = $env:BUILD_SOURCEBRANCH,
    [string] $HttpProxy = $env:http_proxy,
    [string] $HttpsProxy = $env:https_proxy,
    [string] $Stack
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

git push origin HEAD:branch-stack-$($Stack -Replace "_","-")

Pop-Location