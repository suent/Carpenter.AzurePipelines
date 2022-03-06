# Semantic Versioning 2.0.0

Carpenter supports Semantic Versioning 2.0.0 to better define how version numbers are assigned and incremented. More information about SemVer can be found at [https://semver.org/](https://semver.org/).

## Enabling SemVer versioning

To enable SemVer versioning, add the following parameter to your yaml.

```
stages:
- template: template/carpenter-default.yml
  parameters:
    versionType: SemVer
```

## The `VERSION` file

The version file is used to populate the build version.

By default, VERSION in the root of the source path is used.

## Build Labels

### Continuous Integration

Continuous integration builds adds datecode and revision to the version label.

For example:

0.2.0-CI.20220122.1

### Pull Request

Pull request builds add the pull request number and revision to the version label.

For example:

0.2.0-PR.4.1

### Prerelease

Prerelease builds can be initiated manually by selecting Prerelease as the pipelineReason.

A prereleaseLabel is also required.

Fox example:
0.2.0-alpha.3

### Release

Release builds can be initiated manually by selecting Release as the pipelineReason.

For example:
0.2.0

#### Automatically increment version file

If the incrementVersionOnRelease parameter is true, the VERSION file will be incremented.

The Carpenter.PipelineBot.Token variable or PipelineBot-GitHub-PAT vault secret will need to be populated. This can be done by adding the variable to your pipeline definition, or creating a Variable Group and adding it to your azure-pipelines.yml file.
