[Carpenter.AzurePipelines Operations](#carpenterazurepipelines-operations)
* [ExcludePipeline](#excludepipeline)
* [PublishSourceArtifact](#publishsourceartifact)
* [IncrementVersionOnRelease](#incrementversiononrelease)

# Carpenter.AzurePipelines Operations

## ExcludePipeline

Do not download pipeline templates, scripts, and supporting files when extending the template. Only include this
operation if you are providing Carpenter.AzurePipelines through other means.

## PublishSourceArtifact

Publish a clean copy of the sources as a 'source' artifact attached to the pipeline.

## BuildDotNet

Performs a DotNet build of the solution.

This operation uses the following settings:

* Carpenter.Solution.Path

## PackageNuGet

## TestDotNet

## AnalyzeSonar

## IncrementVersionOnRelease

Increments the patch portion of the version on a release when using SemVer versioning.
