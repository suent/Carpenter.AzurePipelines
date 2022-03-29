# Deploy NuGet Package(s)

DeployNuGet publishes NuGet package(s) to a NuGet feed.

## Enabling Deploy NuGet

To enable deploy NuGet, pass the [**DeployNuGet**](../../operations.md#deploynuget) operation to the
[`pipelineOperations`](../../configuration.md#carpenterpipelineoperations-pipelineoperations) parameter:

```
variables:
  "Carpenter.Deploy.NuGet.TargetFeed.Dev": AzureArtifacts
  "Carpenter.Deploy.NuGet.TargetFeed.Stage": github.com
  "Carpenter.Deploy.NuGet.TargetFeed.Prod": nuget.org
stages:
- template: template/carpenter-default.yml
  parameters:
    pipelineOperations:
    - DeployNuGet
    deployNuGet: dev,stage,prod
```
The `deployNuGet` parameter contains a comma separated list of stacks this operation executes against.
