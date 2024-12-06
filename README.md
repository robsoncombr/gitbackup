**This is a Working in Progress project, not ready for usage, contributions are welcome**

# gitbackup

Backup Strategy for Ignored Git Files

Solution to determine possible important files and folders that are ignored by git and should be backed up.

## Motivation

When working with git, it is common to ignore files and folders that are not necessary to be versioned. However, some of
these files and folders may contain important data that should be backed up somehow, but everybody knows this is an
important security hole and can be risky.

## Solution

The solution is to create a backup strategy to determine possible important files and folders that are ignored by git
and should be backed up. This strategy should be able to determine the files and folders that are ignored by git and
should be backed up, and also create a backup procedure to pack all sensitive data and send the backup to remote
protected storage.
