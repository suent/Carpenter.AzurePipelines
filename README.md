![Carpenter.AzurePipelines](media/Carpenter-Title_400x122.png)

[![Build Status](https://dev.azure.com/suent/Carpenter/_apis/build/status/Carpenter.AzurePipelines?branchName=main)](https://dev.azure.com/suent/Carpenter/_build/latest?definitionId=7&branchName=main)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=Suent_Carpenter.AzurePipelines&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=Suent_Carpenter.AzurePipelines)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=Suent_Carpenter.AzurePipelines&metric=coverage)](https://sonarcloud.io/summary/new_code?id=Suent_Carpenter.AzurePipelines)
[![Release](https://vsrm.dev.azure.com/suent/_apis/public/Release/badge/f805856b-08a0-459b-89c8-66f8ec61d6e1/1/4)](https://dev.azure.com/suent/Carpenter/_release?view=all&_a=releases&definitionId=1)
[![Carpenter.AzurePipelines NuGet package](https://feeds.dev.azure.com/suent/_apis/public/Packaging/Feeds/6e861335-193a-4afe-97aa-2097572c51f9@ba500766-c1dc-4b9b-aaa6-3f7021545343/Packages/db5f766a-90a7-4c00-b2b5-3336a63b27a0/Badge)](https://www.nuget.org/Carpenter.AzurePipelines)

[Carpenter.AzurePipelines](#carpeneterazurepipelines)

Copyright © 2015-2022 [Suent Networks](https://suent.net)

* [Features](#features)
* [Usage](#usage)
* [Contributing](#contributing)


# Carpenter.AzurePipelines

Carpenter.AzurePipelines provides common YAML templates and scripts for Azure Pipelines definitions. 

This project serves as the primary build process for Suent Networks projects to provide a consistent experience to both developers and end users.

For more information on Azure Pipelines see the [YAML schema](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema) or [template usage](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/templates?view=azure-devops) documentation.


## Features

* [YAML Parameters](docs/parameters.md)
* [Carpenter Variables](docs/variables.md)
* [Pipeline Versioning](docs/pipeline-versioning.md)
* [Configurable Pool](docs/configure-pool.md)
* [Build Versioning](docs/build-versioning.md)
  * [Build Revision](docs/build-revision.md)
  * [Semantic Versioning 2.0.0](docs/semver.md)
* [Build](docs/build.md)
* [Test](docs/test.md)
* [Analyze](docs/analysis.md)
* [Deploy](docs/deploy.md)

## Usage

| Method | Description |
|:-------|:------------|
| [Direct Access](docs/usage-direct.md) | Directly access carpenter-azure-pipelines by referencing from your projects pipeline yaml. |


## Contributing

For details on development processes, please see the [Carpenter development wiki](https://dev.azure.com/suent/Carpenter/_wiki/wikis/Carpenter.wiki).

Please also take note of the carpenter-azure-pipelines [Code of Conduct](docs/CODE_OF_CONDUCT.md) and [Contributing guidelines](docs/CONTRIBUTING.md).
