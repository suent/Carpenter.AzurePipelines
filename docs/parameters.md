[Carpenter.AzurePipelines Parameters](#carpenterazurepipelines-variables)
* [Pipeline parameters](#pipeline-parameters)
  * [pipelineVersion](#pipelineversion)
  * [includePipeline](#includepipeline)
* [General Build parameters](#general-build-parameters)
  * [buildPurpose](#buildpurpose)
  * [project](#project)
* [Pool Configuration](#pool-configuration)
  * [defaultPoolType](#defaultpooltype)
  * [defaultPoolName](#defaultpoolname)
  * [defaultPoolDemands](#defaultpooldemands)
  * [defaultPoolVMImage](#defaultpoolvmimage)
* [Build Versioning](#build-versioning)
  * [versionType](#versiontype)
  * [versionFile](#versionfile)
  * [revisionOffset](#revisionoffset)
  * [prereleaseLabel](#prereleaselabel)
  * [incrementVersionOnRelease](#incrementversiononrelease)
* [.NET Build](#net-build)
  * [buildDotNet](#builddotnet)
* [Test Execution](#test-execution)
  * [executeUnitTests](#executeunittests)
* [SonarCloud Analysis](#sonarcloud-analysis)
  * [sonarCloud](#sonarcloud)
  * [sonarCloudOrganization](#sonarcloudorganization)
  * [sonarCloudProjectKey](#sonarcloudprojectkey)
  * [sonarCloudServiceConnection](#sonarcloudserviceconnection)
* [Deployment parameters](#deployment-parameters)
  * [deployBranch](#deploybranch)
  * [deployNuGet](#deploynuget)
  * [nuGetTargetFeedDev](#nugettargetfeeddev)
  * [nuGetTargetFeedTest1](#nugettargetfeedtest1)
  * [nuGetTargetFeedTest2](#nugettargetfeedtest2)
  * [nuGetTargetFeedStaging](#nugettargetfeedstaging)
  * [nuGetTargetFeedProd](#nugettargetfeedprod)
  * [updateNugetQuality](#updatenugetquality)
  * [nuGetQualityFeed](#nugetqualityfeed)
  * [nuGetQualityDev](#nugetqualitydev)
  * [nuGetQualityTest1](#nugetqualitytest1)
  * [nuGetQualityTest2](#nugetqualitytest2)
  * [nuGetQualityStaging](#nugetqualitystaging)
  * [nuGetQualityProd](#nugetqualityprod)
  * [gitHubServiceConnection](#githubserviceconnection)

# Carpenter.AzurePipelines Parameters

## Pipeline parameters

### pipelineVersion

The version of the pipeline. Used to accomodate rolling breaking changes across multiple pipelines.
A breaking change could implement new functionality under an incremented version number, and move
dependent pipelines over separately. The default value is **1**. To ensure that future changes to the pipeline
do not break build which extend this template, it is recommended that this parameter is passed to
the template.

For more information, see: [pipeline-versioning.md](pipeline-versioning.md)

### includePipeline

If true, the pipeline will be included in the sources directory. When directly linking the pipeline
template through a repository resource, includePipeline must be true to download the Carpenter
scripts and tools to be available to the pipeline. The default value is **true**.

## General Build parameters

### buildPurpose

The purpose of the build if a build is manually run. This value gets overridden by automated builds.

| Build Reason | Description                                                                                         |
|:-------------|:----------------------------------------------------------------------------------------------------|
| CI           | A Continuous Integration build. CI can be the result of a manual or automated build.                |
| PR           | A Pull Request build. The PR build reason is only set during an automated PR build.                 |
| Prerelease   | A prerelease build is the result of a manual build with build reason as Prerelease.                 |
| Release      | A release build is the result of a manual build with build reason as Release.                       |

### project
    
The name of the project.

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

The prerelease label. This value is only used if `buildPurpose` is **Prerelease**.

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

### nuGetTargetFeedStaging

The target NuGet feed to use when deploying NuGet packages to the Staging stack.

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

### nuGetQualityStaging

The target quality when updating quality on the Staging stack.

### nuGetQualityProd

The target quality when updating quality on the Production stack.

### gitHubServiceConnection

The service connection to use when executing GitHub tasks.
