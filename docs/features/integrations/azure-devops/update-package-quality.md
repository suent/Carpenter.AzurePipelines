# Update Package Quality

Adds views to packages in Azure Artifacts to denote the quality of the package.

| View | Description |
|:-----|:------------|
| Prerelease | Packages which have not been released to the public.
| Release | Packages which have been released to the public, even prerelease versions.

## Enabling Update Package Quality

To update the package quality, pass the [**UpdateNuGetQuality**](../../operations.md#updatenugetquality) operation to the
[`pipelineOperations`](../../configuration.md#carpenterpipelineoperations-pipelineoperations) parameter:

```
variables:
  "Carpenter.NuGet.Quality.Feed": feedName
  "Carpenter.NuGet.Quality.Stage": Prerelease
  "Carpenter.NuGet.Quality.Prod": Release
stages:
- template: template/carpenter-default.yml
  parameters:
    pipelineOperations:
    - UpdateNuGetQuality
    updateNuGetQuality: stage,prod
```
The `updateNuGetQuality` parameter contains a comma separated list of stacks this operation executes against.
