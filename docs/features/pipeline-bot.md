# Carpenter.AzurePipelines PipelineBot

The PipelineBot is a service account used to manage external services.

The PipelineBot is used by the following operations:

* DeployBranch
* DeployNuGet
* AddGitTags
* IncrementVersionOnRelease

## PipelineBot Identity

The [`Carpenter.PipelineBot.Name`](../configuration.md#carpenterpipelinebotname) and
[`Carpenter.PipelineBot.Email`](../configuration.md#carpenterpipelinebotemail) variables can be used to identify the
pipeline bot.

If these values are omitted, details from the user who initiated the build will be used.

## Integrations

### Azure DevOps

The PipelineBot can integrate with Azure DevOps using the
[`PipelineBot-AzureDevOps-PAT`](../configuration.md#pipelinebot-azuredevops-pat) variable to hold a personal access token.

This integration is not currently used as the `System.AccessToken` variable provided by Azure DevOps works in every current integration.

### GitHub

The PipelineBot integrates with GitHub (github.com) using the
[`PipelineBot-GitHub-PAT`](../configuration#pipelinebot-github-pat)
variable to hold a personal access token. When using the Git CLI, the
[`Carpenter.PipelineBot.GitHub.Username`](../configuration.md#carpenteepipelinebotgithubusername) variable is used to
authenticate with GitHub.

### NuGet

The PipelineBot integrates with NuGet (nuget.org) using the
[`PipelineBot-NuGet-PAT`](../configuration.md#pipelinebot-nuget-pat)
variable to hold a personal access token.
