# Carpenter.AzurePipelines PipelineBot

The PipelineBot is a service account used to manage external services.

The PipelineBot is used by the following operations:

* DeployBranch
* AddGitTags
* IncrementVersionOnRelease

## PipelineBot Identity

The `Carpenter.PipelineBot.Name` and `Carpenter.PipelineBot.Email` variables can be used to identify the pipeline bot.

If these values are omitted, details from the user who initiated the build will be used.
