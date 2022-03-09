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
