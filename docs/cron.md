# Cron

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

**Note!** When you change an entries in **cronjobs/jobs** file remember to run
`bin/install-cronjobs`!

## New cron job

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
example go and see
[gsitemap](http://localhost/adminxyz/index.php?controller=AdminModules&configure=gsitemap)
module configuration page and check `Information` section.

## Monitor cron jobs

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
