# Prestashop

## Cron

Create **cronjobs/jobs** file and add there a cron entries. You can copy example
file **cronjobs/jobs.dist**:

```
cp cronjobs/jobs.dist cronjobs/jobs
echo "* * * * * /cronjobs/custom-script.sh" > cronjobs/jobs
echo "* 8 * * * /cronjobs/custom-script-2.sh" >> cronjobs/jobs
```

Add custom scripts to **cronjobs/** directory. Remember to add **.sh** extension
to files. Entrypoint will add `x` mode to all files **cronjobs/\*.sh**.

**Note!** Name custom scripts like `modulename-youractionname.sh`.

## Update

To update `Prestashop` from cli just run:

```
bin/autoupgrade --dir=adminxyz
```

Use `bin/autoupgrade --help` to see more options.

### Change update config

To do that just copy **update-config.json** to **prestashop/update-config.json**,
change values up to you and run:

```
bin/autoupgrade-config --from=update-config.json
```

Recommend to setup `"skip_backup": true`. You're using other tools to makes a
backup.
