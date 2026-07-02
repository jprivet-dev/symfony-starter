# <REPO_TITLE>

<REPO_DESCRIPTION>

> [!TIP]
>
> * This `README_PROJECT` is a starting point **for your new Symfony project**. 
> * Replace in that file: `<REPO_TITLE>`, `<REPO_DESCRIPTION>`, `<MY_USERNAME>` and `<REPO_NAME>`.

## Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## Installation

### 1. Clone the project

```shell
git clone git@github.com:<MY_USERNAME>/<REPO_NAME>.git
cd <REPO_NAME>
```

### 2. Install the app

```shell
make install  # Start the project, install dependencies and show info
```

### 3. Go on the app

Go to https://<REPO_NAME>.localhost:8442/ and accept [the auto-generated TLS certificate](https://stackoverflow.com/a/15076602/1352334) on first visit.

> [!TIP]
>
> By default, the app runs on port `8442`. Two ways to change it:
>
> * **Fixed ports:** set `HTTP_PORT` and `HTTPS_PORT` in `.env.local` (e.g. `HTTPS_PORT=9443`).
> * **Auto ports:** set `HTTP_PORTS_AUTO=true` in `.env.local` to derive ports from the project name (avoids conflicts between projects).
>
> Run `make restart` to apply, then `make info` to see the current URLs.

## Makefile daily usage

```shell
make install  # Start the project, install dependencies and show info
make start    # Start the project and show info (detached mode)
make stop     # Stop the project (down)
make info     # Show project access info (URLs, ports)
```

> [!NOTE]
>
> Run `make` to see all available commands ([makefile.md](.starter/docs/makefile.md)).

## Documentation

* 📖 [The Project documentation](docs/README.md).
* 🚀 [The Symfony Starter documentation](.starter/docs/README.md).

## References

* Generated with [jprivet-dev/symfony-starter](https://github.com/jprivet-dev/symfony-starter).
* Built on top of [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker).

## Comments, suggestions?

Feel free to make comments/suggestions in the [Git issues section](https://github.com/<MY_USERNAME>/<REPO_NAME>/issues).

## License

This project is released under the [**MIT License**](https://github.com/<MY_USERNAME>/<REPO_NAME>/blob/main/LICENSE).
