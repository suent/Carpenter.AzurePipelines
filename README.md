![Carpenter.AzurePipelines](media/Carpenter-Title_400x122.png)

[![Build Status](https://dev.azure.com/suent/Carpenter/_apis/build/status/Carpenter.AzurePipelines?branchName=main)](https://dev.azure.com/suent/Carpenter/_build/latest?definitionId=7&branchName=main)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=Suent_Carpenter.AzurePipelines&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=Suent_Carpenter.AzurePipelines)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=Suent_Carpenter.AzurePipelines&metric=coverage)](https://sonarcloud.io/summary/new_code?id=Suent_Carpenter.AzurePipelines)

Copyright © 2015-2022 [Suent Networks](https://suent.net)

* [Carpenter.AzurePipelines](#carpeneterazurepipelines)

# Carpenter.AzurePipelines

Carpenter.AzurePipelines provides common YAML templates and scripts for Azure Pipelines definitions. 

This project serves as the primary build process for Suent Networks projects to provide a consistent experience to both developers and end users.

For more information on Azure Pipelines see the [YAML schema](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema) or [template usage](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/templates?view=azure-devops) documentation.


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


## Development

For details on development, please see the [Carpenter development wiki](https://dev.azure.com/suent/Carpenter/_wiki/wikis/Carpenter.wiki).

Please also take note of the carpenter-azure-pipelines [Code of Conduct](docs/CODE_OF_CONDUCT.md) and [Contributing guidelines](docs/CONTRIBUTING.md).
