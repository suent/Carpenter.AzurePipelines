# Using carpenter-azure-pipelines directly

## Prerequisites

* Azure DevOps project
* GitHub account

## Extend the Carpenter pipeline templates

1. Create GitHub service connection
    
    Azure DevOps needs a service connection to communicate with GitHub. You can skip this step if your project already has a service connection to GitHub.

    Note: Be sure to use a `Service connection` and do not use `GitHub connections`.

2. Link to Carpenter from your Azure Pipeline YAML

    ``` yaml
    resources:
      repositories:
      - repository: Carpenter
        type: github
        name: suent/carpenter-azure-pipelines
        endpoint: https://github.com
        # Note: The repository endpoint value should match the name of your service connection.

    stages:
    - template: template/carpenter-default.yml@Carpenter
      parameters:
        pipelineVersion: 1
        # YOUR PROJECT CONFIGURATION GOES HERE
        # see Carpenter documentation
    ```

You should now be able to execute your pipeline extending templates provided by Carpenter.
