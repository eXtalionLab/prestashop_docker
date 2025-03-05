# Maintenance

From time to time is good to clean database from old records in specific tables.
To do that there's a command `bin/mysql-clear`. Run:

```bash
bin/mysql-clear [--db-prefix DB_PREFIX] [--days DAYS] [--dry-run] [-h] [--clean-*]
```

**Note!** Before delete any data from database is good to make a
[backup](backup.md).
