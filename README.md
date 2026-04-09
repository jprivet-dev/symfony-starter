# Symfony Starter

**Generate a fully Dockerized Symfony application quickly.**

Whether you want to instantly test a [Symfony](https://symfony.com/), [API Platform](https://api-platform.com/), [EasyAdmin](https://github.com/EasyCorp/EasyAdminBundle) or [Symfony Demo](https://github.com/symfony/demo) application, validate your **Symfony contributions** in a real environment, or start a **client project** with robust and documented tooling: **[Symfony Starter](https://github.com/jprivet-dev/symfony-starter) is the solution you need**.

It leverages the power of [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker) combined with a powerful Makefile to manage the entire lifecycle.

|                                                                                                                         |                                                                                                    |
|:------------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------|
| <strong>[Symfony](https://symfony.com/)</strong><br>![minimalist.png](docs/img/minimalist.png)                          | <strong>[API Platform](https://api-platform.com/)</strong><br>![api.png](docs/img/api.png)         |
| <strong>[EasyAdmin](https://github.com/EasyCorp/EasyAdminBundle)</strong><br>![easy-admin.png](docs/img/easy-admin.png) | <strong>[Symfony Demo](https://github.com/symfony/demo)</strong><br>![demo.png](docs/img/demo.png) |

## Quick start

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git
cd symfony-starter
```

## Generate a minimalist application

The bare minimum. A clean Symfony skeleton without Docker bloat or ORM pre-configured.  
*Perfect for: Microservices, Learning, Custom architecture.*

| Database          | Stable                                                              | LTS                                                                     |
|-------------------|---------------------------------------------------------------------|-------------------------------------------------------------------------|
| **🚫 No DB**      | `make minimalist`                                                   | `make minimalist@lts`                                                   |
| **🐘 PostgreSQL** | `make minimalist`<br>`make require_orm`                             | `make minimalist@lts`<br>`make require_orm`                             |
| **🐬 MariaDB**    | `make minimalist`<br>`make require_orm`<br>`make switch_to_mariadb` | `make minimalist@lts`<br>`make require_orm`<br>`make switch_to_mariadb` |
| **🪶 SQLite**     | `make minimalist`<br>`make require_orm`<br>`make switch_to_sqlite`  | `make minimalist@lts`<br>`make require_orm`<br>`make switch_to_sqlite`  |

## Generate a webapp

The standard full-stack experience. Includes **Twig**, **AssetMapper**, **Profiler**, and a complete Docker setup.  
*Perfect for: Traditional Websites, SaaS, MVP.*

| Database          | Stable                | LTS                       |
|-------------------|-----------------------|---------------------------|
| **🐘 PostgreSQL** | `make webapp`         | `make webapp@lts`         |
| **🐬 MariaDB**    | `make webapp@mariadb` | `make webapp@mariadb_lts` |
| **🪶 SQLite**     | `make webapp@sqlite`  | `make webapp@sqlite_lts`  |

## Generate an API Platform project

A headless stack optimized for **API Platform**. No front-end assets, focused on performance and REST/GraphQL.  
*Perfect for: SPA Backends (React/Vue), Mobile Apps.*

| Database          | Stable                                 | LTS                                        |
|-------------------|----------------------------------------|--------------------------------------------|
| **🐘 PostgreSQL** | `make api`                             | `make api@lts`                             |
| **🐬 MariaDB**    | `make api`<br>`make switch_to_mariadb` | `make api@lts`<br>`make switch_to_mariadb` |
| **🪶 SQLite**     | `make api`<br>`make switch_to_sqlite`  | `make api@lts`<br>`make switch_to_sqlite`  |

## Generate an EasyAdmin project

Based on the Web App, but pre-installed with **EasyAdmin** for an instant back-office generation.  
*Perfect for: Admin Panels, rapid CRUD apps.*

| Database          | Stable                                        | LTS                                               |
|-------------------|-----------------------------------------------|---------------------------------------------------|
| **🐘 PostgreSQL** | `make easy_admin`                             | `make easy_admin@lts`                             |
| **🐬 MariaDB**    | `make easy_admin`<br>`make switch_to_mariadb` | `make easy_admin@lts`<br>`make switch_to_mariadb` |
| **🪶 SQLite**     | `make easy_admin`<br>`make switch_to_sqlite`  | `make easy_admin@lts`<br>`make switch_to_sqlite`  |

## Generate a Symfony Demo project

The official **Symfony Demo** application. A great reference for best practices.

| Database      | Stable      |
|---------------|-------------|
| **🪶 SQLite** | `make demo` |

## Generate from scratch

You can switch between flavors or restart from scratch. This will **delete** the current Symfony application and Docker configuration.

```shell
# 1. Nuke the current setup (Containers, Volumes, Source code)
make clean_app

# 2. Generate a different flavor
make easy_admin
```

## Use a source branch directly

If you just want to try a specific configuration without generating it, checkout a source branch directly and start it immediately.

```shell
# 1. Switch to the desired branch
git checkout webapp

# 2. Nuke (only if necessary) the current setup (Containers, Volumes, Source code)
make clean_app

# 3. Install and start
make install
```

**Available branches :**

* Minimalist:
  * [minimalist](https://github.com/jprivet-dev/symfony-starter/tree/minimalist)
  * [minimalist-lts](https://github.com/jprivet-dev/symfony-starter/tree/minimalist-lts)
* Webapp:
  * [webapp](https://github.com/jprivet-dev/symfony-starter/tree/webapp)
  * [webapp-lts](https://github.com/jprivet-dev/symfony-starter/tree/webapp-lts)
  * [webapp-mariadb](https://github.com/jprivet-dev/symfony-starter/tree/webapp-mariadb)
  * [webapp-mariadb-lts](https://github.com/jprivet-dev/symfony-starter/tree/webapp-mariadb-lts)
  * [webapp-sqlite](https://github.com/jprivet-dev/symfony-starter/tree/webapp-sqlite)
  * [webapp-sqlite-lts](https://github.com/jprivet-dev/symfony-starter/tree/webapp-sqlite-lts)
* API Platform:
  * [api](https://github.com/jprivet-dev/symfony-starter/tree/api)
  * [api-lts](https://github.com/jprivet-dev/symfony-starter/tree/api-lts)
* EasyAdmin:
  * [easy-admin](https://github.com/jprivet-dev/symfony-starter/tree/easy-admin)
  * [easy-admin-lts](https://github.com/jprivet-dev/symfony-starter/tree/easy-admin-lts)
* Symfony Demo:
  * [demo](https://github.com/jprivet-dev/symfony-starter/tree/demo)

## Contribute to Symfony Core

Test your pull requests and framework modifications against a running application instantly without complex configuration.

### 1. Configure

Use `../symfony` (default) or set a custom path via `SYMFONY_MONOREPO` in `.env.local`.

### 2. Init

Easily mount your local `symfony/symfony` repository into the container:

```shell
make contrib_init
```

### 3. Link

Symlinks your local monorepo into `vendor/`:

```shell
make contrib_link
```

### 4. Test

Runs unit tests using the Docker runtime:

```shell
make contrib_tests a=src/Symfony/Component/HttpKernel
```

> **[📖 Read the contribution guide](docs/contrib.md)**

## Documentation

**Docker & configuration**

* [Caddy - Validate certificates](docs/certificates.md)
* [Compose - Accessing the `var/` directory](docs/var.md)
* [Makefile - Discover all commands](docs/makefile.md)
* [Symfony - Save your generated application](docs/save.md)
* [Symfony and Docker - Use build options](docs/options.md)

**Database**

* [PhpStorm - Connect it to PostgreSQL](docs/postgre.md)
* Switching to MySQL/MariaDB (Available via Makefile)
* Switching to SQLite (Available via Makefile)

**IDE & Quality (DX)**

* [PHP - Quality Tools (PHPStan, CS Fixer, etc.)](docs/quality.md)
* [PHP - Testing (PHPUnit)](docs/testing.md)
* [PhpStorm - Configure Remote PHP Interpreter](docs/remote-php-interpreter.md)

**Advanced**

* [ADR (Architecture Decision Records)](docs/adr.md)
* [Shell Aliases: Seamless Docker Experience](docs/aliases.md)
* [Troubleshooting](docs/troubleshooting.md)

**Contributing**

* [Contributing to Symfony: Connect Your Local Symfony Repository](docs/contrib.md)

## Main links

* https://symfony.com/doc/current/setup/docker.html
* https://github.com/dunglas/symfony-docker
* https://github.com/jprivet-dev/symfony-docker

## Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-starter/issues).

## Credits & License

* Based on [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker).
* This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter/blob/main/LICENSE).
