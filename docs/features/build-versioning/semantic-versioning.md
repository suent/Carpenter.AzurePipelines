# Semantic Versioning 2.0.0

Carpenter supports Semantic Versioning 2.0.0 to better define how version numbers are assigned and incremented. More
information about SemVer can be found at [https://semver.org/](https://semver.org/).

## Enabling SemVer versioning

To enable Semantic Versioning, pass the [**VersionSemVer**](../../operations.md#versionsemver) operation to the
[`pipelineOperations`](../configuration.md#carpenterpipelineoperations-pipelineoperations) parameter:

```
stages:
- template: template/carpenter-default.yml
  parameters:
    pipelineOperations:
    - VersionSemVer
```

## The `VERSION` file

The version file is used to populate the base build version.

By default, **VERSION** in the root of the source path is used.

Example VERSION file:
```
0.2.0
```

Related settings:

* [`Carpenter.Version.VersionFile`](../../configuration.md#carpenterversionversionfile)
* [`Carpenter.Version.VersionFile.Path`](../../configuration.md#carpenterversionversionfilepath)
* [`Carpenter.Version`](../../configuration.md#carpenterversion)
* [`Carpenter.Version.BaseVersion`](../../configuration.md#carpenterversionbaseversion)
* [`Carpenter.Version.Major`](../../configuration.md#carpenterversionmajor)
* [`Carpenter.Version.Minor`](../../configuration.md#carpenterversionminor)
* [`Carpenter.Version.Patch`](../../configuration.md#carpenterversionpatch)

## Build Labels

Build labels are controlled by the type of the build being executed.

The build type is defined by the 
[`(pipelineReason)`](../../configuration.md#carpenterpipelinereason-pipelinereason)
parameter.

### Continuous Integration

Continuous integration builds adds datecode and revision to the version label.

For example:

0.2.0-CI.20220122.1

Related settings:

* [`Carpenter.Version`](../../configuration.md#carpenterversion)
* [`Carpenter.Version.Label`](../../configuration.md#carpenterversionlabel)
* [`Carpenter.ContinuousIntegration.Date`](../../configuration.md#carpentercontinuousintegrationdate)
* [`Carpenter.ContinuousIntegration.Revision`](../../configuration.md#carpentercontinuousintegrationrevision)

### Pull Request

Pull request builds add the pull request number and revision to the version label.

For example:

0.2.0-PR.4.1

Related settings:

* [`Carpenter.Version`](../../configuration.md#carpenterversion)
* [`Carpenter.Version.Label`](../../configuration.md#carpenterversionlabel)
* [`Carpenter.PullRequest.Revision`](../../configuration.md#carpenterpullrequestrevision)

### Prerelease

Prerelease builds can be initiated manually by selecting **Prerelease** as the `pipelineReason`.

A prereleaseLabel is also required.

Fox example:
0.2.0-alpha.3

Related settings:

* [`Carpenter.Version`](../../configuration.md#carpenterversion)
* [`Carpenter.Version.Label`](../../configuration.md#carpenterversionlabel)
* [`Carpenter.Prerelease.Label` (`prereleaseLabel`)](../../configuration.md#carpenterprereleaselabel-prereleaselabel)
* [`Carpenter.Prerelease.Revision`](../../configuration.md#carpenterprereleaserevision)

### Release

Release builds can be initiated manually by selecting **Release** as the `pipelineReason`.

For example:
0.2.0

Related settings:

* [`Carpenter.Version`](../../configuration.md#carpenterversion)

## Automatically increment version file on Release

If the `pipelineOperations` parameter contains **IncrementVersionOnRelease**, the VERSION file will be incremented.

The [`PipelineBot-GitHub-PAT`](../../configuration.md#pipelinebot-github-pat) variable will need to be populated.
