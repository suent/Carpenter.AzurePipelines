# Deploying projects using Carpenter.AzurePipelines

Carpenter.AzurePipelines allows for projects to be deployed in a consistent manner. This includes most aspects of a
deployment: naming conventions, project versioning, stack layouts, tools and much more.

The [`pipelineOperations`](../configuration.md#carpenterpipelineoperations-pipelineoperations) parameter determines
which deployments are executed. More information can be found below.

## Deploy Branch

Deploys the branch to a new branch in the repository.

For more information, see [deploy-branch.md](deploy/deploy-branch.md).

## Deploy NuGet Package

Deploys a NuGet package to a NuGet package feed.

For more information, see [deploy-nuget.md](deploy/deploy-nuget.md).
