[Configuring Carpenter.AzurePipelines](#configuring-carpenterazurepipelines)
* [Settings Heirarchy](#settings-heirarchy)
  * [YAML Parameter](#yaml-parameter)
  * [YAML Variable](#yaml-variable)
  * [YAML Variable Group](#yaml-variable-group)
  * [Pipeline Definition Variable](#pipeline-definition-variable)
  * [Pipeline Definition Variable Group](#pipeline-definition-variable-group)
* [Pipeline Settings](#pipeline-settings)
  * [Carpenter.Pipeline.Version (pipelineVersion)](#carpenterpipelineversion-pipelineversion)
  * [Carpenter.Pipeline.Operations (pipelineOperations)](#carpenterpipelineoperations-pipelineoperations)
  * [Carpenter.Pipeline.Path](#carpenterpipelinepath)
  * [Carpenter.Pipeline.ScriptPath](#carpenterpipelinescriptpath)
  * [Carpenter.Pipeline.Reason (pipelineReason)](#carpenterpipelinereason-pipelinereason)
* [Pool Configuration](#pool-configuration)
  * [Carpenter.Pool.Default.Type (defaultPoolType)](#carpenterpooldefaulttype-defaultpooltype)
  * [Carpenter.Pool.Default.Demands (defaultPoolDemands)](#carpenterpooldefaultdemands-defaultpooldemands)
  * [Carpenter.Pool.Default.Name (defaultPoolName)](#carpenterpooldefaultname-defaultpoolname)
  * [Carpenter.Pool.Default.VMImage (defaultPoolVMImage)](#carpenterpooldefaultvmimage-defaultpoolvmimage)
* [Project Configuration](#project-configuration)
  * [Carpenter.Project](#carpenterproject)
  * [Carpenter.Project.Path](#carpenterprojectpath)
  * [Carpenter.Solution.Path](#carpentersolutionpath)
* [Tools Configuration](#tools-configuration)
  * [Carpenter.DotNet.Path](#carpenterdotnetpath)
* [Output Paths](#output-paths)
  * [Carpenter.Output.Path](#carpenteroutputpath)
  * [Carpenter.Output.Binaries.Path](#carpenteroutputbinariespath)
  * [Carpenter.Output.NuGet.Path](#carpenteroutputnugetpath)
  * [Carpenter.Output.Tests.Path](#carpenteroutputtestspath)
  * [Carpenter.Output.TestCoverage.Path](#carpenteroutputtestcoveragepath)
* [Build Versioning](#build-versioning)
  * [Carpenter.Version.RevisionOffset](#carpenterversionrevisionoffset)
  * [Carpenter.Version.Revision](#carpenterversionrevision)
  * [Carpenter.Version.VersionFile](#carpenterversionversionfile)
  * [Carpenter.Version.VersionFile.Path](#carpenterversionversionfilepath)
  * [Carpenter.Version.BaseVersion](#carpenterversionbaseversion)
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
* [SonarCloud Analysis](#sonarcloud-analysis)


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
* [PipelineBot](#pipelinebot)
  * [Carpenter.PipelineBot](#carpenterpipelinebot)
  * [Carpenter.PipelineBot.Email](#carpenterpipelinebotemail)
  * [Carpenter.PipelineBot.Name](#carpenterpipelinebotname)
  * [PipelineBot-GitHub-PAT](#pipelinebot-github-pat)


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

### Carpenter.Pipeline.Version (pipelineVersion)

The version of the pipeline. Used to accomodate rolling breaking changes across multiple pipelines. A breaking change
could implement new functionality under an incremented version number, and move dependent pipelines over separately.
This value is set by the `pipelineVersion` parameter. The default value is **1**. 

To ensure that future changes to the pipeline do not break pipelines which extend this template, it is recommended
that this parameter is passed to the template.

For more information, see: [pipeline-versioning.md](pipeline-versioning.md)

### Carpenter.Pipeline.Operations (pipelineOperations)

Defines the operations for a pipeline. This value is set by the `pipelineOperations` parameter.

For more information, see: [operations.md](operations.md)

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

## Pool Configuration

For more information, see [configure-pool.md](configure-pool.md).

### Carpenter.Pool.Default.Type (defaultPoolType)

The default pool type to use for jobs.

| Pool Type | Description |
|:--|:--|
| Hosted | Microsoft Hosted Agent Pool |
| Private | Private Agent Pool |

 This value is set by the `defaultPoolType` parameter. The default value is **Hosted**.
 
### Carpenter.Pool.Default.VMImage (defaultPoolVMImage)

The VM Image to use when using *Hosted* pool type. This value is set by the `defaultPoolVMImage` parameter. The default
value is **ubuntu-latest**.

### Carpenter.Pool.Default.Name (defaultPoolName)

The pool name to use when using *Private* pool type. This value is set by the `defaultPoolName` parameter. The default
value is **Default**.

### Carpenter.Pool.Default.Demands (defaultPoolDemands)

The demands for the agent when using a *Private* pool type. This value is set by the `defaultPoolDemands` parameter.

## Project Configuration

### Carpenter.Project

The name of the project. If the variable is not supplied, the default value is the value of the `Build.DefinitionName`
variable.

### Carpenter.Project.Path

The absolute path of the project source. This value is determined during pipeline execution.

### Carpenter.Solution.Path

The absolute path to the solution. This value is determined during pipeline execution if `pipelineOperations` contains
**BuildDotNet**.

## Tools Configuration

### Carpenter.DotNet.Path

The path to .NET binaries. This value is determined during pipeline execution if `pipelineOperations` contains
**BuildDotNet**. If the .NET SDK does not exist, it will be extracted to this path.

## Output Path

### Carpenter.Output.Path

The absolute path to the output root. This value is determined during pipeline execution if `pipelineOperations`
contains **BuildDotNet**.

### Carpenter.Output.Binaries.Path

The absolute path to the binaries output. This value is determined during pipeline execution if `pipelineOperations`
contains **BuildDotNet**.

### Carpenter.Output.NuGet.Path

The absolute path to the NuGet package output. This value is determined during pipeline execution if
`pipelineOperations` contains **PackageNuGet**.

### Carpenter.Output.TestCoverage.Path

The absolute path to the test coverage reports output. This value is determined during pipeline execution if
`pipelineOperations` contains **CollectTestCoverage**.

### Carpenter.Output.Tests.Path

The absolute path to the test output. This value is determined during pipeline execution if `pipelineOperations`
contains **TestDotNet**.

## Build Versioning

For more information, see [build-versioning.md](build-versioning.md).

### Carpenter.Version.RevisionOffset

The starting value offset of the revision counter. Only used if `pipelineOperations` contains **VersionSemVer**. The
default value is **0**.

### Carpenter.Version.Revision

The number of times the project has been built by this pipeline. This value is determined during pipeline execution if
`pipelineOperations` contains **VersionSemVer**.

### Carpenter.Version.VersionFile

The relative path to the VERSION file from the project root. Only used if `pipelineOperations` contains
**VersionSemVer**. The default value is **VERSION**.

### Carpenter.Version.VersionFile.Path

The absolute path to the VERSION file. This value is determined during pipeline execution if `pipelineOperations`
contains **VersionSemVer**.

### Carpenter.Version.BaseVersion

The base version number, comprised of Major, Minor and Patch versions separated by a period. This value is
determined during pipeline execution from the vERSION file if `pipelineOperations` contains **VersionSemVer**.

### Carpenter.Version.Major

The Major version number. This value is determined during pipeline execution from the VERSION file if
`pipelineOperations` contains **VersionSemVer**.

### Carpenter.Version.Minor

The Minor version number. This value is determined during pipeline execution from the VERSION file if
`pipelineOperations` contains **VersionSemVer**.

### Carpenter.Version.Patch

The Patch version number. This value is determined during pipeline execution from the VERSION file if
`pipelineOperations` contains **VersionSemVer**.

### Carpenter.Version.Label

The version label. This value is determined during pipeline execution if `pipelineOperations` contains
**VersionSemVer**.

### Carpenter.Version

The version string (without version metadata). This value is determined during pipeline execution if
`pipelineOperations` contains **VersionSemVer**.

## Continuous Integration

### Carpenter.ContinuousIntegration.Date

The date code of the continuous integration build. This value is determined during template expansion when
`pipelineReason` is **CI** if `pipelineOperations` contains **VersionSemVer**.

### Carpenter.ContinuousIntegration.Revsision

The revision of the continuous integration build. Increments for each build under a specific date. This value is
determined during pipeline execution when `pipelineReason` is **CI** if `pipelineOperations` contains
**VersionSemVer**.

## Pull Request

### Carpenter.PullRequest.Revision

The pull request revision. This value is determined during the pipeline execution when `pipelineReason` is **PR**
if `pipelineOperations` contains **VersionSemVer**.

## Prerelease

### Carpenter.Prerelease.Label

The label to use for a prerelease build. This value is set by the `prereleaseLabel` parameter when `pipelineReason` is
**Prerelease** if `pipelineOperations` contains **VersionSemVer**. The default value is **alpha**.

### Carpenter.Prerelease.Revision

The prerelease revision. This value is determined during pipeline execution when `pipelineReason` is **Prerelease** if
`pipelineOperations` contains **VersionSemVer**.


## SonarCloud Analysis

For more information:
https://github.com/suent/carpenter-azure-pipelines/blob/main/doc/analysis-sonarcloud.md

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

## PipelineBot

The PipelineBot is automation that manages the pipeline and its outside connections.

### Carpenter.PipelineBot

The GitHub username for the pipeline bot.

### Carpenter.PipelineBot.Email

The email address of the pipeline bot.

### Carpenter.PipelineBot.Name

The name of the pipeline bot.

### PipelineBot-GitHub-PAT

The GitHub personal access token for the pipeline bot. This value should be supplied to
the pipeline as a secret variable through a Variable group or through an Azure key vault.

This token is used by the following jobs/steps:
* AddGitTags
* DeployNuGet (when target is github.com)
* IncrementVersion
* PublishBranch
