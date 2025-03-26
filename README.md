# Symfony starter

## Presentation

Generate a fresh Symfony application with the Docker configuration ([Symfony Docker](https://github.com/dunglas/symfony-docker)).

> This project is a variant of https://github.com/jprivet-dev/symfony-starter-compose-in-another-dir.

## Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## Installation

### The very first time
 
- `git clone git@github.com:jprivet-dev/symfony-starter.git`
- `cd symfony-starter`
- `make generate`:
  - That clone `git@github.com:dunglas/symfony-docker.git` and extract files at the root.
  - Build fresh images.
  - Start the containers.
  - Generate a fresh Symfony application at the root.
  - Fix permissions for Linux (add `PERMISSIONS=on` to `.env.options.local` to activate `permissions` command).
  - Show info.
- Go on https://symfony-starter.localhost/.

All in one:

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git && cd symfony-starter && make generate
```

### The following times

```shell
make start    # Start the project
make stop     # Stop the project
make restart  # Stop and start the project
make install  # Install all (for example, after an update of your curent branch)
```

> Run `make` to see all shorcuts for the most common tasks.

### Clean all and generate again

```shell
make stop     # 1. Stop the container
make clean    # 2. Remove all generated files
make generate # 3. Generate again
```

## Structure

Before `make generate`:

```
./
├── LICENSE
├── Makefile
└── README.md
```

After `make generate`:

```
./
├──*bin/
├──*config/
├──*docs/
├──*frankenphp/
├──*public/
├──*src/
├──*var/
├──*vendor/
├──*compose.override.yaml
├──*compose.prod.yaml
├──*composer.json
├──*composer.lock
├──*compose.yaml
├──*Dockerfile
├── LICENSE
├── Makefile
├── README.md
└──*symfony.lock 
```

(*) Fresh Symfony application with a Docker configuration

## Save the generated Symfony application

1. Remove the following block from [frankenphp/docker-entrypoint.sh](app/frankenphp/docker-entrypoint.sh) :
```shell
	# Install the project the first time PHP is started
	# After the installation, the following block can be deleted
	if [ ! -f composer.json ]; then
		rm -Rf tmp/
		composer create-project "symfony/skeleton $SYMFONY_VERSION" tmp --stability="$STABILITY" --prefer-dist --no-progress --no-interaction --no-install
		# ...
	fi
```
2. `git add . && git commit -m "Fresh Symfony application"`

## Makefile: Docker build and up options

You can customize the Docker build and up processes. To do this, add the following variables in your `.env.options.local` file:

```dotenv
# .env.options.local

# Editing Permissions on Linux
# See https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md
PERMISSIONS=on

# See https://docs.docker.com/compose/how-tos/project-name/
PROJECT_NAME=my-project

# See https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#docker-build-options
SERVER_NAME=my.localhost
XDEBUG_MODE=coverage
HTTP_PORT=8000
HTTPS_PORT=4443
HTTP3_PORT=4443
```

These variables will be taken into account by the `make` commands.

> As the variables are common to the `Makefile` and `docker compose`, I'm not attaching an environment file with the `--env-file` option at the moment. See https://docs.docker.com/compose/how-tos/environment-variables/.

## Troubleshooting

### Error "address already in use" or "port is already allocated"

On the `docker compose up`, you can have the followings errors:

> Error response from daemon: driver failed programming external connectivity on endpoint symfony-starter-php-1 (...): Error starting userland proxy: listen tcp4 0.0.0.0:80: bind: address already in use

> Error response from daemon: driver failed programming external connectivity on endpoint symfony-starter-php-1 (...): Bind for 0.0.0.0:443 failed: port is already allocated

#### Solution #1 - Custom HTTP ports

See https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#using-custom-http-ports.

Overload `HTTP_PORT` in `.env.options.local`:

```dotenv
HTTP_PORT=8000
HTTPS_PORT=4443
HTTP3_PORT=4443
```

#### Solution #2 - Find and stop the container using the port

List containers using the `443` port:

```shell
docker ps | grep :443
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