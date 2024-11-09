# Symfony starter (Compose in another directory)

## Presentation

Generate a fresh Symfony application, with the Docker configuration in a parallel directory.

The aim is to be able to generate a project that **clearly separates responsibilities**, between what concerns the Symfony application and what concerns its dockerization.

> This project [use a fork](https://github.com/jprivet-dev/symfony-docker) and a modified version of [Symfony Docker](https://github.com/dunglas/symfony-docker), which can be used in another directory.

## Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## Installation
 
- `git clone git@github.com:jprivet-dev/symfony-starter-compose-in-another-dir.git`
- `cd symfony-starter-compose-in-another-dir`
- `make generate`:
  - That clone `git@github.com:jprivet-dev/symfony-docker` in `docker/`.
  - Build fresh images.
  - Generate a fresh Symfony application in `app/`.
  - Fix permissions.
- Go on https://symfony-starter-compose-in-another-dir.localhost/.

## Clean all and generate again

```shell
# 1. Stop the container
make stop

# 2. Remove app/ and docker/ directories
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
├── app/       <-- Fresh Symfony application
├── docker/    <-- Fresh Docker configuration (in a parallel directory to app/)
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

### `docker/`

To save the Docker configuration:

- Remove `docker/` from [.gitignore](.gitignore).
- `rm -rf docker/.git`
- `git add . && git commit -m "Fresh Docker configuration"`

## Makefile: variables override

You can choose an another branch of my forked Symfony Docker repository, or customize the docker build process. To do this, create an `.env` file and override the following variables :

```dotenv
# .env
BRANCH=next
DOCKER_BUILD_OPTS=SYMFONY_VERSION=6.4.*
SERVER_NAME=custom-server-name.localhost
```

These variables will be taken into account by the `make` commands.

> See https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#docker-build-options

## Shortcomings of this approach

Putting Docker in another folder, outside the application, prevents the use of [Flex Recipes & Docker Configuration](https://symfony.com/doc/current/setup/docker.html#flex-recipes-docker-configuration).

⏱️ Search for a solution underway...

## Troubleshooting

### Error listen tcp4 0.0.0.0:80: bind: address already in use

If you have the following error:

> Error response from daemon: driver failed programming external connectivity on endpoint symfony-starter-compose-in-another-dir-php-1 (...): Error starting userland proxy: listen tcp4 0.0.0.0:80: bind: address already in use

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
- https://medium.com/@unhandlederror/how-to-run-docker-compose-from-another-directory-e94e081a80cc

## Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-starter-compose-in-another-dir/issues).

## License

This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter-compose-in-another-dir/blob/main/LICENSE).