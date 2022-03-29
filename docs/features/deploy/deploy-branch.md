# Deploy a Branch of your code

DeployBranch allows a branch of the source base to be published during a build. An example of its
purpose is the Carpenter.AzurePipelines project itself. Pull requests get changes into master, but those changes
aren't necessarily included in a 'release' until pushed by the project manager/team. Other pipelines using templates
from Carpenter.AzurePipelines can target the stack/prod branch to ensure that they only receive code that has been
deployed to production.

## Enabling Deploy Branch

To enable deploy branch, pass the [**DeployBranch**](../../operations.md#deploybranch) operation to the
[`pipelineOperations`](../../configuration.md#carpenterpipelineoperations-pipelineoperations) parameter:

```
stages:
- template: template/carpenter-default.yml
  parameters:
    pipelineOperations:
    - DeployBranch
    deployBranch: test1,test2,stage,prod
```
The `deployBranch` parameter contains a comma separated list of stacks this operation executes against.
