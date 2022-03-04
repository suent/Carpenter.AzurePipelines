# Carpenter.AzurePipelines Settings

## Settings hierarchy

To take advantage of more functionality in Microsoft Azure DevOps pipelines, Carpenter.AzurePipelines settings are implemented at multiple layers in the pipeline. This document serves to describe Carpenter variables and document the layer to which a setting is applied.

### YAML Parameters

YAML parameters are used when the value of the settings could change the pipeline during template expansion because variables are not yet populated.  In contrast to using the condition parameter, which can be done with a variable, elements can be excluded from the pipeline completely at template expansion time.
