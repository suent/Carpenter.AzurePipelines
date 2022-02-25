# Deploying projects using Carpenter.AzurePipelines

Carpenter.AzurePipelines allows for projects to be deployed in a consistent manner. This includes most aspects of a deployment: naming conventions, project versioning, stack layouts, tools and much more.

## Deploy Branch

The `deployBranch` parameter allows a branch of the source base to be published during a build. An example of its purpose is the Carpenter.AzurePipelines project itself. Pull requests get changes into master,
but those changes aren't necessarily included in a 'release' until pushed by the project manager/team. Other pipelines using templates from Carpenter.AzurePipelines can target the stack/prod branch to ensure
that they only receive code that has been deployed to production.

## Deploy NuGet Package

The `deployNuGet` parameter allows NuGet packages created by the build to be published to Azure Artifacts or a third-part NuGet feed.
