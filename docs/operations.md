[Carpenter.AzurePipelines Operations](#carpenterazurepipelines-operations)
* [ExcludePipeline](#excludepipeline)
* [PublishSourceArtifact](#publishsourceartifact)
* [VersionSemVer](#versionsemver)
* [BuildDotNet](#builddotnet)
* [PackageNuGet](#packagenuget)
* [TestDotNet](#testdotnet)
* [CollectTestCoverage](#collecttestcoverage)
* [AnalyzeSonar](#analyzesonar)
* [DeployBranch](#deploybranch)
* [DeployNuGet](#deploynuget)
* [AddGitTag](#addgittag)
* [IncrementVersionOnRelease](#incrementversiononrelease)
* [UpdateNuGetQuality](#updatenugetquality)

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

Creates a NuGet package and publishes a pipeline artifact.

Required operation:

* BuildDotNet

This operation uses the following settings:

* Carpenter.Output.NuGet.Path

## TestDotNet

Executes testing using the dotnet command line tool.

Required operations:

* BuildDotNet

This operation uses the following settings:

* Carpenter.Output.Tests.Path

## CollectTestCoverage

Generates and collects Cobertura and OpenCover code coverage information. 

Required operations:

* TestDotNet

This operation uses the following settings:

* Carpenter.Output.TestCoverage.Path

## AnalyzeSonar

Performs SonarCloud analysis.

Required operations:

* TestDotNet

This operation uses the following settings:

* Carpenter.SonarCloud.Organization
* Carpenter.SonarCloud.ProjectKey
* Carpenter.SonarCloud.ServiceConnection (sonarCloudServiceConnection)

## DeployBranch

Creates a branch of this builds source to represent code on a stack.

This operation uses the following settings:

* Carpenter.Deploy.Branch (deployBranch)

## DeployNuGet

Publishes NuGet packages created by this pipeline.

Required operations:

* PackageNuGet

This operation uses the following settings:

* Carpenter.Deploy.NuGet (deployNuGet)
* Carpenter.Deploy.NuGet.TargetFeed.Dev
* Carpenter.Deploy.NuGet.TargetFeed.Test1
* Carpenter.Deploy.NuGet.TargetFeed.Test2
* Carpenter.Deploy.NuGet.TargetFeed.Stage
* Carpenter.Deploy.NuGet.TargetFeed.Prod

## AddGitTag

Adds a Git tag for the build number to the source repository.

This operation uses the following settings:

* Carpenter.PipelineBot.Name
* Carpenter.PipelineBot.Email
* Carpenter.PipelineBot.GitHub.Username
* PipelineBot-GitHub-PAT

## IncrementVersionOnRelease

Increments the patch portion of the version on a release when using SemVer versioning.

Required operations:

* VersionSemVer

This operation uses the following settings:

* Carpenter.Pipeline.Reason
* Carpenter.Version.Major
* Carpenter.Version.Minor
* Carpenter.Version.Patch

## UpdateNuGetQuality

Updates the quality of a NuGet package stored in an Azure Artifacts feed.

Required operations:

* DeployNuGet

This operation uses the following settings:

* Carpenter.NuGet.Quality
* Carpenter.NuGet.Quality.Feed
* Carpenter.NuGet.Quality.Dev
* Carpenter.NuGet.Quality.Test1
* Carpenter.NuGet.Quality.Test2
* Carpenter.NuGet.Quality.Stage
* Carpenter.NuGet.Quality.Prod
