# gitlab-docker-compose
Self hosted GitLab-ce via docker-compose

## Requirements
- Ubuntu 20.04 or later
- root access to host machine
- docker installed
- docker-compose installed


## Install instructions

install prerequisites, docker and docker compose

```sh
sudo apt-get update
sudo apt-get install -y docker.io docker-compose
```

clone the repo

```sh
git clone https://github.com/bflance/gitlab-docker-compose.git
```

Start docker compose to create gitlab environment

```
cd gitlab-docker-compose
docker-compose up -d
```

## Monitor start up status
wait until you see "(healthy)" status
```
docker ps | grep gitlab-ce
541c51218faa   gitlab/gitlab-ce:16.5.2-ce.0   "/assets/wrapper"   4 minutes ago   Up About a minute (healthy)   0.0.0.0:9422->22/tcp, 0.0.0.0:8081->80/tcp, 0.0.0.0:8443->443/tcp   gitlab-ce
```
Also check that all services are up:
```
docker exec -it gitlab-ce gitlab-ctl status
run: alertmanager: (pid 863) 110s; run: log: (pid 564) 137s
run: gitaly: (pid 369) 159s; run: log: (pid 368) 159s
run: gitlab-exporter: (pid 832) 112s; run: log: (pid 462) 156s
run: gitlab-kas: (pid 362) 159s; run: log: (pid 354) 159s
run: gitlab-workhorse: (pid 366) 159s; run: log: (pid 356) 159s
run: logrotate: (pid 363) 159s; run: log: (pid 360) 159s
run: nginx: (pid 367) 159s; run: log: (pid 364) 159s
run: postgres-exporter: (pid 877) 110s; run: log: (pid 585) 131s
run: postgresql: (pid 371) 159s; run: log: (pid 370) 159s
run: prometheus: (pid 842) 111s; run: log: (pid 522) 143s
run: puma: (pid 361) 159s; run: log: (pid 359) 159s
run: redis: (pid 365) 159s; run: log: (pid 358) 159s
run: redis-exporter: (pid 834) 112s; run: log: (pid 484) 152s
run: sidekiq: (pid 373) 159s; run: log: (pid 372) 159s
run: sshd: (pid 52) 175s; run: log: (pid 51) 175s
```


---
**_NOTE:_**  \
The TOKEN is - **this-is-my-secret-token123**
---

Now lets create a token a generate configuration (api token, users,groups, demo projects,etc..)

```sh
scripts/generate-config.sh
```
this will create everything required.

## Access the gitlab

In browser head to this url:  [https://localhost:8443](https://localhost:8443)
```
Username: root
Password: MySecretPassword
```


**_NOTE:_** Remember to change the password
---


## Running backups

To create backup on-demand, simply run this:

```sh
docker exec -ti gitlab-ce /scripts/run-backup.sh
```

Backups will be available in 'backups/' folder with .tar files
NOTE:
there will be 2 tar files,
- gitlab_config_XXXX.tar - contains secrets and keys and confog
- XXXXX_gitlab_backup.tar - contains data, repos,etc..

To make backups run daily, please simply run this:

```sh
cat >> /etc/cron.d/gitlab-backup << "EOF"
0 5 * * * root /usr/local/bin/docker exec -i gitlab-ce /scripts/run-backup.sh
```
This will create a cronjob to backup to run backup every day at 5AM,
Edit crontab if you need to run it on other time.