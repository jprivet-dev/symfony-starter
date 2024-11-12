# Symfony starter

## Presentation

Generate a fresh Symfony application with the Docker configuration ([Symfony Docker](https://github.com/dunglas/symfony-docker)).

> This project is a variant of https://github.com/jprivet-dev/symfony-starter-compose-in-another-dir.

## Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## Installation
 
- `git clone git@github.com:jprivet-dev/symfony-starter.git`
- `cd symfony-starter`
- `make generate`:
  - That clone `git@github.com:dunglas/symfony-docker.git` in `app/`.
  - Remove `.git` from `app/`.
  - Build fresh images.
  - Generate a fresh Symfony application in `app/`.
  - Fix permissions.
- Go on https://symfony-starter.localhost/.

All in one:

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git \
&& cd symfony-starter \
&& make generate
```

## Clean all and generate again

```shell
# 1. Stop the container
make stop

# 2. Remove app/ directory
make clean

# 3. Generate again
make generate
```

## Start and stop the project (Docker)

```shell
make start
make stop
make restart
```

> Run `make` to see all shorcuts for the most common tasks.

## Structure

### Before `make generate`

```
./
├── scripts/
├── aliases
├── LICENSE
├── Makefile
└── README.md
```

### After `make generate`

```
./
├── app/       <-- Fresh Symfony application with a Docker configuration 
├── scripts/
├── aliases
├── LICENSE
├── Makefile
└── README.md
```

## Save all after installation

To save the generated Symfony application:

- Remove `app/` from [.gitignore](.gitignore).
- `app/.git` is already removed on `make generate` command.
- `git add . && git commit -m "Fresh Symfony application"`

## Makefile: variables overloading

You can customize the Docker build and up processes. To do this, create an `.overload` file and override the following variables :

```dotenv
# See https://docs.docker.com/compose/how-tos/project-name/
PROJECT_NAME=my-project

# See https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#docker-build-options
COMPOSE_UP_SERVER_NAME=my.localhost
COMPOSE_UP_ENV_VARS=SYMFONY_VERSION=6.4.* HTTP_PORT=8000 HTTPS_PORT=4443 HTTP3_PORT=4443

# See https://docs.docker.com/reference/cli/docker/compose/build/#options
COMPOSE_BUILD_OPTS=--no-cache
```

These variables will be taken into account by the `make` commands.

## Troubleshooting

### Error "address already in use" or "port is already allocated"

On the `docker compose up`, you can have the followings errors:

> Error response from daemon: driver failed programming external connectivity on endpoint symfony-starter-php-1 (...): Error starting userland proxy: listen tcp4 0.0.0.0:80: bind: address already in use

> Error response from daemon: driver failed programming external connectivity on endpoint symfony-starter-php-1 (...): Bind for 0.0.0.0:443 failed: port is already allocated

#### Solution #1 - Custom HTTP ports

See https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#using-custom-http-ports.

Overload `COMPOSE_UP_ENV_VARS` in `.overload`:

```dotenv
COMPOSE_UP_ENV_VARS=HTTP_PORT=8000 HTTPS_PORT=4443 HTTP3_PORT=4443
```

#### Solution #2 - Find and stop the container using the port

List containers using the `443` port:

```shell
docker ps | grep :443
```

```
c91d77c0994e   app-php   "docker-entrypoint f…"   15 hours ago   Up 15 hours (healthy)   0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp, 0.0.0.0:443->443/udp, :::443->443/udp, 2019/tcp   other-container-php-1
```

And stop the container by `ID` or by `NAME`:

```shell
docker stop c91d77c0994e
docker stop other-container-php-1
```

It is also possible to stop all running containers at once:

```shell
make docker_stop_all
```

#### Solution #3 - Find and stop the service using the port

See the network statistics:

```shell
sudo netstat -pna | grep :80
```

```
tcp6       0      0 :::80        :::*        LISTEN        4321/apache2
```

For example, in that previous case `4321/apache2`, you can stop [Apache server](https://httpd.apache.org/):

```shell
sudo service apache2 stop
````

### Editing permissions on Linux

If you work on linux and cannot edit some of the project files right after the first installation, you can run in that project `make permissions`, to set yourself as owner of the project files that were created by the docker container.

> See https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md

## Resources

- https://symfony.com/doc/current/setup/docker.html
- https://github.com/dunglas/symfony-docker
- https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md
- https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#docker-build-options
- https://github.com/jprivet-dev/symfony-docker

## Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-starter/issues).

## License

This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter/blob/main/LICENSE).