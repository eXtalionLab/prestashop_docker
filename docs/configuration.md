# Configuration

1. Create a **.env** file (use **.env.dist** as starter file,
`cp .env.dist .env`) and setup values.
2. Run `docker compose up [-d]`.
3. Wait for download and build images.
4. Wait for install a fresh Prestashop instance.
5. Goto [PS_DOMAIN:PRESTASHOP_PORT](http://localhost/) domain and play with your
new shop.

## Docker envs

`PRESTASHOP_HOST` allow to change a host on which `nginx` services is
listening. Default it's `127.0.0.1` so only you can connect from your local
machine to the shop. Setup `0.0.0.0` to allow others from the same network to
connect to your shop (for example to test shop on your mobile).

Other environments are described
[here](https://hub.docker.com/r/prestashop/prestashop).

# Debug

If you want to debug a shop with [xdebug](https://xdebug.org/):

- be sure you're running **dev** environment (and images),
- run `bin/xdebug` to toggle xdebug mode.

Now you're ready to remote debugging.
