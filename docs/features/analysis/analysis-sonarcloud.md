# Analyzing using SonarCloud

Carpenter.AzurePipelines enables analyzing a project using SonarCloud.

For more information on SonarCloud, see [sonarcloud.io](https://sonarcloud.io/).

## Enabling SonarCloud analysis

To enable SonarCloud analysis, pass the [**AnalyzeSonar**](../../operations.md#analyzesonar) operation to the
[`pipelineOperations`](../../configuration.md#carpenterpipelineoperations-pipelineoperations) parameter:

```
stages:
- template: template/carpenter-default.yml
  parameters:
    pipelineOperations:
    - BuildDotNet # Required for TestDotNet
    - TestDotNet # Required for AnalyzeSonar
    - CollectTestCoverage # Optional for AnalyzeSonar
    - AnalyzeSonar
   sonarCloudServiceConnection: MySonarConnection
```

The following variables are required:

Carpenter.SonarCloud.Organization
Carpenter.SonarCloud.ProjectKey
