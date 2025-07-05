# Symfony starter

## Presentation

**Generate a fully Dockerized Symfony application in less than a minute!**

This project provides a streamlined way to quickly set up a new Symfony application with Docker, leveraging the [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker) configuration.

## Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## Installation

### 1 - Clone this repository

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git
cd symfony-starter
```

### 2 - Generate a fresh Symfony application at the root

```shell
# Stable Release
make generate

# Long-Term Support Release (LTS)
make generate@lts

# Specific Version
SYMFONY_VERSION=6.4.3 make generate
```

This will:

* Clone `dunglas/symfony-docker` configuration files and extract them to your project root.
* Build the necessary Docker images and start the containers.
* Generate a fresh Symfony application inside the container.


### 3 - Access your application

  Open `https://localhost/` in your browser and [accept the auto-generated TLS certificate](https://stackoverflow.com/a/15076602/1352334).

### All in one command

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git && cd symfony-starter && make generate
```

## Generate an app in another existing project

* **1 - Copy this `Makefile` at the root** of your existing project (or a new empty directory).
* **2 - Follow the same "Installation \> Step 2 & 3"** instructions.

## Cleanup commands


### **`make clear_skeleton`**

Removes all Symfony application files (e.g., `bin/`, `config/`, `src/`, `vendor/`, `composer.json`, `.env`, etc.). This is useful if you want to **regenerate the Symfony app** from scratch, possibly with a different Symfony version.

```shell
make clear_skeleton

# Then regenerate the Symfony app:
make generate
```

### `make clear_docker`

Stops all Docker containers and **removes all Docker-related configuration files** copied from `dunglas/symfony-docker` (e.g., `Dockerfile`, `compose.yaml`, `frankenphp/`). This effectively resets your project's Docker setup. Use this if you want to start over with the Docker configuration itself.

## Daily usage

```shell
make start # Start the project and show info (up_detached & info alias)
make stop  # Stop the project (down alias)
```

> Run `make` to see all shorcuts for the most common tasks.

## Project structure

After `make generate`, your project structure will look like this:

```
./
├── bin/                 (*)
├── config/              (*)
├── docs/
├── frankenphp/          (*)
├── public/              (*)
├── src/                 (*)
├── var/                 (*)
├── vendor/              (*)
├── compose.override.yaml(*)
├── compose.prod.yaml    (*)
├── composer.json        (*)
├── composer.lock        (*)
├── compose.yaml         (*)
├── Dockerfile           (*)
├── LICENSE
├── Makefile
├── README.md
└── symfony.lock         (*)
```

**(\*)** Indicates files/directories generated or copied from `dunglas/symfony-docker` or `symfony/skeleton`.

To visualize your structure (requires `tree` command):

```shell
tree -A -L 1 -F --dirsfirst
```

## Docs

* [Save the generated Symfony application](docs/save.md)
* [Makefile: use Docker build options](docs/options.md)
* [Troubleshooting](docs%2Ftroubleshooting.md)

## Main resources

* https://symfony.com/doc/current/setup/docker.html
* https://github.com/dunglas/symfony-docker
* https://github.com/jprivet-dev/symfony-docker

## Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-starter/issues).

## License

This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter/blob/main/LICENSE).
