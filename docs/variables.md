[Carpenter.AzurePipelines Variables](#carpenterazurepipelines-variables)
* [Pipeline variables](#pipeline-variables)
  * [Carpenter.PipelineVersion](#carpenterpipelineversion)
  * [Carpenter.Pipeline](#carpenterpipeline)
  * [Carpenter.Pipeline.Path](#carpenterpipelinepath)
  * [Carpenter.Pipeline.ScriptPath](#carpenterpipelinescriptpath)
  * [Carpenter.DotNet.Path](#carpenterdotnetpath)
* [Build variables](#build-variables)
  * [Carpenter.Build.Purpose](#carpenterbuildpurpose)
  * [Carpenter.Project](#carpenterproject)
  * [Carpenter.Project.Path](#carpenterprojectpath)

# Carpenter.AzurePipelines Variables

## Pipeline variables

### Carpenter.PipelineVersion

The version of the pipeline. Used to accomodate rolling breaking changes across multiple pipelines.
A breaking change could implement new functionality under an incremented version number, and move
dependent pipelines over separately. This value is set by the `pipelineVersion` parameter. The
default value is **1**. 

More info: [pipeline-versioning.md](pipeline-versioning.md)

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

## Build variables

### Carpenter.Build.Purpose

The purpose of the build. This value gets set automatically during an automated build. If a manual
build, the value of the `buildReason` parameter is used.

| Build Type | Description                                                                                         |
|:-----------|:----------------------------------------------------------------------------------------------------|
| CI         | A Continuous Integration build. CI can be the result of a manual or automated build.                |
| PR         | A Pull Request build. The PR build reason is only set during an automated PR build.                 |
| Prerelease | A prerelease build is the result of a manual build with build reason as Prerelease.                 |
| Release    | A release build is the result of a manual build with build reason as Release.                       |

Project versioning and deployment options are dependent on the build purpose. The default value during a manual build
is **CI**.

### Carpenter.Project

The name of the project. This value is set by the `project` parameter. If not supplied, Carpenter.Project defaults to the value of the `Build.DefinitionName` variable.

### Carpenter.Project.Path

The absolute path of the project source. This value is determined during pipeline execution.

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

The number of times the project has been built by this pipeline.

#### Carpenter.Version.RevisionOffset

The starting value of the revision counter.

#### Carpenter.Version.Major

The Major version number.

#### Carpenter.Version.Minor

The Minor version number.

#### Carpenter.Version.Patch

The Patch version number.

#### Carpenter.Version.Label

The version label.

#### Carpenter.Version

The version string. (without version metadata)

#### Continuous Integration

##### Carpenter.ContinuousIntegration.Date

The date code of the continuous integration build.

##### Carpenter.ContinuousIntegration.Revsision

The revision of the continuous integration build. Increments for each build under a specific date.

#### Pull Request

##### Carpenter.PullRequest.Semantic

The semantic used to generate the pull request revision.

##### Carpenter.PullRequest.Revision

The pull request revision.
