# Prestashop

It's a simply as possible `docker-compose` stack to run a
[Prestashop](https://www.prestashop.com/en) for **development** and for
**production**.

---

- [Requirements](#requirements)
- [Run](#run)
	- [Fresh run](#fresh-run)
	- [Run installed shop](#run-installed-shop)
	- [Production](#production)
	- [Docker envs](#docker-envs)
	- [Redis](#redis)
	- [Maintainance](#maintainance)
- [Cron](#cron)
	- [New cron job](#new-cron-job)
	- [Monitor cron jobs](#monitor-cron-jobs)
	- [Reinstall cron jobs](#reinstall-cron-jobs)
- [Backup](#backup)
- [Update](#update)
	- [Change update config](#change-update-config)
- [Debug](#debug)

## Requirements

To run this you just need a [docker](https://www.docker.com/get-started/) and
[docker-compose](https://github.com/docker/compose#quick-start).

## Run

You can install a fresh instance of Prestashop or restore your already installed
shop from dump/backup.

### Fresh run

When you want to run fresh instance of prestashop:

1. Create a **.env** file (use **.env.dist** as starter file,
`cp .env.dist .env`) and setup values.
2. Run `docker-compose up [-d]`.
3. Wait for download and build images.
4. Wait for install a fresh Prestashop instance.
5. Goto [PS_DOMAIN:PRESTASHOP_PORT](http://localhost/) domain and play with your
new shop.

### Run installed shop

When you have a dump of your already installed Prestashop instance:

1. Create a **.env** file (use **.env.dist** as starter file,
`cp .env.dist .env`) and setup **required** values:
	- `DB_PREFIX` (`database_prefix`),
	- `MYSQL_DATABASE` (`database_name`),
	- `MYSQL_PASSWORD` (`database_password`),
	- `MYSQL_USER` (`database_user`).
They should have the same values as in **app/config/parameters.php**.
2. Move your database dump file(s) into **initdb.d/** directory.
3. Move your files into **prestashop/** directory.
4. Run `docker-compose up [-d]`.
5. Wait for download and build images.
6. Wait when `db` service will load dump file(s) into the database.
**Note!** When you goto the shop before database is loaded you will got an
error. Please be patient and wait for database.
7. Goto [http://localhost/](http://localhost/) domain and play with your new
shop.

### Production

If you want to run **prod**uction environment

1. Uncomment line `#COMPOSE_FILE=docker-compose.yml:docker-compose.prod.yml` in
**.env** file. It tells to `docker-compose` to use those files instead of
default **docker-compose.yml** and  **docker-compose.override.yml** (they're
good for **dev**elopment).
2. Rebuild images with `docker-compose build [--pull]`.
3. Run new stack `docker-compose up [-d]`.

### Docker envs

`PRESTASHOP_HOST` allow to change a host on which `nginx` services is
listening. Default it's `127.0.0.1` so only you can connect from your local
machine to the shop. Setup `0.0.0.0` to allow others from the same network to
connect to your shop (for example to test shop on your mobile).

Other environments are described
[here](https://hub.docker.com/r/prestashop/prestashop).

### Redis

Setup redis as a session handler can increase some server performance. To do it
edit your **.env** file. Add `:docker/redis/compose.yml` to `COMPOSE_FILE`
environment.

You can also change other environments:

```bash
REDIS_HOST_PASSWORD=!ChangeMe!
REDIS_IMAGE=extalion/prestashop_redis
```

### Maintainance

From time to time is good to clean database from old records in specific tables.
To do that there's a command `bin/mysql-clear`. Run:

```bash
bin/mysql-clear [--db-prefix DB_PREFIX] [--days DAYS] [--dry-run] [-h] [--clean-*]
```

Before delete any data from database is good to make a [backup](#backup).

## Cron

Create **cronjobs/jobs** file and add there a cron entries. You can copy example
file **cronjobs/jobs.dist**:

```bash
cp cronjobs/jobs.dist cronjobs/jobs
echo "* * * * * /cronjobs/custom-script.sh" > cronjobs/jobs
echo "* 8 * * * /cronjobs/custom-script-2.sh" >> cronjobs/jobs
```

Add custom scripts to **cronjobs/** directory. Remember to add **.sh** extension
to files. Entrypoint will add `x` mode to all files **cronjobs/\*.sh**.

**Note!** Name custom scripts like `modulename-youractionname.sh`.

### New cron job

You can use template file **cronjobs/example.sh** to create your own cron job.
Put your logic between those lines:

```bash
###> Your cron job ###
...
###< Your cron job ###
```

In the most cases you will use `http` and it should looks like:

```bash
curl -Ls "${moduleCronUrl}" >> "${log_file}" 2>&1
```

where `$moduleCronUrl` you can find in specific module configuration. For
example goto
[gsitemap](http://localhost/adminxyz/index.php?controller=AdminModules&configure=gsitemap)
module configuration page and check `Information` section.

### Monitor cron jobs

To monitor your cron jobs you can use [cronitor](https://cronitor.io) or
[sentry](https://docs.sentry.io/product/crons/).

For **cronitor**:

- setup `CRONITOR_KEY` key in **.env** file,
- uncomment line `#run_cronitor "$script_name"` to start monitor a job,
- uncomment line `#complete_cronitor "$script_name"` to finish monitor a job.

**Note!** Yours monitor(s) names will be the same as a script name.

For **sentry**:

- setup `SENTRY_DSN` key in **.env** file,
- uncomment line `#sentry_monitor_id=''` and provide `monitorId`,
- uncomment line `#check_in_id="$(run_sentry "$sentry_monitor_id")"` to start
monitor a job,
- uncomment line
`#complete_sentry "$sentry_monitor_id" "$check_in_id" "$duration"` to finish
monitor a job.

### Reinstall cron jobs

When you change an entries in **cronjobs/jobs** file remember to run
`bin/install-cronjobs`.

## Backup

To make a backup we're using a
[docker-backup](https://github.com/eXtalionLab/docker-backup) tool which use
[BorgBackup](https://www.borgbackup.org/) under hood.

Create a **.docker-backup** file (use **.docker-backup.dist** as starter file,
`cp .docker-backup.dist .docker-backup`) and setup values. Refer to
[documentation](https://github.com/eXtalionLab/docker-backup#docker-backup).

**Note!** In `filesToExclude` change admin directory name to point to your admin
directory.

## Update

To update `Prestashop` from cli just run:

```
bin/autoupgrade --dir=adminxyz
```

Use `bin/autoupgrade --help` to see more options.

**Note!** Under hood we're using
[autoupgrade](https://github.com/PrestaShop/autoupgrade) module.

### Change update config

To do that just copy **update-config.json** to
**prestashop/update-config.json**, change values up to you and run:

```
bin/autoupgrade-config --from=update-config.json
```

Recommend to setup `"skip_backup": true`. You're already using other tool(s) to
make a [backup](#backup).

## Debug

If you want to debug a shop with [xdebug](https://xdebug.org/):

- be sure you're running **dev** environment (and images),
- add/setup `debug` to `XDEBUG_MODE`,
- reload docker with `docker-compose up -d`.

Now you're ready to remote debugging.
