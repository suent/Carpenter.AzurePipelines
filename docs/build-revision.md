# Build Revision

The build revision tracks the number of builds for a particular project.

## project Parameter

The revision is linked to the `project` name. If the `project` changes, the revision will reset unless the `revisionOffset` parameter is updated to the expected new revision number.

## revisionOffset Parameter

The revisionOffset parameter is used as the starting value for the revision. Once a build has been completed, this value is no longer used unless the `project` changes.
