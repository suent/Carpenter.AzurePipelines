To use SonarCloud to analyze your project, use the following configuration:

```
    pipelineOperations:
    - AnalyzeSonar
    sonarCloudServiceConnection: YourSonarCloudServiceConnection
```
The following variables are required:

Carpenter.SonarCloud.Organization
Carpenter.SonarCloud.ProjectKey
