# Troubleshooting

⬅️ [README](../README.md)

## Error "address already in use" or "port is already allocated"

On the `docker compose up`, you can have the followings errors:

> Error response from daemon: driver failed programming external connectivity on endpoint symfony-starter-php-1 (...): Error starting userland proxy: listen tcp4 0.0.0.0:80: bind: address already in use

> Error response from daemon: driver failed programming external connectivity on endpoint symfony-starter-php-1 (...): Bind for 0.0.0.0:443 failed: port is already allocated

### Solution 1 - Custom HTTP ports

> See https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#using-custom-http-ports.

- Method 1

```shell
HTTP_PORT=8000 HTTPS_PORT=4443 HTTP3_PORT=4443 make generate
# or
HTTP_PORT=8000 HTTPS_PORT=4443 HTTP3_PORT=4443 make upd
```

- Method 2

```dotenv
# .env.local
HTTP_PORT=8000
HTTPS_PORT=4443
HTTP3_PORT=4443
```

```shell
make generate
# or
make upd
```


### Solution 2 - Find and stop the container using the port

- List containers using the `443` port:

```shell
docker ps | grep :443
c91d77c0994e   app-php   "docker-entrypoint f…"   15 hours ago   Up 15 hours (healthy)   0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp, 0.0.0.0:443->443/udp, :::443->443/udp, 2019/tcp   other-container-php-1
```

- And stop the container by `ID` or by `NAME`:

```shell
docker stop c91d77c0994e
docker stop other-container-php-1
```

- It is also possible to stop all running containers at once:

```shell
docker stop $(docker ps -a -q)
```

### Solution 3 - Find and stop the service using the port

- See the network statistics:

```shell
sudo netstat -pna | grep :80
tcp6       0      0 :::80        :::*        LISTEN        4321/apache2
```

- For example, in that previous case `4321/apache2`, you can stop [Apache server](https://httpd.apache.org/):

```shell
sudo service apache2 stop
````

## Editing permissions on Linux

If you work on linux and cannot edit some of the project files right after the first installation, you can run in that project `make permissions`, to set yourself as owner of the project files that were created by the docker container.

> See https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md