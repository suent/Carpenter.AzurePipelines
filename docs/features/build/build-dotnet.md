# Build using .NET Core (dotnet)

Carpenter.AzurePipelines enables building a project using .NET Core.

## Enabling .NET Core build

To enable .NET core build, pass the [**BuildDotNet**](../../operations.md#builddotnet) operation to the
[`pipelineOperations`](../configuration.md#carpenterpipelineoperations-pipelineoperations) parameter:

```
stages:
- template: template/carpenter-default.yml
  parameters:
    pipelineOperations:
    - BuildDotNet
```

## Build Output

In the Build job, after the build has completed the build output can be found in the path specified by the
[`Carpenter.Output.Binaries.Path`](../../configuration.md#carpenteroutputbinariespath) variable.

## Binaries Artifact

A `binaries` artifact is created and attached to the pipeline.
