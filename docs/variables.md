[Carpenter.AzurePipelines Variables](#carpenterazurepipelines-variables)
* [Pipeline variables](#pipeline-variables)
  * [Carpenter.PipelineVersion](#carpenterpipelineversion)
  * [Carpenter.Pipeline](#carpenterpipeline)
  * [Carpenter.Pipeline.Path](#carpenterpipelinepath)
  * [Carpenter.Pipeline.ScriptPath](#carpenterpipelinescriptpath)

# Carpenter.AzurePipelines Variables

## Pipeline variables

### Carpenter.PipelineVersion

The version of the pipeline. Used to accomodate rolling breaking changes across multiple pipelines.
A breaking change could implement new functionality under an incremented version number, and move
dependent pipelines over separately. This value is populated through the pipelineVersion parameter.
Defaults to 1. 

More info: [pipeline-versioning.md](pipeline-versioning.md)

### Carpenter.Pipeline

If true, the pipeline will be included in the sources directory. When directly linking the pipeline
template through a repository resource, includePipeline must be true to download the Carpenter
scripts and tools to be available to the pipeline. Defaults to true.

### Carpenter.Pipeline.Path

The path to the pipeline supporting files. This value is determined during the build.

### Carpenter.Pipeline.ScriptPath

The path to Carpenter pipeline scripts. This value is determined during the build.

### Carpenter.Build.Type

The type of build being executed. This value gets set automatically during an automated build.
If a manual build, the value of the buildType parameter is used.

| Build Type | Description                                                                                         |
|:-----------|:----------------------------------------------------------------------------------------------------|
| CI         | A Continuous Integration build. The CI build type can be the result of a manual or automated build. |
| PR         | A Pull Request build. The PR build type is only set during an automated PR build.                   |
| Prerelease | A prerelease build is the result of a manual build with build type as Prerelease.                   |
| Release    | A release build is the result of a manual build with build type as Release.                         |

Project versioning and deployment options are dependent on the build type.

### Carpenter.Project

The project this pipeline belongs to.

### Carpenter.Project.Path

### Pool Configuration

#### Carpenter.Pool.Default.Demands

The demands for the agent when using a Private pool type.

#### Carpenter.Pool.Default.Name

The pool name to use when using Private pool type. Defaults to 'Default'.

#### Carpenter.Pool.Default.Type

The default pool type to use for jobs.

| Pool Type | Description |
|:--|:--|
| Hosted | Microsoft Hosted Agent Pool |
| Private | Private Agent Pool |

The default value is `Hosted`.

#### Carpenter.Pool.Default.VMImage

The VM Image to use when using Hosted pool type. Defaults to 'ubuntu-latest'.

### Build Versioning

#### Carpenter.Version.Type

The type of build versioning to use.

| Version Type | Description |
|:--|:--|
| None | No build versioning |
| SemVer | Semantic Versioning 2.0.0 |

The default value is `None`.

#### Carpenter.Version.VersionFile

The path to the VERSION file.

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
