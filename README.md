# carpenter-azure-pipelines
[![Build Status](https://dev.azure.com/suent/Carpenter/_apis/build/status/carpenter-azure-pipelines?branchName=main)](https://dev.azure.com/suent/Carpenter/_build/latest?definitionId=2&branchName=main)

The carpenter-azure-pipelines project provides common YAML templates and scripts for Azure Pipelines definitions. For more information on Azure Pipelines see the [YAML schema](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema) or [template usage](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/templates?view=azure-devops) documentation.

## Features

* [Build Versioning](docs/build-versioning.md)
  * [Build Revision](docs/build-revision.md)
  * [Semantic Versioning 2.0.0](docs/semver.md)
* [Configurable Pool](docs/configure-pool.md)
* [Pipeline Versioning](docs/pipeline-versioning.md)
* [Carpenter Variables](docs/variables.md)

## Usage

| Method | Description |
|:-------|:------------|
| [Direct Access](docs/usage-direct.md) | Directly access carpenter-azure-pipelines by referencing from your projects pipeline yaml. |

# Development

For details on development, please see the [Carpenter development wiki](https://dev.azure.com/suent/Carpenter/_wiki/wikis/Carpenter.wiki).

Please also take note of the carpenter-azure-pipelines [Code of Conduct](docs/CODE_OF_CONDUCT.md) and [Contributing guidelines](docs/CONTRIBUTING.md).
