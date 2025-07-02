# Symfony starter

## Presentation

Generate a fresh Symfony application with the [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker) configuration.

## Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## Installation

### 1 - Clone the project

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git
cd symfony-starter
```

### 2 - Generate a fresh Symfony application at the root

```shell
make generate
# or
SYMFONY_VERSION=6.4.* make generate
```

> what does the `generate` command do?
> - That clone `git@github.com:dunglas/symfony-docker.git` and extract files at the root.
> - Build fresh images and start the containers.
> - Generate a fresh Symfony application at the root.

### 3 - Go on the app

Open https://localhost/ and [accept the auto-generated TLS certificate](https://stackoverflow.com/a/15076602/1352334).

### All in one

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git && cd symfony-starter && make generate
```

### Clear all symfony/skeleton files and generate a project again

```shell
make clear_skeleton

make upd
# or
SYMFONY_VERSION=6.4.* make upd
```

### Then with Makefile...

```shell
make start # Start the project and show info (upd & info alias)
make stop  # Stop the project (down alias)
```

> Run `make` to see all shorcuts for the most common tasks.

## Docs

- [Structure](docs/structure.md)
- [Save the generated Symfony application](docs/save.md)
- [Makefile: use Docker build options](docs/options.md)
- [Troubleshooting](docs%2Ftroubleshooting.md)

## Main resources

- https://symfony.com/doc/current/setup/docker.html
- https://github.com/dunglas/symfony-docker
- https://github.com/jprivet-dev/symfony-docker

## Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-starter/issues).

## License

This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter/blob/main/LICENSE).