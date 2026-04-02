# Symfony Starter

**Generate a fully Dockerized Symfony application in seconds.**

Whether you want to instantly test a **Stable or LTS** version of Symfony, API Platform or EasyAdmin, validate your **framework contributions** in a real environment, or start a **client project** with robust, documented tooling: **Symfony Starter is the solution you need**.

It leverages the power of [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker) combined with a powerful Makefile to manage the entire lifecycle.

## Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## Clone the repository

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git
cd symfony-starter
```

## Generate

### Minimalist

The bare minimum. A clean Symfony skeleton without Docker bloat or ORM pre-configured.  
*Perfect for: Microservices, Learning, Custom architecture.*

| Database          | Stable                                                              | LTS                      |
|-------------------|---------------------------------------------------------------------|--------------------------|
| **🚫 No DB**      | `make minimalist`                                                   | `make minimalist@lts`    |
| **🐘 PostgreSQL** | `make minimalist`<br>`make require_orm`                             | *Same steps with `@lts`* |
| **🐬 MariaDB**    | `make minimalist`<br>`make require_orm`<br>`make switch_to_mariadb` | *Same steps with `@lts`* |

> **Source branches:** 
> * [No DB · Stable](https://github.com/jprivet-dev/symfony-starter/tree/minimalist)
> * [No DB · LTS](https://github.com/jprivet-dev/symfony-starter/tree/minimalist@lts)
> * [PostgreSQL · Stable](https://github.com/jprivet-dev/symfony-starter/tree/minimalist-postgresql)
> * [PostgreSQL · LTS](https://github.com/jprivet-dev/symfony-starter/tree/minimalist@lts-postgresql)
> * [MariaDB · Stable](https://github.com/jprivet-dev/symfony-starter/tree/minimalist-mariadb)
> * [MariaDB · LTS](https://github.com/jprivet-dev/symfony-starter/tree/minimalist@lts-mariadb)

### Web App

The standard full-stack experience. Includes **Twig**, **AssetMapper**, **Profiler**, and a complete Docker setup.  
*Perfect for: Traditional Websites, SaaS, MVP.*

| Database          | Stable                                    | LTS                      |
|-------------------|-------------------------------------------|--------------------------|
| **🐘 PostgreSQL** | `make webapp`                             | `make webapp@lts`        |
| **🐬 MariaDB**    | `make webapp`<br>`make switch_to_mariadb` | *Same steps with `@lts`* |

> **Source branches:**
> * [PostgreSQL · Stable](https://github.com/jprivet-dev/symfony-starter/tree/webapp)
> * [PostgreSQL · LTS](https://github.com/jprivet-dev/symfony-starter/tree/webapp@lts)
> * [MariaDB · Stable](https://github.com/jprivet-dev/symfony-starter/tree/webapp-mariadb)
> * [MariaDB · LTS](https://github.com/jprivet-dev/symfony-starter/tree/webapp@lts-mariadb)

### API Platform

A headless stack optimized for **API Platform**. No front-end assets, focused on performance and REST/GraphQL.  
*Perfect for: SPA Backends (React/Vue), Mobile Apps.*

| Database          | Stable                                 | LTS                      |
|-------------------|----------------------------------------|--------------------------|
| **🐘 PostgreSQL** | `make api`                             | `make api@lts`           |
| **🐬 MariaDB**    | `make api`<br>`make switch_to_mariadb` | *Same steps with `@lts`* |

> **Source branches:**
> * [PostgreSQL · Stable](https://github.com/jprivet-dev/symfony-starter/tree/api)
> * [PostgreSQL · LTS](https://github.com/jprivet-dev/symfony-starter/tree/api@lts)
> * [MariaDB · Stable](https://github.com/jprivet-dev/symfony-starter/tree/api-mariadb)
> * [MariaDB · LTS](https://github.com/jprivet-dev/symfony-starter/tree/api@lts-mariadb)

### EasyAdmin

Based on the Web App, but pre-installed with **EasyAdmin** for an instant back-office generation.  
*Perfect for: Admin Panels, rapid CRUD apps.*

| Database          | Stable                                        | LTS                      |
|-------------------|-----------------------------------------------|--------------------------|
| **🐘 PostgreSQL** | `make easy_admin`                             | `make easy_admin@lts`    |
| **🐬 MariaDB**    | `make easy_admin`<br>`make switch_to_mariadb` | *Same steps with `@lts`* |

> **Source branches:**
> * [PostgreSQL · Stable](https://github.com/jprivet-dev/symfony-starter/tree/easy_admin)
> * [PostgreSQL · LTS](https://github.com/jprivet-dev/symfony-starter/tree/easy_admin@lts)
> * [MariaDB · Stable](https://github.com/jprivet-dev/symfony-starter/tree/easy_admin-mariadb)
> * [MariaDB · LTS](https://github.com/jprivet-dev/symfony-starter/tree/easy_admin@lts-mariadb)

### Demo

The official **Symfony Demo** application. A great reference for best practices.

| Database      | Stable      |
|---------------|-------------|
| **🪶 SQLite** | `make demo` |

> **Source branches:** 
> * [SQLite · Stable](https://github.com/jprivet-dev/symfony-starter/tree/demo)

### Contributing Symfony Core environment

Test your pull requests and framework modifications against a running application instantly without complex configuration.

#### 1. Configure

Use `../symfony` (default) or set a custom path via `SYMFONY_MONOREPO` in `.env.local`.

#### 2. Init

Easily mount your local `symfony/symfony` repository into the container:

```shell
make contrib_init
```

#### 3. Link

Symlinks your local monorepo into `vendor/`:

```shell
make contrib_link
```

#### 4. Test

Runs unit tests using the Docker runtime:

```shell
make contrib_tests a=src/Symfony/Component/HttpKernel
```

> **[📖 Read the Contribution Guide](docs/contrib.md)**

### Switching Flavors & Cleanup

You can easily switch between flavors or restart from scratch using the cleanup command. This will **delete** the current Symfony application and Docker configuration to allow a fresh generation.

```shell
# 1. Nuke the current setup (Containers, Volumes, Source code)
make kill_current_app

# 2. Generate a different flavor
make easy_admin
```

## Snapshot

If you just want to test a specific configuration immediately without waiting for the generation process, checkout the specific branch.

```shell
# Clone and checkout
git clone git@github.com:jprivet-dev/symfony-starter.git
cd symfony-starter

# Switch to the desired flavor
git checkout webapp

# Install and Start
make install
```

## Documentation

**Docker & Configuration**

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
