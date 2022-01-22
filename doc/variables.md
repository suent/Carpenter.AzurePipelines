# carpenter-azure-pipelines Variables

## Pipeline variables

### Carpenter.PipelineVersion

The pipeline version is used to gate breaking changes. More info: [pipeline-versioning.md](pipeline-versioning.md)

### Carpenter.Project

The project this pipeline belongs to.

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
