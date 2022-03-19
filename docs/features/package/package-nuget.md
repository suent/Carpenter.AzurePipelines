# Package using NuGet

Carpenter.AzurePipelines enables packaging a project using NuGet.

## Enabling NuGet packages

To enable NuGet packages, pass the [**PackageNuGet**](../../operations.md#packagenuget) operation to the
[`pipelineOperations`](../../configuration.md#carpenterpipelineoperations-pipelineoperations) parameter:

```
stages:
- template: template/carpenter-default.yml
  parameters:
    pipelineOperations:
    - BuildDotNet # Required for PackageNuGet
    - PackageNuGet
```

## Build Output

In the Build job, after the package has been created it can be found in the path specified by the
[`Carpenter.Output.NuGet.Path`](../../configuration.md#carpenteroutputnugetpath) variable.

## NuGet Artifact

A `package.nuget` artifact is created and attached to the pipeline.

## See Also

* [Deploying a NuGet Package](../deploy/deploy-nuget.md)
* [Update Package Quality](../integrations/azure-devops/update-package-quality.md)
