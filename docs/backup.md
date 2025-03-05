## Backup

To make a backup we're using a
[docker-backup](https://github.com/eXtalionLab/docker-backup) tool which use
[BorgBackup](https://www.borgbackup.org/) under hood.

Create a **.docker-backup** file (use **.docker-backup.dist** as starter file,
`cp .docker-backup.dist .docker-backup`) and setup values. Refer to
[documentation](https://github.com/eXtalionLab/docker-backup#docker-backup).

**Note!** In `filesToExclude` change admin directory name to point to your admin
directory.
