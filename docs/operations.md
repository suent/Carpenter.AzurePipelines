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

## VersionSemVer

Uses Semantic Versioning 2.0.0 for the pipeline build number.

This operation uses the following settings:

* Carpenter.Version.RevisionOffset
* Carpenter.Version.Revision
* Carpenter.Version.VersionFile
* Carpenter.Version.VersionFile.Path
* Carpenter.Version.BaseVersion
* Carpenter.Version.Major
* Carpenter.Version.Minor
* Carpenter.Version.Patch
* Carpenter.Version.Label
* Carpenter.Version

## BuildDotNet

Performs a build of the solution using the dotnet command line tool.

This operation uses the following settings:

* Carpenter.Solution.Path
* Carpenter.Output.Path
* Carpenter.Output.Binaries.Path

## PackageNuGet

This operation uses the following settings:

* Carpenter.Output.NuGet.Path

## TestDotNet

This operation uses the following settings:

* Carpenter.Output.Tests.Path

## CollectTestCoverage

This operation uses the following settings:

* Carpenter.Output.TestCoverage.Path

## AnalyzeSonar

## IncrementVersionOnRelease

Increments the patch portion of the version on a release when using SemVer versioning.

Required operations:

* VersionSemVer
