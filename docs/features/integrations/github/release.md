# GitHub Release

Creates a release on GitHub.com associated with the build.

## Enabling GitHub Release

To add a GitHub Release for the build, pass the [**AddGitHubRelease**](../../operations.md#addgithubrelease) operation to the
[`pipelineOperations`](../../configuration.md#carpenterpipelineoperations-pipelineoperations) parameter:

```
stages:
- template: template/carpenter-default.yml
  parameters:
    pipelineOperations:
    - AddGitHubRelease
    gitHubServiceConnection: serviceConnectionName
```
