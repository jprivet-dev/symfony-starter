# My Generated Symfony Project

A small description of my new Symfony project.

> [!TIP]
>
> This `README` is a starting point **for your new Symfony project**. Replace in that file:
> * `My Generated Symfony Project` title.
> * `A small description of my new Symfony project`.
> * `MY_USERNAME`.
> * `my-project`.
>
> Quick start:
>
> * [Symfony Starter - Generate your project](.starter/docs/STARTER.md).
> * [Contributing - Create your reproducer](.starter/docs/contrib.md).
>
> |                                                                                   |                                                                          |
> |:----------------------------------------------------------------------------------|:-------------------------------------------------------------------------|
> | <strong>Symfony</strong><br>![minimalist.png](.starter/docs/img/minimalist.png)   | <strong>API Platform</strong><br>![api.png](.starter/docs/img/api.png)   |
> | <strong>EasyAdmin</strong><br>![easy-admin.png](.starter/docs/img/easy-admin.png) | <strong>Symfony Demo</strong><br>![demo.png](.starter/docs/img/demo.png) |

## Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## Installation

### 1. Clone the project

```shell
git clone git@github.com:MY_USERNAME/my-project.git
cd my-project
```

### 2. Install the app

```shell
make install
```

### 3. Go on the app

Go to https://symfony-starter.localhost:8442/ and accept [the auto-generated TLS certificate](https://stackoverflow.com/a/15076602/1352334) on first visit.

> [!TIP]
>
> * Override default ports in `.env.local` (e.g. `HTTP_PORT=9090 HTTPS_PORT=9443`), or set `HTTP_PORTS_AUTO=true` to derive ports from the project name (avoids conflicts between projects). 
> * Run `make info` to see the current URLs.

## Makefile daily usage

```shell
make start  # Start the project and show info (detached mode)
make stop   # Stop the project (down)
make info   # Show project access info (URLs, ports)
```

> [!TIP]
>
> Run `make` to see all available commands ([makefile.md](.starter/docs/makefile.md)).

## Documentation

* [The Project documentation](doc/README.md).
* [The Symfony Starter documentation](.starter/docs/STARTER.md).

## References

* Generated with [jprivet-dev/symfony-starter](https://github.com/jprivet-dev/symfony-starter).
* Built on top of [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker).

## Comments, suggestions?

Feel free to make comments/suggestions in the [Git issues section](https://github.com/MY_USERNAME/my-project/issues).

## License

This project is released under the [**MIT License**](https://github.com/MY_USERNAME/my-project/blob/main/LICENSE).
