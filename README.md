# Symfony starter

## Presentation

**Generate a fully Dockerized Symfony application in less than a minute!**

This project provides a streamlined way to quickly set up a new Symfony application with Docker, leveraging the [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker) configuration.

## Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## Installation

### 1. Clone this repository

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git
cd symfony-starter
```

### 2. Generate a fresh Symfony application at the root

```shell
# Minimalist Stable Release
make generate

# Minimalist Long-Term Support Release (LTS)
make generate@lts

# Webapp Stable Release
make generate@webapp

# Webapp Long-Term Support Release (LTS)
make generate@webapp_lts

# Specific Minimalist Version
SYMFONY_VERSION=6.4.3 make generate

# Specific Webapp Version
SYMFONY_VERSION=6.4.3 make generate@webapp
```

This will:

* Clone `dunglas/symfony-docker` configuration files and extract them to your project root.
* Build the necessary Docker images and start the containers.
* Generate a fresh Symfony application inside the container.
* Eventually add extra packages to give you everything you need to build a web application.

### 3. Access your application

Open `https://symfony-starter.localhost:8443/` in your browser and [accept the auto-generated TLS certificate](https://stackoverflow.com/a/15076602/1352334).

### All in one command

```shell
# Minimalist Stable Release
git clone git@github.com:jprivet-dev/symfony-starter.git && cd symfony-starter && make generate
```

## Generate an app in another existing project

* **Copy this `Makefile` at the root** of your existing project (or a new empty directory).
* **Follow the same "Installation \> Step 2 & 3"** instructions.

> The Docker PHP image name and URL are dynamic and use your project's directory name:
> * **Final Docker PHP image:** `my-project-app-php`
> * **Final locahost URL:** https://my-project.localhost:8443
> 
> You can change this name with `PROJECT_NAME` variable. See [Docker build options](docs/options.md).

## Cleanup command

Stops all Docker containers, removes all Docker-related configuration files copied from `dunglas/symfony-docker` (e.g., `Dockerfile`, `compose.yaml`, `frankenphp/`), and removes all Symfony application files (e.g., `bin/`, `config/`, `src/`, `vendor/`, `composer.json`, `.env`, etc.) :

```shell
make clear_all

# Then regenerate the Symfony app (lts version for example):
make generate@lts
```

## Daily usage

```shell
make start # Start the project and show info (up_detached & info alias)
make stop  # Stop the project (down alias)
```

> Run `make` to see all shorcuts for the most common tasks.

## Project structure

After `make generate`, your project structure will look like this (Minimalist Stable Release):

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

* [Save your generated Symfony application](docs/save.md)
* [Validate certificates](docs/certificates.md)
* [Docker build options](docs/options.md)
* [Accessing the `var/` directory](docs/var.md)
* [Troubleshooting](docs%2Ftroubleshooting.md)

## Main resources

* https://symfony.com/doc/current/setup/docker.html
* https://github.com/dunglas/symfony-docker
* https://github.com/jprivet-dev/symfony-docker

## Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-starter/issues).

## License

This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter/blob/main/LICENSE).
