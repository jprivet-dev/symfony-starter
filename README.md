# Symfony Starter

![PHP](https://img.shields.io/badge/PHP-8.5-777BB4?logo=php)
![Symfony](https://img.shields.io/badge/Symfony-8%20%7C%207%20LTS-000000?logo=symfony)
![dunglas/symfony-docker](https://img.shields.io/badge/dunglas%2Fsymfony--docker-777be58d-2088FF?logo=docker)

**Generate a fully Dockerized Symfony application with a single command.**

From a minimal [Symfony](https://symfony.com/) skeleton to a full [API Platform](https://api-platform.com/) or [EasyAdmin](https://github.com/EasyCorp/EasyAdminBundle) stack, [Symfony Starter](https://github.com/jprivet-dev/symfony-starter) handles the entire setup — Docker, database, dependencies — so you can focus on your code from the first minute. You can also use the official [Symfony Demo](https://github.com/symfony/demo) as a reference for best practices, or [contribute to Symfony Core](.starter/docs/contrib.md) in a real Docker environment.

Built on top of [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker) and driven by a powerful Makefile, it covers everything from project initialization to daily development.

|                                                                                                                         |                                                                                                    |
|:------------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------|
| <strong>[Symfony](https://symfony.com/)</strong><br>![minimalist.png](.starter/docs/img/minimalist.png)                          | <strong>[API Platform](https://api-platform.com/)</strong><br>![api.png](.starter/docs/img/api.png)         |
| <strong>[EasyAdmin](https://github.com/EasyCorp/EasyAdminBundle)</strong><br>![easy-admin.png](.starter/docs/img/easy-admin.png) | <strong>[Symfony Demo](https://github.com/symfony/demo)</strong><br>![demo.png](.starter/docs/img/demo.png) |

## Quick start

1. Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

2. Clone the project:

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git
cd symfony-starter
```

3. And generate...

| Application     | Stable            | LTS                   | Database      |
|-----------------|-------------------|-----------------------|---------------|
| 🌱 Minimalist   | `make minimalist` | `make minimalist@lts` | 🚫 No DB      |
| 🌍 Webapp       | `make webapp`     | `make webapp@lts`     | 🐘 PostgreSQL |
| 🔌 API Platform | `make api`        | `make api@lts`        | 🐘 PostgreSQL |
| ⚡ EasyAdmin     | `make easy_admin` | `make easy_admin@lts` | 🐘 PostgreSQL |
| 🎓 Demo         | `make demo`       | —                     | 🪶 SQLite     |

## Switch to another DB

> By default, **🐘 PostgreSQL** is used. Run one of the following commands after generation to switch to another database.

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
| 🌱 Minimalist   | [minimalist](https://github.com/jprivet-dev/symfony-starter/tree/minimalist)         | [minimalist@lts](https://github.com/jprivet-dev/symfony-starter/tree/minimalist@lts)         | 🚫 No DB      |
| 🌍 Webapp       | [webapp](https://github.com/jprivet-dev/symfony-starter/tree/webapp)                 | [webapp@lts](https://github.com/jprivet-dev/symfony-starter/tree/webapp@lts)                 | 🐘 PostgreSQL |
|                 | [webapp@mariadb](https://github.com/jprivet-dev/symfony-starter/tree/webapp@mariadb) | [webapp@lts_mariadb](https://github.com/jprivet-dev/symfony-starter/tree/webapp@lts_mariadb) | 🐬 MariaDB    |
|                 | [webapp@sqlite](https://github.com/jprivet-dev/symfony-starter/tree/webapp@sqlite)   | [webapp@lts_sqlite](https://github.com/jprivet-dev/symfony-starter/tree/webapp@lts_sqlite)   | 🪶 SQLite     |
| 🔌 API Platform | [api](https://github.com/jprivet-dev/symfony-starter/tree/api)                       | [api@lts](https://github.com/jprivet-dev/symfony-starter/tree/api@lts)                       | 🐘 PostgreSQL |
| ⚡ EasyAdmin     | [easy_admin](https://github.com/jprivet-dev/symfony-starter/tree/easy_admin)         | [easy_admin@lts](https://github.com/jprivet-dev/symfony-starter/tree/easy_admin@lts)         | 🐘 PostgreSQL |
| 🎓 Demo         | [demo](https://github.com/jprivet-dev/symfony-starter/tree/demo)                     | —                                                                                            | 🪶 SQLite     |

## Documentation

📖 [Browse the full documentation](.starter/docs/README.md)

## Main links

* https://symfony.com/doc/current/setup/docker.html
* https://github.com/dunglas/symfony-docker
* https://github.com/jprivet-dev/symfony-docker

## Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-starter/issues).

## Credits & License

* Based on [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker).
* This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter/blob/main/LICENSE).
