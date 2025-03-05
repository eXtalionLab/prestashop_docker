# Production

When you want to run your shop in production environment you have to build "new"
docker images and start your stack:

```bash
docker compose -f compose.yml -f compose.prod.yml build [--pull]
docker compose -f compose.yml -f compose.prod.yml up [-d]
```

To skip this extra options you can create a **.env** file with `COMPOSE_FILE`
variable:

```bash
echo "COMPOSE_FILE=compose.yml:compose.prod.yml" > .env
```

You can also copy **.env.dist** file and uncomment line with `COMPOSE_FILE`:

```bash
cp .env.dist .env
vim .env
```

Then you can just run:

```bash
docker compose build [--pull]
docker compose up [-d]
```
