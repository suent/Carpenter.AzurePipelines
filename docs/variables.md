[Carpenter.AzurePipelines Variables](#carpenterazurepipelines-variables)
* [Pipeline variables](#pipeline-variables)
  * [Carpenter.PipelineVersion](#carpenterpipelineversion)
  * [Carpenter.Pipeline](#carpenterpipeline)
  * [Carpenter.Pipeline.Path](#carpenterpipelinepath)
  * [Carpenter.Pipeline.ScriptPath](#carpenterpipelinescriptpath)
  * [Carpenter.DotNet.Path](#carpenterdotnetpath)
* [General Build variables](#general-build-variables)
  * [Carpenter.Build.Purpose](#carpenterbuildpurpose)
  * [Carpenter.Project](#carpenterproject)
  * [Carpenter.Project.Path](#carpenterprojectpath)
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

# Carpenter.AzurePipelines Variables

## Pipeline variables

### Carpenter.PipelineVersion

The version of the pipeline. Used to accomodate rolling breaking changes across multiple pipelines.
A breaking change could implement new functionality under an incremented version number, and move
dependent pipelines over separately. This value is set by the `pipelineVersion` parameter. The
default value is **1**. 

For more information, see: [pipeline-versioning.md](pipeline-versioning.md)

### Carpenter.Pipeline

If true, the pipeline will be included in the sources directory. This is required if the Carpenter
scripts and resources do not exist in your project. This value is set by the `includePipeline`
parameter. The default value is **true**.

### Carpenter.Pipeline.Path

The path to the pipeline supporting files. This value is determined during the pipeline execution.

### Carpenter.Pipeline.ScriptPath

The path to Carpenter pipeline scripts. This value is determined during the pipeline execution.

### Carpenter.DotNet.Path

The path to .NET binaries. This value is determined during the pipeline execution. If the .NET
binaries do not exist, they will be downloaded to this path.

## General Build variables

### Carpenter.Build.Purpose

The purpose of the build. This value gets set automatically during an automated build. If a manual
build, the value of the `buildReason` parameter is used.

| Build Reason | Description                                                                                         |
|:-------------|:----------------------------------------------------------------------------------------------------|
| CI           | A Continuous Integration build. CI can be the result of a manual or automated build.                |
| PR           | A Pull Request build. The PR build reason is only set during an automated PR build.                 |
| Prerelease   | A prerelease build is the result of a manual build with build reason as Prerelease.                 |
| Release      | A release build is the result of a manual build with build reason as Release.                       |

Project versioning and deployment options are dependent on the build purpose. The default value during a manual build
is **CI**.

### Carpenter.Project

The name of the project. This value is set by the `project` parameter. If parameter is notsupplied, the
default value is the value of the `Build.DefinitionName` variable.

### Carpenter.Project.Path

The absolute path of the project source. This value is determined during pipeline execution.

### Carpenter.Solution.Path

The absolute path to the solution. This value is determined during pipeline execution.

### Pool Configuration

#### Carpenter.Pool.Default.Demands

The demands for the agent when using a *Private* pool type. This value is set by the
`defaultPoolDemands` parameter.

#### Carpenter.Pool.Default.Name

The pool name to use when using *Private* pool type. This value is set by the `defaultPoolName`
parameter. The default value is **Default**.

#### Carpenter.Pool.Default.Type

The default pool type to use for jobs.

| Pool Type | Description |
|:--|:--|
| Hosted | Microsoft Hosted Agent Pool |
| Private | Private Agent Pool |

 This value is set by the `defaultPoolType` parameter. The default value is **Hosted**.

#### Carpenter.Pool.Default.VMImage

The VM Image to use when using Hosted pool type. This value is set by the `defaultPoolVMImage`
parameter. The default value is **ubuntu-latest**.

### Build Versioning

#### Carpenter.Version.Type

The type of build versioning to use.

| Version Type | Description |
|:--|:--|
| None | No build versioning |
| SemVer | Semantic Versioning 2.0.0 |

This value is set by the `versionType` parameter. The default value is **None**.

#### Carpenter.Version.VersionFile

The path to the VERSION file. This value is set by the `versionFile` parameter. The
default value is **VERSION**.

#### Carpenter.Version.Revision

The number of times the project has been built by this pipeline. This value is determined
during pipeline execution.

#### Carpenter.Version.RevisionOffset

The starting value of the revision counter. This value is set by the `revisionOffset` parameter.
The default value is **0**.

#### Carpenter.Version.Major

The Major version number. This value is determined during pipeline execution from the VERSION file.

#### Carpenter.Version.Minor

The Minor version number. This value is determined during pipeline execution from the VERSION file.

#### Carpenter.Version.Patch

The Patch version number. This value is determined during pipeline execution from the VERSION file.

#### Carpenter.Version.Label

The version label. This value is determined during pipeline execution.

#### Carpenter.Version

The version string (without version metadata). This value is determined during pipeline execution.

#### Carpenter.Version.IncrementOnRelease

If true, the patch version is incremented on a release. This value is set by the `incrementVersionOnRelease`
parameter. The default value is **false**.

### Continuous Integration

#### Carpenter.ContinuousIntegration.Date

The date code of the continuous integration build. This value is determined during pipeline
execution.

#### Carpenter.ContinuousIntegration.Revsision

The revision of the continuous integration build. Increments for each build under a specific date.
This value is determined during pipeline execution.

### Pull Request

#### Carpenter.PullRequest.Revision

The pull request revision. This value is determined during the pipeline execution.

### Prerelease

#### Carpenter.Prerelease.Label

The label to use for a prerelease build. This value is set by the `prereleaseLabel` parameter.
The default value is **alpha**.

#### Carpenter.Prerelease.Revision

The prerelease revision. This value is determined during pipeline execution.

### PipelineBot

#### Carpenter.PipelineBot

The GitHub username for the pipeline bot. This value should be supplied to the pipeline as
a variable, either directly through the YAML or through a Variable group.

#### Carpenter.PipelineBot.Email

The email address of the pipeline bot. This value should be supplied to the pipeline as
a variable, either directly through the YAML or through a Variable group.

#### Carpenter.PipelineBot.Name

The name of the pipeline bot. This value should be supplied to the pipeline asa variable,
either directly through the YAML or through a Variable group.

#### PipelineBot-GitHub-PAT

The GitHub personal access token for the pipeline bot. This value should be supplied to
the pipeline as a secret variable through a Variable group or through an Azure key vault.

### .NET Build

#### Carpenter.Build.DotNet

If true, a dotnet build process is executed. This value is set by the `buildDotNet` parameter.
The default value is **false**.

### Test Execution

#### Carpenter.Test.Unit

If true, unit tests are executed during the pipeline. This value is set by the
`executeUnitTests` parameter. The default valuer is **false**.

### SonarCloud Analysis

#### Carpenter.SonarCloud

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
