1. Determine a remote service to be used as sensitive backup storage:

- Needs to be cheap, secure, and reliable.
- Archive-type backups should be compressed and encrypted.
- Preferably use a remote key service for encryption and decryption.
- Preferably protection of communication by encrypted channels using peer-to-peer certificates.

2.

- Create a list of known data that should still be ignored or a list of known data that has to be saved.

3.

- Create a backup procedure to pack all sensitive data and send the backup to remote protected storage.
- Create a solution for versioning the backup files.

4.

- Create a bare clone of the repository, compact it, and also save it to remote storage.

5.

- Create an automation script to rollback or download access for any reason.
- Should consider versioning to rollback to a specific version in time.
