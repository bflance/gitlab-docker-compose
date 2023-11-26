#!/bin/bash
### Full backup without secret
/opt/gitlab/bin/gitlab-rake gitlab:backup:create

## Config and keys/secrets
mkdir -p /var/opt/gitlab/backups
/opt/gitlab/bin/gitlab-ctl backup-etc
cd /etc/gitlab/config_backup
cp $(ls -t | head -n1) /var/opt/gitlab/backups



