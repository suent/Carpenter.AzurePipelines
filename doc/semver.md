# Semantic Versioning 2.0.0

Carpenter supports Semantic Versioning 2.0.0 to better define how version numbers are assigned and incremented. More information about SemVer can be found at [https://semver.org/](https://semver.org/).

## Enabling SemVer versioning

To enable SemVer versioning, add the following parameter to your yaml.

```
stages:
- template: template/carpenter-default.yml
  parameters:
    buildVersionType: semver
```
