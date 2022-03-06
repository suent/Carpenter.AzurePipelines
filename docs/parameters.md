
## Pool Configuration

For more information:
https://github.com/suent/carpenter-azure-pipelines/blob/main/doc/configure-pool.md

### defaultPoolType

The default pool type to use for jobs.
| Pool Type | Description                     |
|:----------|:--------------------------------|
| Hosted    | Microsoft Hosted Pool [Default] |
| Private   | Private (self hosted) Pool      |

### defaultPoolName

The pool name to use when using Private pool type. The default value is **Default**.


### defaultPoolDemands

The demands for the agent when using a Private pool type. For more information on demands, see:
https://docs.microsoft.com/en-us/azure/devops/pipelines/process/demands?view=azure-devops&tabs=yaml

### defaultPoolVMImage

The VM Image to use when using Hosted pool type. The default value is **ubuntu-latest**.

## Build Versioning

For more information:
https://github.com/suent/carpenter-azure-pipelines/blob/main/doc/build-versioning.md

### versionType

The type of build versioning to use.
| Version Type | Description                   |
|:-------------|:------------------------------|
| None         | No build versioning [Default] |
| SemVer       | Semantic Versioning 2.0.0     |

### versionFile

The path to the VERSION file. The default value is **VERSION**.

### revisionOffset

The starting value of the revision counter. The default value is **0**.

### prereleaseLabel

The prerelease label. This value is only used if `pipelineReason` is **Prerelease**.

### incrementVersionOnRelease

Increment the VERSION file on release and check into source control.

## .NET Build

For more information:
https://github.com/suent/carpenter-azure-pipelines/blob/main/doc/build.md

### buildDotNet

Perform dotnet build

## Test Execution

### executeUnitTests

## SonarCloud Analysis

For more information:
https://github.com/suent/carpenter-azure-pipelines/blob/main/doc/analysis-sonarcloud.md

### sonarCloud

If true, SonarCloud analysis is executed. The default value is **false**.

### sonarCloudOrganization

The SonarCloud organization this project is under. This is required if `sonarCloud` is **true**.

### sonarCloudProjectKey

The SonarCloud project key. This is required if `sonarCloud` is **true**.

### sonarCloudServiceConnection

The SonarCloud service connection to use. This is required if `sonarCloud` is **true**.

## Deployment parameters

### deployBranch

Comma separated list of stacks deploy branch should execute for. Creates a branch of this builds
source to represent code on a stack.

### deployNuGet

Comma separated list of stacks deploy nuget should execute for. Publishes NuGet packages created by
this pipeline.

### nuGetTargetFeedDev

The target NuGet feed to use when deploying NuGet packages to the Dev stack.

### nuGetTargetFeedTest1

The target NuGet feed to use when deploying NuGet packages to the Test1 stack.

### nuGetTargetFeedTest2

The target NuGet feed to use when deploying NuGet packages to the Test2 stack.

### nuGetTargetFeedStage

The target NuGet feed to use when deploying NuGet packages to the Stage stack.

### nuGetTargetFeedProd

The target NuGet feed to use when deploying NuGet packages to the Prod stack.

### updateNuGetQuality

Comma separated list of stacks update quality should execute for. Updates the described quality of
a NuGet package using the Artifact views.

### nuGetQualityFeed

The Azure DevOps Artifact NuGet package feed to use when updating quality.

### nuGetQualityDev

The target quality when updating quality on the Developer stack.

### nuGetQualityTest1

The target quality when updating quality on the Test 1 stack.

### nuGetQualityTest2

The target quality when updating quality on the Test 2 stack.

### nuGetQualityStage

The target quality when updating quality on the Staging stack.

### nuGetQualityProd

The target quality when updating quality on the Production stack.

### gitHubServiceConnection

The service connection to use when executing GitHub tasks.
