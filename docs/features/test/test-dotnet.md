# Testing using .NET Core (dotnet)

Carpenter.AzurePipelines enables testing a project using .NET Core.

## Enabling .NET Core testing

To enable .NET core testing, pass the [**TestDotNet**](../../operations.md#testdotnet) operation to the
[`pipelineOperations`](../../configuration.md#carpenterpipelineoperations-pipelineoperations) parameter:

```
stages:
- template: template/carpenter-default.yml
  parameters:
    pipelineOperations:
    - BuildDotNet # Required for TestDotNet
    - TestDotNet
```

## Test Output

In the Build job, after the build has completed the build output can be found in the path specified by the
[`Carpenter.Output.Tests.Path`](../../configuration.md#carpenteroutputtestspath) variable.

## TestCoverage 

To enable test coverage, pass the [**CollectTestCoverage**](../../operations.md#collecttestcoverage) operation to the
[`pipelineOperations`](../../configuration.md#carpenterpipelineoperations-pipelineoperations) parameter:

### TestCoverage Output

In the Build job, after the build has completed the build output can be found in the path specified by the
[`Carpenter.Output.Tests.Path`](../../configuration.md#carpenteroutputtestspath) variable.
