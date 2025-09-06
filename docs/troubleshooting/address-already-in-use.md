# Error "address already in use" or "port is already allocated"

[⬅️ Troubleshooting](../troubleshooting.md)

---

## Problem

When running `make up_detached` or `docker compose up`, you might see errors like these:

> Error response from daemon: driver failed programming external connectivity on endpoint symfony-starter-php-1 (...): Error starting userland proxy: listen tcp4 0.0.0.0:80: bind: address already in use

> Error response from daemon: driver failed programming external connectivity on endpoint symfony-starter-php-1 (...): Bind for 0.0.0.0:443 failed: port is already allocated

These errors indicate that another process or container is already using the required ports (80 or 443).

## Solution 1. Custom HTTP ports (Recommended for persistent issues)

This method allows you to change the ports your Symfony application uses, which is useful if you frequently have other services occupying default ports.

> See https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#using-custom-http-ports.

- **Method A: In the command line**

```shell
HTTP_PORT=8000 HTTPS_PORT=4443 HTTP3_PORT=4443 make generate
# or, if the project is already generated:
HTTP_PORT=8000 HTTPS_PORT=4443 HTTP3_PORT=4443 make up_detached
````

- **Method B: Using `.env.local` for a permanent setting**

Add these lines to your `.env.local` file:

```dotenv
# .env.local
HTTP_PORT=8000
HTTPS_PORT=4443
HTTP3_PORT=4443
```

Then, run your `make` command:

```shell
make generate
# or
make up_detached
```

## Solution 2. Find and stop the **container** using the port

If another Docker container is occupying the port, you can find and stop it.

- List containers using, for example, port `443`:

<!-- end list -->

```shell
docker ps | grep :443
# Example output:
# c91d77c0994e   app-php   "docker-entrypoint f…"   15 hours ago   Up 15 hours (healthy)   0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp, 0.0.0.0:443->443/udp, :::443->443/udp, 2019/tcp   other-container-php-1
```

- Stop the container using its `ID` or `NAME`:

<!-- end list -->

```shell
docker stop c91d77c0994e       # Stop by ID
docker stop other-container-php-1 # Stop by NAME
```

- Alternatively, you can stop all running Docker containers at once (use with caution\!):

<!-- end list -->

```shell
docker stop $(docker ps -a -q)
```

## Solution 3. Find and stop the **service** using the port (Linux)

If a non-Docker service (like Apache, Nginx, or another local web server) is using the port, you need to stop that service.

- See the network statistics and identify the process using the port (e.g., `:80`):

<!-- end list -->

```shell
sudo netstat -pna | grep :80
# Example output:
# tcp6        0      0 :::80       :::* LISTEN      4321/apache2
```

- In the example above, `4321/apache2` indicates Apache is running. You can stop it (command varies by service and Linux distribution):

<!-- end list -->

```shell
sudo service apache2 stop # For Apache on systems using 'service' command
# sudo systemctl stop apache2 # For Apache on systems using 'systemctl'
```

---

[⬅️ Troubleshooting](../troubleshooting.md)
