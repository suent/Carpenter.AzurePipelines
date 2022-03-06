# pipelineVersion

The pipelineVersion allows breaking changes to be made to the common template yaml without breaking builds which
extend the Carpenter template.

## Usage

You can define the pipline version that you want to use in your pipeline yaml:
```
- template: template/carpenter-default.yml@Carpenter
  parameters:
    # See template/carpenter-default.yml
    pipelineVersion: 1
```

When making a breaking change pipelineVersion can be used to require manual intervention to pipelines which extend
this template.

This step can be modified:
```
- script: |
    # do something

```

to this:
```
- ${{ if eq(parameters.pipelineVersion,1) }}:
  - script: | 
      # do something
- ${{ if gt(parameters.pipelineVersion,1) }}:
  - script: | 
      # do something differently in a breaking way
```

while not breaking existing pipelines that extend the template.

Once a pipeline has been validated, the pipelineVersion can be updated to 2 to pull in the new functionality.
