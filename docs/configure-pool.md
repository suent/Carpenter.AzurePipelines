# Configuring the agent pool

By default, Carpenter uses the Hosted pool using the `ubuntu-latest` VM image.

## Agent pool configuration

The following parameters are used to configure the pool.

### defaultPoolType

The default pool type to use for jobs. Possible values are **Private** or **Hosted**.

### defaultPoolName

The pool name to use when using Private pool type.

### defaultPoolDemands

The demands for the agent when using a Private pool type.

For more information:
https://docs.microsoft.com/en-us/azure/devops/pipelines/process/demands?view=azure-devops&tabs=yaml

### defaultPoolVMImage

The VM Image to use when using Hosted pool type.

## Examples

### Using Windows Hosted agent pool

```yaml
stages:
- template: template/carpenter-default.yml
  parameters:
    defaultPoolType: 'Hosted'
    defaultPoolVMImage: 'windows-latest'
```

### Using private agent pool with demands
```yaml
stages:
- template: template/carpenter-default.yml
  parameters:
    defaultPoolType: 'Private'
    defaultPoolName: 'Default'
    defaultPoolDemands:
    - agent.os -equals Windows_NT
    - docker
```
