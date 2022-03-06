[Configuring Carpenter.AzurePipelines](#configuring-carpenterazurepipelines)
* [Settings Heirarchy](#settings-heirarchy)
  * [YAML Parameter](#yaml-parameter)
  * [YAML Variable](#yaml-variable)
  * [YAML Variable Group](#yaml-variable-group)
  * [Pipeline Definition Variable](#pipeline-definition-variable)
  * [Pipeline Definition Variable Group](#pipeline-definition-variable-group)
* [Pipeline Settings](#pipeline-settings)
  * [Carpenter.PipelineVersion (pipelineVersion)](#carpenterpipelineversion-pipelineversion)
  * [Carpenter.Project](#carpenterproject)
  * [Carpenter.Project.Path](#carpenterprojectpath)
  * [Carpenter.Pipeline (includePipeline)](#carpenterpipeline-includepipeline)
  * [Carpenter.Pipeline.Path](#carpenterpipelinepath)
  * [Carpenter.Pipeline.ScriptPath](#carpenterpipelinescriptpath)
  * [Carpenter.DotNet.Path](#carpenterdotnetpath)
  * [Carpenter.Pipeline.Reason (pipelineReason)](#carpenterpipelinereason-pipelinereason)
* [Pool Configuration](#pool-configuration)
  * [Carpenter.Pool.Default.Demands](#carpenterpooldefaultdemands)
  * [Carpenter.Pool.Default.Name](#carpenterpooldefaultname)
  * [Carpenter.Pool.Default.Type](#carpenterpooldefaulttype)
  * [Carpenter.Pool.Default.VMImage](#carpenterpooldefaultvmimage)
* [Build Versioning](#build-versioning)
  * [Carpenter.Version.Type](#carpenterversiontype)
  * [Carpenter.Version.VersionFile](#carpenterversionversionfile)
  * [Carpenter.Version.Revision](#carpenterversionrevision)
  * [Carpenter.Version.RevisionOffset](#carpenterversionrevisionoffset)
  * [Carpenter.Version.Major](#carpenterversionmajor)
  * [Carpenter.Version.Minor](#carpenterversionminor)
  * [Carpenter.Version.Patch](#carpenterversionpatch)
  * [Carpenter.Version.Label](#carpenterversionlabel)
  * [Carpenter.Version](#carpenterversion)
* [Continuous Integration](#continuous-integration)
  * [Carpenter.ContinuousIntegration.Date](#carpentercontinuousintegrationdate)
  * [Carpenter.ContinuousIntegration.Revision](#carpentercontinuousintegrationrevsision)
* [Pull Request](#pull-request)
  * [Carpenter.PullRequest.Revision](#carpenterpullrequestrevision)
* [Prerelease](#prerelease)
  * [Carpenter.Prerelease.Label](#carpenterprereleaselabel)
  * [Carpenter.Prerelease.Revision](#carpenterprereleaserevision)
* [PipelineBot](#pipelinebot)
  * [Carpenter.PipelineBot](#carpenterpipelinebot)
  * [Carpenter.PipelineBot.Email](#carpenterpipelinebotemail)
  * [Carpenter.PipelineBot.Name](#carpenterpipelinebotname)
  * [PipelineBot-GitHub-PAT](#pipelinebot-github-pat)
* [.NET Build](#net-build)
  * [Carpenter.Build.DotNet](#carpenterbuilddotnet)
* [Test Execution](#test-execution)
* [SonarCloud Analysis](#sonarcloud-analysis)
  * [Carpenter.SonarCloud](#carpentersonarcloud)
* [Deployment variables](#deployment-variables)
  * [Carpenter.Deploy.Branch](#carpenterdeploybranch)
  * [Carpenter.Deploy.NuGet](#carpenterdeploynuget)
  * [Carpenter.Deploy.NuGet.TargetFeed.Dev](#carpenterdeploynugettargetfeeddev)
  * [Carpenter.Deploy.NuGet.TargetFeed.Test1](#carpenterdeploynugettargetfeedtest1)
  * [Carpenter.Deploy.NuGet.TargetFeed.Test2](#carpenterdeploynugettargetfeedtest2)
  * [Carpenter.Deploy.NuGet.TargetFeed.Stage](#carpenterdeploynugettargetfeedstage)
  * [Carpenter.Deploy.NuGet.TargetFeed.Prod](#carpenterdeploynugettargetfeedprod)
  * [Carpenter.NuGet.Quality](#carpenternugetquality)
  * [Carpenter.NuGet.Quality.Feed](#carpenternugetqualityfeed)
  * [Carpenter.NuGet.Quality.Dev](#carpenternugetqualitydev)
  * [Carpenter.NuGet.Quality.Test1](#carpenternugetqualitytest1)
  * [Carpenter.NuGet.Quality.Test2](#carpenternugetqualitytest2)
  * [Carpenter.NuGet.Quality.Stage](#carpenternugetqualitystage)
  * [Carpenter.NuGet.Quality.Prod](#carpenternugetqualityprod)
  * [Carpenter.GitHub.ServiceConnection](#carpentergithubserviceconnection)
  * [Carpenter.Git.AddTagOnDevMain (addGitTagOnDevMain)](#carpentergitaddtagondevmain-addgittagondevmain)
  * [Carpenter.GitHub.ReleaseOnProd (addGitHubReleaseOnProd)](#carpentergithubreleaseonprod-addgithubreleaseonprod)


# Configuring Carpenter.AzurePipelines

## Settings hierarchy

To take advantage of a larger feature set in Microsoft Azure DevOps pipelines, Carpenter.AzurePipelines settings are
implemented at multiple layers in the pipeline. This document serves to describe Carpenter variables and document the
layer to which a setting is applied.

### YAML Parameter

YAML parameters are used when the value of the settings could change the pipeline during template expansion.
Parameters are used in this case because variables are not yet populated.  In contrast to using the condition
parameter, which can be done with a variable, elements can be excluded from the pipeline completely when the
template is expanded.

YAML parameters are also used to pass service connection strings, as service connection permissions are validated
during pipeline expansion.

YAML parameters should only be used where necessary as extra overhead is incurred when using parameters, for example
plumbing through a new parameter is much more work than using a variable.

### YAML Variable

Variables that are set at the Pipeline YAML level are the preferred location for Carpenter.AzurePipelines
configuration.  If there is no reason to use any other method of configuration, YAML variables should be used.

### YAML Variable Group

Variable groups linked through the pipeline YAML should be used when configuration settings are used across multiple
pipelines.

### Pipeline Definition Variable

Variables defined in the pipeline definition are useful when configuration settings might need to be changed when
the build is executed.

### Pipeline Definition Variable Group

Currently there is no reason to use variable groups linked through the pipeline definition.


## Pipeline Settings

### Carpenter.PipelineVersion (pipelineVersion)

The version of the pipeline. Used to accomodate rolling breaking changes across multiple pipelines. A breaking change
could implement new functionality under an incremented version number, and move dependent pipelines over separately.
This value is set by the `pipelineVersion` parameter. The default value is **1**. 

To ensure that future changes to the pipeline do not break pipelines which extend this template, it is recommended
that this parameter is passed to the template.

For more information, see: [pipeline-versioning.md](pipeline-versioning.md)

### Carpenter.Project

The name of the project. This value is set by the `project` parameter. If parameter is notsupplied, the default value
is the value of the `Build.DefinitionName` variable.

### Carpenter.Project.Path

The absolute path of the project source. This value is determined during pipeline execution.

### Carpenter.DotNet.Path

The path to .NET binaries. This value is determined during template expansion if `buildDotNet` is true. If the .NET
binaries do not exist, they will be downloaded to this path.

### Carpenter.Pipeline (includePipeline)

If true, the pipeline will be included in the sources directory. When directly linking the pipeline template through a
repository resource, includePipeline must be true to download the Carpenter scripts and tools to be available to the
pipeline. This is required if the Carpenter scripts and resources do not exist in your project. This value is set by
the `includePipeline` parameter. The default value is **true**.

### Carpenter.Pipeline.Path

The absolute path to the Carpenter pipeline supporting files. This value is determined during template expansion.

### Carpenter.Pipeline.ScriptPath

The absolute path to the Carpenter pipeline scripts. This value is determined during template expansion.


### Carpenter.Pipeline.Reason (pipelineReason)

The purpose of the build. This value gets set automatically during an automated build. If a manual build, the value of
the `pipelineReason` parameter is used.

| Build Reason | Description                                                                                         |
|:-------------|:----------------------------------------------------------------------------------------------------|
| CI           | A Continuous Integration build. CI can be the result of a manual or automated build.                |
| PR           | A Pull Request build. The PR build reason is only set during an automated PR build.                 |
| Prerelease   | A prerelease build is the result of a manual build with build reason as Prerelease.                 |
| Release      | A release build is the result of a manual build with build reason as Release.                       |

Project versioning and deployment options are dependent on the build purpose. The default value during a manual build
is **CI**.

### Carpenter.Solution.Path

The absolute path to the solution. This value is determined during pipeline execution.

### Carpenter.Output.Path

The output root path. This value is determined during pipeline execution.

### Carpenter.Output.Binaries.Path

The binaries output path. This value is determined during pipeline execution.

### Carpenter.Output.Tests.Path

The tests output path. This value is determined during pipeline execution.

### Carpenter.Output.TestCoverage.Path

The test coverage reports output path. This value is determined during pipeline execution.

### Carpenter.Output.NuGet.Path

The NuGet package output path. This value is determined during pipeline execution.

## Pool Configuration

### Carpenter.Pool.Default.Demands

The demands for the agent when using a *Private* pool type. This value is set by the
`defaultPoolDemands` parameter.

### Carpenter.Pool.Default.Name

The pool name to use when using *Private* pool type. This value is set by the `defaultPoolName`
parameter. The default value is **Default**.

### Carpenter.Pool.Default.Type

The default pool type to use for jobs.

| Pool Type | Description |
|:--|:--|
| Hosted | Microsoft Hosted Agent Pool |
| Private | Private Agent Pool |

 This value is set by the `defaultPoolType` parameter. The default value is **Hosted**.

### Carpenter.Pool.Default.VMImage

The VM Image to use when using Hosted pool type. This value is set by the `defaultPoolVMImage`
parameter. The default value is **ubuntu-latest**.

## Build Versioning

### Carpenter.Version.Type

The type of build versioning to use.

| Version Type | Description |
|:--|:--|
| None | No build versioning |
| SemVer | Semantic Versioning 2.0.0 |

This value is set by the `versionType` parameter. The default value is **None**.

### Carpenter.Version.VersionFile

The path to the VERSION file. This value is set by the `versionFile` parameter. The
default value is **VERSION**.

### Carpenter.Version.Revision

The number of times the project has been built by this pipeline. This value is determined
during pipeline execution.

### Carpenter.Version.RevisionOffset

The starting value of the revision counter. This value is set by the `revisionOffset` parameter.
The default value is **0**.

### Carpenter.Version.Major

The Major version number. This value is determined during pipeline execution from the VERSION file.

### Carpenter.Version.Minor

The Minor version number. This value is determined during pipeline execution from the VERSION file.

### Carpenter.Version.Patch

The Patch version number. This value is determined during pipeline execution from the VERSION file.

### Carpenter.Version.Label

The version label. This value is determined during pipeline execution.

### Carpenter.Version

The version string (without version metadata). This value is determined during pipeline execution.

### Carpenter.Version.IncrementOnRelease

If true, the patch version is incremented on a release. This value is set by the `incrementVersionOnRelease`
parameter. The default value is **false**.

## Continuous Integration

### Carpenter.ContinuousIntegration.Date

The date code of the continuous integration build. This value is determined during pipeline
execution.

### Carpenter.ContinuousIntegration.Revsision

The revision of the continuous integration build. Increments for each build under a specific date.
This value is determined during pipeline execution.

## Pull Request

### Carpenter.PullRequest.Revision

The pull request revision. This value is determined during the pipeline execution.

## Prerelease

### Carpenter.Prerelease.Label

The label to use for a prerelease build. This value is set by the `prereleaseLabel` parameter.
The default value is **alpha**.

### Carpenter.Prerelease.Revision

The prerelease revision. This value is determined during pipeline execution.

## PipelineBot

### Carpenter.PipelineBot

The GitHub username for the pipeline bot. This value should be supplied to the pipeline as
a variable, either directly through the YAML or through a Variable group.

### Carpenter.PipelineBot.Email

The email address of the pipeline bot. This value should be supplied to the pipeline as
a variable, either directly through the YAML or through a Variable group.

### Carpenter.PipelineBot.Name

The name of the pipeline bot. This value should be supplied to the pipeline asa variable,
either directly through the YAML or through a Variable group.

### PipelineBot-GitHub-PAT

The GitHub personal access token for the pipeline bot. This value should be supplied to
the pipeline as a secret variable through a Variable group or through an Azure key vault.

## .NET Build

### Carpenter.Build.DotNet

If true, a dotnet build process is executed. This value is set by the `buildDotNet` parameter.
The default value is **false**.

## Test Execution

### Carpenter.Test.Unit

If true, unit tests are executed during the pipeline. This value is set by the
`executeUnitTests` parameter. The default valuer is **false**.

## SonarCloud Analysis

### Carpenter.SonarCloud

If true, SonarCloud analysis is executed. This value is set by the `sonarCloud` parameter.
The default value is **false**.

### Carpenter.SonarCloud.Organization

The SonarCloud organization this project is under. This value is set by the
`sonarCloudOrganization` parameter.

### Carpenter.SonarCloud.ProjectKey

The SonarCloud project key. This value is set by the `sonarCloudProjectKey` parameter.

### Carpenter.SonarCloud.ServiceConnection

The SonarCloud service connection to use. This value is set by the `sonarCloudServiceConnection`
parameter.

## Deployment variables

### Carpenter.Deploy.Branch

Comma separated list of stacks deploy branch should execute for. Creates a branch of this builds
source to represent code on a stack. This value is set by the `deployBranch` parameter.

### Carpenter.Deploy.NuGet

Comma separated list of stacks deploy nuget should execute for. Publishes NuGet packages created by
this pipeline. This value is set by the `deployNuGet` parameter.

### Carpenter.Deploy.NuGet.TargetFeed.Dev

The target NuGet feed to use when deploying NuGet packages to the Dev stack. This value is set by the
`deployNuGetTargetFeedDev` parameter.

### Carpenter.Deploy.NuGet.TargetFeed.Test1

The target NuGet feed to use when deploying NuGet packages to the Test1 stack. This value is set by the
`deployNuGetTargetFeedTest1` parameter.

### Carpenter.Deploy.NuGet.TargetFeed.Test2

The target NuGet feed to use when deploying NuGet packages to the Test2 stack. This value is set by the
`deployNuGetTargetFeedTest2` parameter.

### Carpenter.Deploy.NuGet.TargetFeed.Stage

The target NuGet feed to use when deploying NuGet packages to the Stage stack. This value is set by the
`deployNuGetTargetFeedStage` parameter.

### Carpenter.Deploy.NuGet.TargetFeed.Prod

The target NuGet feed to use when deploying NuGet packages to the Prod stack. This value is set by the
`deployNuGetTargetFeedProd` parameter.

### Carpenter.NuGet.Quality

Comma separated list of stacks update quality should execute for. Updates the described quality of
a NuGet package using the Artifact views. This value is set by the `updateNuGetQuality` parameter.

### Carpenter.NuGet.Quality.Feed

The Azure DevOps Artifact NuGet package feed to use when updating quality.

### Carpenter.NuGet.Quality.Dev

The target quality when updating quality on the Developer stack. This value is set by the
`nuGetQualityDev` parameter.

### Carpenter.NuGet.Quality.Test1

The target quality when updating quality on the Test 1 stack. This value is set by the
`nuGetQualityTest1` parameter.

### Carpenter.NuGet.Quality.Test2

The target quality when updating quality on the Test 2 stack. This value is set by the
`nuGetQualityTest2` parameter.

### Carpenter.NuGet.Quality.Stage

The target quality when updating quality on the Staging stack. This value is set by the
`nuGetQualityStage` parameter.

### Carpenter.NuGet.Quality.Prod

The target quality when updating quality on the Production stack. This value is set by the
`nuGetQualityProd` parameter.

### Carpenter.GitHub.ServiceConnection

The service connection to use when executing GitHub tasks. This value is set byt the
`gitHubServiceConnection` parameter.

### Carpenter.Git.AddTagOnDevMain (addGitTagOnDevMain)

If true, git sources are tagged with the build number on Developer Finalize against the main branch. This value is set
by the `addGitTagOnDevMain` parameter. The default value is **false**.

### Carpenter.GitHub.ReleaseOnProd (addGitHubReleaseOnProd)

If true, a GitHub release is created during the Production Finalize. This value is set by the `addGitHubReleaseOnProd`
parameter. The default value is **false**.
