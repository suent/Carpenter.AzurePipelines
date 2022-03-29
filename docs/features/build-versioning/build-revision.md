# Build Revision

The build revision tracks the number of builds for a particular project.

## Carpenter.Project Variable

The revision is linked to the [`Carpenter.Project`](../../configuration.md#carpenterproject) variable value. If the
value changes, the revision will reset unless the 
[`Carpenter.Version.RevisionOffset`](../../configuration.md#carpenterversionrevisionoffset) variable is updated to the
expected starting revision number.

## Carpenter.Version.RevisionOffset Variable

The [`Carpenter.Version.RevisionOffset`](../../configuration.md#carpenterversionrevisionoffset) variable is used as
the starting value for the revision. Once a build has been completed, this value is no longer used unless the
[`Carpenter.Project`](../../configuration.md#carpenterproject) variable value changes.
