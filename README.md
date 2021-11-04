# Prestashop

## Cron

Create **cronjobs/jobs** file and add there a cron entries. You can copy example
file **cronjobs/jobs.dist**:

```
cp cronjobs/jobs.dist cronjobs/jobs
echo "* * * * * /cronjobs/custom_script.sh" > cronjobs/jobs
echo "* 8 * * * /cronjobs/custom_script_2.sh" >> cronjobs/jobs
```

Add custom scripts to **cronjobs/** directory. Remember to add **.sh** extension
to files. Entrypoint will add `x` mode to all files **cronjobs/\*.sh**.
