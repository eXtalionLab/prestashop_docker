# Prestashop

It's a simply as possible `docker compose` stack to run a
[Prestashop](https://www.prestashop.com/) for **development** and for
**production**.

## Requirements

To run this you just need a [docker](https://www.docker.com/get-started/) and
[docker compose](https://docs.docker.com/compose/install/).

Optionally you need also [GIT](https://git-scm.com/downloads) to clone this
repository.

## Run

Download and extract this repository from
[here](https://github.com/eXtalionLab/prestashop_docker/archive/refs/heads/master.zip)
or clone it with `git`:

```bash
git clone git@github.com:eXtalionLab/prestashop_docker.git .
cd prestashop_docker
```

When you are in the project directory you can run the stack:

```bash
docker compose up [-d]
```

Wait for download and build images. Goto [http://localhost/](http://localhost/)
and enjoy your new shop. Goto [admin panel](http://localhost/adminxyz), login
with credentials `admin@email.com` and `admin123` and play with your
back-office.

## Read more

- [backup](docs/backup.md)
- [configuration](docs/configuration.md)
- [cron job(s)](docs/cron.md)
- [maintenance](docs/maintainance.md)
- [production environment](docs/production.md)
- [restore](docs/restore.md)
- [update](docs/update.md)
