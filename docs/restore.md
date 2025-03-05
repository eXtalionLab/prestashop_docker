# Restore

When you have a dump of your already installed Prestashop instance:

1. Create a **.env** file (use **.env.dist** as starter file,
`cp .env.dist .env`) and setup **required** values:
	- `DB_PREFIX` (`database_prefix`),
	- `MYSQL_DATABASE` (`database_name`),
	- `MYSQL_PASSWORD` (`database_password`),
	- `MYSQL_USER` (`database_user`).
They should have the same values as in **app/config/parameters.php**.
2. Move your database dump file(s) (.sh, .sql, .sql.gz, .sql.xz, .sql.zst) into
**initdb.d/** directory.
3. Move your files into **prestashop/** directory (replace existing directory
with your files).
4. Run `docker compose up [-d]`.
5. Wait for download and build images.
6. Wait when `database` service will load dump file(s) into the database.
**Note!** When you goto the shop before database is loaded you will got an
error. Please be patient and wait for database.
7. Goto [http://localhost/](http://localhost/) domain and play with your "new"
shop.
