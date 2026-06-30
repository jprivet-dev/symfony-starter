# Symfony Starter

Generate a fully Dockerized Symfony application with a single command 🥳

## Installation

### 1. Clone the project

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git
cd symfony-starter
```

### 2. Generate your app

* [Your project](.starter/docs/README.md).
* [Your reproducer](.starter/docs/contrib.md).

|                                                                                   |                                                                          |
 |:----------------------------------------------------------------------------------|:-------------------------------------------------------------------------|
| <strong>Symfony</strong><br>![minimalist.png](.starter/docs/img/minimalist.png)   | <strong>API Platform</strong><br>![api.png](.starter/docs/img/api.png)   |
| <strong>EasyAdmin</strong><br>![easy-admin.png](.starter/docs/img/easy-admin.png) | <strong>Symfony Demo</strong><br>![demo.png](.starter/docs/img/demo.png) |

### 3. Go on the app

Go to https://symfony-starter.localhost:8442/ and accept [the auto-generated TLS certificate](https://stackoverflow.com/a/15076602/1352334) on first visit.

> [!TIP]
>
> * Override default ports in `.env.local`:
>   * e.g. `HTTP_PORT=9090 HTTPS_PORT=9443`.
>   * or set `HTTP_PORTS_AUTO=true` to derive ports from the project name (avoids conflicts between projects).
> * Run `make info` to see the current URLs.

### 4. Update your README

Replace this `README.md` with [README.template.md](README.template.md) and fill in your project details.

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

🚀 [The Symfony Starter documentation](.starter/docs/README.md).

## Comments, suggestions?

Feel free to make comments/suggestions in the [Git issues section](https://github.com/jprivet-dev/symfony-starter/issues).

## License

This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter/blob/main/LICENSE).
