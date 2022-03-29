# Add Git Tags

Adds a tag to git to reference to the build.

## Enabling Git Tagging

To add git tags for the build, pass the [**AddGitTag**](../../operations.md#addgittag) operation to the
[`pipelineOperations`](../../configuration.md#carpenterpipelineoperations-pipelineoperations) parameter:

```
stages:
- template: template/carpenter-default.yml
  parameters:
    pipelineOperations:
    - AddGitTag
```
