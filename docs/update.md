# Update

To update `Prestashop` from cli just run:

```
bin/autoupgrade --dir=adminxyz [--version=]
```

Use `bin/autoupgrade --help` to see more options.

**Note!** Change `adminxyz` to your admin directory name.

**Note!** Under hood we're using
[autoupgrade](https://github.com/PrestaShop/autoupgrade) module.

## Change update config

To do that just copy **update-config.json** to
**prestashop/update-config.json**, change values up to you and run:

```
bin/autoupgrade-config --from=update-config.json
```

Recommend to setup `"skip_backup": true`. You're already using other tool(s) to
make a [backup](backup.md).
