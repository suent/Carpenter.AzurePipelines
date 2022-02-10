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
    [string] $SourceBranch = $env:BUILD_SOURCEBRANCH
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
New-Item -Path $workingDirectory -ItemType Directory
Push-Location $workingDirectory
Write-Host "Current path: $workingDirectory"
        
# initialize repository
$repositoryUri = $repositoryUri -replace "github.com","$($PipelineBot)@github.com"
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

$encodedAuthorization = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$token"))
$authorizationHeader = "AUTHORIZATION: Basic $encodedAuthorization"
git config --add http.$repositoryUri/.extraHeader $authorizationHeader

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

# clone repository
git remote add origin $repositoryUri
git config gc.auto 0
git fetch --force --tags --prune --prune-tags --progress --no-recurse-submodules origin
git fetch --force --tags --prune --prune-tags --progress --no-recurse-submodules origin  +$SourceVersion
git checkout --progress --force $SourceVersion

# update VERSION file
$versionFile = "./$VersionFile"
Write-Host "Using VERSION file: $versionFile"
Set-Content -Path $versionFile -Value $newVersion -NoNewLine

# commit changes
git add .
git commit -m "Updating VERSION to $newVersion ***NO_CI***"
git push origin HEAD:$SourceBranch

Pop-Location