# Symfony Starter

![PHP](https://img.shields.io/badge/PHP-8.5-777BB4?logo=php)
![Symfony](https://img.shields.io/badge/Symfony-8%20%7C%207%20LTS-000000?logo=symfony)
![dunglas/symfony-docker](https://img.shields.io/badge/dunglas%2Fsymfony--docker-de8af3bd-2088FF?logo=docker)

**Generate a fully Dockerized Symfony application with a single command.**

From a minimal [Symfony](https://symfony.com/) skeleton to a full [API Platform](https://api-platform.com/) or [EasyAdmin](https://github.com/EasyCorp/EasyAdminBundle) stack, [Symfony Starter](https://github.com/jprivet-dev/symfony-starter) handles the entire setup — Docker, database, dependencies — so you can focus on your code from the first minute. You can also use the official [Symfony Demo](https://github.com/symfony/demo) as a reference for best practices.

Built on top of [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker) and driven by a powerful Makefile, it covers everything from project initialization to daily development.

|                                                                                                                         |                                                                                                    |
|:------------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------|
| <strong>[Symfony](https://symfony.com/)</strong><br>![minimalist.png](docs/img/minimalist.png)                          | <strong>[API Platform](https://api-platform.com/)</strong><br>![api.png](docs/img/api.png)         |
| <strong>[EasyAdmin](https://github.com/EasyCorp/EasyAdminBundle)</strong><br>![easy-admin.png](docs/img/easy-admin.png) | <strong>[Symfony Demo](https://github.com/symfony/demo)</strong><br>![demo.png](docs/img/demo.png) |

## Quick start

> Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

Clone the project:

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git
cd symfony-starter
```

And generate:

| Application     | Stable            | LTS                   | Database      |
|-----------------|-------------------|-----------------------|---------------|
| 🌱 Minimalist   | `make minimalist` | `make minimalist@lts` | 🚫 No DB      |
| 🌍 Webapp       | `make webapp`     | `make webapp@lts`     | 🐘 PostgreSQL |
| 🔌 API Platform | `make api`        | `make api@lts`        | 🐘 PostgreSQL |
| ⚡ EasyAdmin     | `make easy_admin` | `make easy_admin@lts` | 🐘 PostgreSQL |
| 🎓 Demo         | `make demo`       | —                     | 🪶 SQLite     |

## Switch to another DB

> By default, PostgreSQL is used. Run one of the following commands after generation to switch to another database.

| Application     | 🐬 MariaDB                                     | 🪶 SQLite                                     |
|-----------------|------------------------------------------------|-----------------------------------------------|
| 🌱 Minimalist   | `make require_orm`<br>`make switch_to_mariadb` | `make require_orm`<br>`make switch_to_sqlite` |
| 🌍 Webapp       | `make switch_to_mariadb`                       | `make switch_to_sqlite`                       |
| 🔌 API Platform | `make switch_to_mariadb`                       | `make switch_to_sqlite`                       |
| ⚡ EasyAdmin     | `make switch_to_mariadb`                       | `make switch_to_sqlite`                       |
| 🎓 Demo         | —                                              | —                                             |

## Generate from scratch

You can switch between flavors or restart from scratch. This will **delete** the current Symfony application and Docker configuration.

```shell
make clean_app  # 1. Nuke the current setup
make easy_admin # 2. Generate a different flavor
```

## Use a source branch directly

If you just want to try a specific configuration without generating it, checkout a source branch directly and start it immediately.

```shell
git fetch origin    # 1. Fetch all branches
git checkout webapp # 2. Switch to the desired branch
make clean_app      # 3. Nuke (only if necessary) the current setup
make install        # 4. Install and start
```

**Available branches:**

| Application     | Stable                                                                               | LTS                                                                                          | Database      |
|-----------------|--------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|---------------|
| 🌱 Minimalist   | [minimalist](https://github.com/jprivet-dev/symfony-starter/tree/minimalist)         | [minimalist_lts](https://github.com/jprivet-dev/symfony-starter/tree/minimalist_lts)         | 🚫 No DB      |
| 🌍 Webapp       | [webapp](https://github.com/jprivet-dev/symfony-starter/tree/webapp)                 | [webapp_lts](https://github.com/jprivet-dev/symfony-starter/tree/webapp_lts)                 | 🐘 PostgreSQL |
|                 | [webapp_mariadb](https://github.com/jprivet-dev/symfony-starter/tree/webapp_mariadb) | [webapp_mariadb_lts](https://github.com/jprivet-dev/symfony-starter/tree/webapp_mariadb_lts) | 🐬 MariaDB    |
|                 | [webapp_sqlite](https://github.com/jprivet-dev/symfony-starter/tree/webapp_sqlite)   | [webapp_sqlite_lts](https://github.com/jprivet-dev/symfony-starter/tree/webapp_sqlite_lts)   | 🪶 SQLite     |
| 🔌 API Platform | [api](https://github.com/jprivet-dev/symfony-starter/tree/api)                       | [api_lts](https://github.com/jprivet-dev/symfony-starter/tree/api_lts)                       | 🐘 PostgreSQL |
| ⚡ EasyAdmin     | [easy_admin](https://github.com/jprivet-dev/symfony-starter/tree/easy_admin)         | [easy_admin_lts](https://github.com/jprivet-dev/symfony-starter/tree/easy_admin_lts)         | 🐘 PostgreSQL |
| 🎓 Demo         | [demo](https://github.com/jprivet-dev/symfony-starter/tree/demo)                     | —                                                                                            | 🪶 SQLite     |

## Contribute to Symfony Core

Test your pull requests and framework modifications against a running application instantly without complex configuration.

* Use `../symfony` (default) or set a custom path via `SYMFONY_MONOREPO` in `.env.local`.
* Easily mount your local `symfony/symfony` repository into the container: `make contrib_init`
* Symlinks your local monorepo into `vendor/`: `make contrib_link`
* Runs unit tests using the Docker runtime: `make contrib_tests a=src/Symfony/Component/HttpKernel`

> **[📖 Read the contribution guide](docs/contrib.md)**

## Documentation

* Main
  * [Caddy - Validate certificates](docs/certificates.md)
  * [Compose - Accessing the `var/` directory](docs/var.md)
  * [Makefile - Discover all commands](docs/makefile.md)
  * [Symfony - Save your generated application](docs/save.md)
  * [Symfony and Docker - Use build options](docs/options.md)
  * [Shell Aliases: Seamless Docker Experience](docs/aliases.md)
* IDE configuration
  * [PhpStorm - Configure a remote PHP interpreter (Docker)](docs/ide/phpstorm-remote-php-interpreter.md)
  * [PhpStorm - Configure inspections](docs/ide/phpstorm-inspections.md)
  * [PhpStorm - Connect it to the running PostgreSQL container](docs/ide/phpstorm-postgre.md)
  * [PhpStorm - Connect it to the running MariaDB container](docs/ide/phpstorm-mariadb.md)
  * [PhpStorm - Connect it to the SQLite database](docs/ide/phpstorm-sqlite.md)
* Quality
  * [PHP_CodeSniffer](docs/quality/phpcodesniffer.md)
  * [PHP CS Fixer](docs/quality/phpcsfixer.md)
  * [PHP Mess Detector](docs/quality/phpmessdetector.md)
  * [PhpMetrics](docs/quality/phpmetrics.md)
  * [PHPStan](docs/quality/phpstan.md)
  * [Twig CS Fixer](docs/quality/twigcsfixer.md)
* Testing
  * [Testing overview](docs/testing/testing-overview.md)
  * PHPUnit *(TODO)*
  * Behat *(TODO)*
* ADR (Architecture Decision Records)
  * [What is an ADR?](docs/adr/what-is-an-adr.md)
  * [Database: port mapping strategy](docs/adr/database-port-mapping.md)
  * [Makefile: target naming convention](docs/adr/makefile-naming.md)
* Troubleshooting
  * [Linux - Editing permissions](docs/troubleshooting/editing-permissions-on-linux.md)
  * [Docker - "address already in use" or "port is already allocated"](docs/troubleshooting/address-already-in-use.md)
  * [Docker - "container is unhealthy" after `docker compose up`](docs/troubleshooting/unhealthy.md)
  * [Docker and Git - "detected dubious ownership in repository"](docs/troubleshooting/dubious-ownership.md)
* Contributing
  * [Contributing to Symfony: Connect your local Symfony repository](docs/contrib.md)

## Main links

* https://symfony.com/doc/current/setup/docker.html
* https://github.com/dunglas/symfony-docker
* https://github.com/jprivet-dev/symfony-docker

## Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-starter/issues).

## Credits & License

* Based on [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker).
* This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter/blob/main/LICENSE).
