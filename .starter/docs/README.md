# 🚀 Symfony Starter documentation

[⬅️ README](../../README.md)

---

![PHP](https://img.shields.io/badge/PHP-8.5-777BB4?logo=php)
![Symfony](https://img.shields.io/badge/Symfony-8%20%7C%207%20LTS-000000?logo=symfony)
![dunglas/symfony-docker](https://img.shields.io/badge/dunglas%2Fsymfony--docker-3c0d1772-2088FF?logo=docker)

## Generate your Symfony project

Generate a fully Dockerized Symfony application with a single command 🥳

From a minimal [Symfony](https://symfony.com/) skeleton to a full [API Platform](https://api-platform.com/) or [EasyAdmin](https://github.com/EasyCorp/EasyAdminBundle) stack, [Symfony Starter](https://github.com/jprivet-dev/symfony-starter) handles the entire setup — Docker, database, dependencies — so you can focus on your code from the first minute. You can also use the official [Symfony Demo](https://github.com/symfony/demo) as a reference for best practices, or [contribute to Symfony Core](contrib/contrib.md) in a real Docker environment.

Built on top of [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker) and driven by a powerful Makefile, it covers everything from project initialization to daily development.

```mermaid
flowchart LR
  START([Start]) --> FCHOICE
  FCHOICE["Which flavor?<br/>─────<br/>🌱 Minimalist<br/>🌍 Webapp<br/>🔌 API Platform<br/>⚡ EasyAdmin<br/>🎓 Symfony Demo<br/>🧪 Reproducer"] --> VERSION
  VERSION["Which version?<br/>─────<br/>Stable<br/>LTS<br/>6x"] --> DBCHOICE
  DBCHOICE["Which database?<br/>─────<br/>🚫 No DB<br/>🐘 PostgreSQL<br/>🐬 MariaDB<br/>🪶 SQLite"] --> FRONTEND
  FRONTEND["Which frontend stack?<br/>─────<br/>🚫 None<br/>🎨‍AssetMapper<br/>🧰 Encore"] --> DONE
  DONE([Ready!])
```

## Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## Installation

### 1. Clone the project

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git
cd symfony-starter
```

### 2. Generate your Symfony project

| Application     | Stable            | LTS                   | Database by default |
|-----------------|-------------------|-----------------------|---------------------|
| 🌱 Minimalist   | `make minimalist` | `make minimalist@lts` | 🚫 No DB            |
| 🌍 Webapp       | `make webapp`     | `make webapp@lts`     | 🐘 PostgreSQL       |
| 🔌 API Platform | `make api`        | `make api@lts`        | 🐘 PostgreSQL       |
| ⚡ EasyAdmin     | `make easy_admin` | `make easy_admin@lts` | 🐘 PostgreSQL       |
| 🎓 Symfony Demo | `make demo`       | —                     | 🪶 SQLite           |
| 🧪 Reproducer   | `make reproducer` | `make reproducer@lts` | 🚫 No DB            |

> [!NOTE]
>
> Each generation takes approximately ⏱️ 3-4 minutes depending on your machine and network speed.

> 🧪 Reproducer
>
> See full [Generate your reproducer and contribute to Symfony](contrib/contrib.md) documentation.

### 3. Go on the app

Go to https://symfony-starter.localhost:8442/ and accept [the auto-generated TLS certificate](https://stackoverflow.com/a/15076602/1352334) on first visit.

> [!TIP]
>
> By default, the app runs on port `8442`. Two ways to change it:
>
> * **Fixed ports:** set `HTTP_PORT` and `HTTPS_PORT` in `.env.local` (e.g. `HTTPS_PORT=9443`).
> * **Auto ports:** set `HTTP_PORTS_AUTO=true` in `.env.local` to derive ports from the project name (avoids conflicts between projects).
>
> Run `make restart` to apply, then `make info` to see the current URLs.

### 4. You can update your README

Replace your `README.md` with one of these templates and fill in your details:

* [README_PROJECT.md](.starter/templates/README_PROJECT.md) — for a new Symfony project.
* [README_REPRODUCER.md](.starter/templates/README_REPRODUCER.md) — for a contribution reproducer.

## Switch to another DB

> [!NOTE]
>
> By default, **🐘 PostgreSQL** is used. Run one of the following commands after generation to switch to another database.

| Application     | 🐬 MariaDB                                     | 🪶 SQLite                                     |
|-----------------|------------------------------------------------|-----------------------------------------------|
| 🌱 Minimalist   | `make require_orm`<br>`make switch_to_mariadb` | `make require_orm`<br>`make switch_to_sqlite` |
| 🌍 Webapp       | `make switch_to_mariadb`                       | `make switch_to_sqlite`                       |
| 🔌 API Platform | `make switch_to_mariadb`                       | `make switch_to_sqlite`                       |
| ⚡ EasyAdmin     | `make switch_to_mariadb`                       | `make switch_to_sqlite`                       |
| 🎓 Symfony Demo | `make switch_to_mariadb`                       | —                                             |

## Switch to a frontend stack

> [!NOTE]
>
> By default, no frontend stack is installed. Run one of the following commands after generation to add one.

| Stack             | Command                        |
|-------------------|--------------------------------|
| 🗺️ AssetMapper   | `make frontend_asset_mapper`   |
| ⚙️ Webpack Encore | `make frontend_webpack_encore` |

## Generate from scratch

You can switch between flavors or restart from scratch. This will **delete** the current Symfony application and Docker configuration.

```shell
make clean_app  # 1. Nuke the current setup
make easy_admin # 2. Generate a different flavor
```

## Use a source branch directly

If you just want to try the starter without generating it, use one of the pre-built branches:

| Application   | Stable                                                                       | LTS                                                                                  | Database      |
|---------------|------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|---------------|
| 🌱 Minimalist | [minimalist](https://github.com/jprivet-dev/symfony-starter/tree/minimalist) | [minimalist@lts](https://github.com/jprivet-dev/symfony-starter/tree/minimalist@lts) | 🚫 No DB      |
| 🌍 Webapp     | [webapp](https://github.com/jprivet-dev/symfony-starter/tree/webapp)         | [webapp@lts](https://github.com/jprivet-dev/symfony-starter/tree/webapp@lts)         | 🐘 PostgreSQL |

```shell
git fetch origin            # 1. Fetch all branches
git checkout minimalist     # 2. Switch to the desired branch (e.g. minimalist, webapp, webapp@lts)
make clean_app              # 3. Nuke (only if necessary) the current setup
make install                # 4. Install and start
```

> [!TIP]
>
> From there, use `make require_orm`, `make require_api`, `make switch_to_mariadb`, etc. to add more features.

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

### Main

* [Caddy - Validate certificates](certificates.md)
* [Compose - Accessing the `var/` directory](var.md)
* [Makefile - Discover all commands](makefile.md)
* [Symfony - Save your generated application](save.md)
* [Symfony and Docker - Use build options](options.md)
* [Shell Aliases: Seamless Docker Experience](aliases.md)

### Starting with ...

* [Asset Mapper & Bootstrap](starting/asset-mapper-bootstrap.md)
* [Asset Mapper & Tailwind](starting/asset-mapper-tailwind.md)
* [Webpack Encore, Bootstrap & React](starting/webpack-encore-bootstrap-react.md)
* [Webpack Encore, Tailwind & React](starting/webpack-encore-tailwind-react.md)

### IDE configuration

* [PhpStorm - Configure a remote PHP interpreter (Docker)](ide/phpstorm-remote-php-interpreter.md)
* [PhpStorm - Configure inspections](ide/phpstorm-inspections.md)
* [PhpStorm - Connect it to the running PostgreSQL container](ide/phpstorm-postgre.md)
* [PhpStorm - Connect it to the running MariaDB container](ide/phpstorm-mariadb.md)
* [PhpStorm - Connect it to the SQLite database](ide/phpstorm-sqlite.md)

### Quality

* [PHP_CodeSniffer](quality/phpcodesniffer.md)
* [PHP CS Fixer](quality/phpcsfixer.md)
* [PHP Mess Detector](quality/phpmessdetector.md)
* [PhpMetrics](quality/phpmetrics.md)
* [PHPStan](quality/phpstan.md)
* [Twig CS Fixer](quality/twigcsfixer.md)

### Testing

* [Testing overview](testing/testing-overview.md)
* PHPUnit *(TODO)*
* Behat *(TODO)*

### ADR (Architecture Decision Records)

* [What is an ADR?](adr/what-is-an-adr.md)
* [Database: port mapping strategy](adr/database-port-mapping.md)
* [Makefile: target naming convention](adr/makefile-naming.md)

### Troubleshooting

* [Linux - Editing permissions](troubleshooting/editing-permissions-on-linux.md)
* [Docker - "address already in use" or "port is already allocated"](troubleshooting/address-already-in-use.md)
* [Docker - "container is unhealthy" after `docker compose up`](troubleshooting/unhealthy.md)
* [Docker and Git - "detected dubious ownership in repository"](troubleshooting/dubious-ownership.md)
* [React - "jsxDEV is not a function" in production build](troubleshooting/react-jsxdev-production-build.md)

### Contributing

* [Generate your reproducer and contribute to Symfony](contrib/contrib.md)

---

[⬅️ README](../../README.md)
