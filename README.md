# Symfony starter

## Presentation

Generate a fresh Symfony application, with the Docker configuration ([Symfony Docker](https://github.com/dunglas/symfony-docker)).

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

### `app/`

To save the generated Symfony application:

- Remove `app/` from [.gitignore](.gitignore).
- `git add . && git commit -m "Fresh Symfony application"`

## Makefile: variables overloading

You can customize the docker build process. To do this, create an `.overload` file and override the following variables :

```dotenv
# See https://docs.docker.com/compose/how-tos/project-name/
PROJECT_NAME=my-project

# See https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#docker-build-options
COMPOSE_UP_SERVER_NAME=my.localhost
COMPOSE_UP_ENV_VARS=SYMFONY_VERSION=6.4.*

# See https://docs.docker.com/reference/cli/docker/compose/build/#options
COMPOSE_BUILD_OPTS=--no-cache
```

These variables will be taken into account by the `make` commands.

## Troubleshooting

### Error listen tcp4 0.0.0.0:80: bind: address already in use

If you have the following error:

> Error response from daemon: driver failed programming external connectivity on endpoint symfony-starter-php-1 (...): Error starting userland proxy: listen tcp4 0.0.0.0:80: bind: address already in use

See the network statistics:

```shell
sudo netstat -pna | grep :80
```

```
tcp6       0      0 :::80        :::*        LISTEN        4321/apache2
...
...
```

For example, in that previous case `.../apache2`, stop Apache server:

```shell
sudo service apache2 stop
````

Or use a [custom HTTP port](https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#using-custom-http-ports).

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