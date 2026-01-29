# 🐳 🎵 Symfony Starter

**Generate a fully Dockerized Symfony application in seconds.**

Whether you want to instantly test a **Stable or LTS** version of Symfony, API Platform or EasyAdmin, validate your **framework contributions** in a real environment, or start a **client project** with robust, documented tooling: **Symfony Starter is the solution you need**.

It leverages the power of [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker) combined with a powerful Makefile to manage the entire lifecycle.

## ⚡ What can you do with this Starter?

This project is designed to handle the entire lifecycle of a Symfony project, from initialization to daily development.

### 1. 🏗️ Scaffolding & Initialization

* **Instant Setup:** Bootstrap a Dockerized project in seconds: [Minimalist](#minimalist), [Web App](#web-app), [API Platform](#api-platform), [EasyAdmin](#easyadmin) or [Demo](#demo).
* **Database Agnostic:** The starter comes with **PostgreSQL** by default but offers commands to easily switch to **MySQL/MariaDB** or **SQLite** configuration.

### 2. 🧰 Daily Workflow

* **Powerful Makefile:** Forget complex Docker commands. Use a standardized set of **90+ available commands** (`make start`, `make db_init`, `make tests`) to manage your stack.
* **Transparent History:** Every generation step is committed to Git (🤖 `[starter]`), giving you a full audit trail of the installation process.

### 3. 🧩 Ecosystem & Quality

* **IDE Ready:** Comprehensive documentation to configure **PhpStorm** perfectly:
  * [Connect Docker PHP Interpreter](docs/remote-php-interpreter.md)
  * [Connect to the Database](docs/postgre.md)
* **Quality Assurance:** Pre-configured tools to maintain high code quality from day one (PHPStan, CS Fixer, Tests).

### 4. 🤝 Contributing to Symfony Core

* **Seamless Local Linking:** Easily mount your local `symfony/symfony` repository into the container.
* **Real-world Testing:** Test your pull requests and framework modifications against a running application instantly without complex configuration.
* **[📖 Read the Contribution Guide](docs/contributing.md)**

## ✨ Available Flavors

You can choose from several pre-configured setups.

<table>
    <thead>
        <tr>
            <th>Stack & Description</th>
            <th width="35%">Preview</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>
                <h3>🌱 Minimalist</h3>
                <p>The bare minimum. A clean Symfony skeleton without Docker bloat or ORM pre-configured.</p>
                <p><em>Perfect for: Microservices, Learning, Custom architecture.</em></p>
            </td>
            <td align="center"><img src="docs/img/minimalist.png" alt="Minimalist Preview" width="100%"></td>
        </tr>
        <tr>
            <td>
                <h3>🌍 Web App</h3>
                <p>The standard full-stack experience. Includes <strong>Twig</strong>, <strong>AssetMapper</strong>, <strong>Profiler</strong>, and a complete Docker setup.</p>
                <p><em>Perfect for: Traditional Websites, SaaS, MVP.</em></p>
            </td>
            <td align="center"><img src="docs/img/minimalist.png" alt="Webapp Preview" width="100%"></td>
        </tr>
        <tr>
            <td>
                <h3>🔌 API Platform</h3>
                <p>A headless stack optimized for <strong>API Platform</strong>. No front-end assets, focused on performance and REST/GraphQL.</p>
                <p><em>Perfect for: SPA Backends (React/Vue), Mobile Apps.</em></p>
            </td>
            <td align="center"><img src="docs/img/api.png" alt="API Preview" width="100%"></td>
        </tr>
        <tr>
            <td>
                <h3>⚡ EasyAdmin</h3>
                <p>Based on the Web App, but pre-installed with <strong>EasyAdmin</strong> for an instant back-office generation.</p>
                <p><em>Perfect for: Admin Panels, rapid CRUD apps.</em></p>
            </td>
            <td align="center"><img src="docs/img/easy-admin.png" alt="EasyAdmin Preview" width="100%"></td>
        </tr>
         <tr>
            <td>
                <h3>🎓 Demo</h3>
                <p>The official <strong>Symfony Demo</strong> application. A great reference for best practices.</p>
            </td>
            <td align="center"><img src="docs/img/demo.png" alt="Demo Preview" width="100%"></td>
        </tr>
    </tbody>
</table>

## 📦 Generation Guide & Availability

Depending on your needs, you might need to run extra commands after the initial generation (e.g., to install the ORM or switch databases).

### 1. Command Recipes

Find your desired stack below and follow the command steps.

> **ℹ️ LTS Version:** To target the **Long Term Support** version of Symfony, simply append `@lts` to the main command (e.g., `make webapp` → `make webapp@lts`).

#### 🌱 Minimalist

| Database          | Stable                                                              | LTS                      |
|-------------------|---------------------------------------------------------------------|--------------------------|
| **🚫 No DB**      | `make minimalist`                                                   | `make minimalist@lts`    |
| **🐘 PostgreSQL** | `make minimalist`<br>`make require_orm`                             | *Same steps with `@lts`* |
| **🐬 MariaDB**    | `make minimalist`<br>`make require_orm`<br>`make switch_to_mariadb` | *Same steps with `@lts`* |

#### 🌍 Web App

| Database          | Stable                                    | LTS                      |
|-------------------|-------------------------------------------|--------------------------|
| **🐘 PostgreSQL** | `make webapp`                             | `make webapp@lts`        |
| **🐬 MariaDB**    | `make webapp`<br>`make switch_to_mariadb` | *Same steps with `@lts`* |

#### 🔌 API Platform

| Database          | Stable                                 | LTS                      |
|-------------------|----------------------------------------|--------------------------|
| **🐘 PostgreSQL** | `make api`                             | `make api@lts`           |
| **🐬 MariaDB**    | `make api`<br>`make switch_to_mariadb` | *Same steps with `@lts`* |

#### ⚡ EasyAdmin

| Database          | Stable                                        | LTS                      |
|-------------------|-----------------------------------------------|--------------------------|
| **🐘 PostgreSQL** | `make easy_admin`                             | `make easy_admin@lts`    |
| **🐬 MariaDB**    | `make easy_admin`<br>`make switch_to_mariadb` | *Same steps with `@lts`* |

#### 🎓 Demo

| Database      | Stable      |
|---------------|-------------|
| **🪶 SQLite** | `make demo` |

### 2. Source Code & Branches

Direct links to the generated source code for each variation.

| Stack          | Version | 🚫 No DB                          | 🐘 PostgreSQL                                | 🐬 MariaDB                                | 🪶 SQLite               |
|----------------|---------|-----------------------------------|----------------------------------------------|-------------------------------------------|-------------------------|
| **Minimalist** | Stable  | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/minimalist)     | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/minimalist-postgresql)     | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/minimalist-mariadb)     | —                       |
|                | LTS     | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/minimalist@lts) | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/minimalist@lts-postgresql) | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/minimalist@lts-mariadb) | —                       |
| **Webapp**     | Stable  | —                                 | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/webapp)                    | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/webapp-mariadb)         | —                       |
|                | LTS     | —                                 | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/webapp@lts)                | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/webapp@lts-mariadb)     | —                       |
| **API**        | Stable  | —                                 | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/api)                       | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/api-mariadb)            | —                       |
|                | LTS     | —                                 | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/api@lts)                   | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/api@lts-mariadb)        | —                       |
| **EasyAdmin**  | Stable  | —                                 | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/easy_admin)                | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/easy_admin-mariadb)     | —                       |
|                | LTS     | —                                 | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/easy_admin@lts)            | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/easy_admin@lts-mariadb) | —                       |
| **Demo**       | Stable  | —                                 | —                                            | —                                         | [🔗 Source](https://github.com/jprivet-dev/symfony-starter/tree/demo) |

## 🚀 Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## 🛠️ Usage

There are two ways to use this starter:

### Method 1: The Generator (Recommended for new projects)

Clone the main repository and generate the application you need on the fly.

#### Step 1. Clone the repository

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git
cd symfony-starter
```

#### Step 2. Generate your application

```shell
# Example: Generate a full Web App (Stable)
make webapp

# Example: Generate an API Platform project (LTS)
make api@lts

# Example: Generate a specific Minimalist Version
SYMFONY_VERSION=6.4.3 make minimalist
```

> This will:
> * Clone and extract `dunglas/symfony-docker` configuration files.
> * Build the necessary Docker images and start the containers.
> * Generate a fresh Symfony application inside the container.
> * Eventually add extra packages (API Platform, Admin, etc.) depending on the chosen flavor.
>

#### Step 3. Access the app

Open `https://symfony-starter.localhost:8443/` in your browser and [accept the auto-generated TLS certificate](https://stackoverflow.com/a/15076602/1352334).

> See [Caddy - Validate certificates](docs/certificates.md)

### Method 2: The Snapshot (Fastest start)

If you just want to test a specific configuration immediately without waiting for the generation process, checkout the specific branch.

#### Step 1. Clone and checkout

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git
cd symfony-starter

# Switch to the desired flavor
git checkout webapp
```

#### Step 2. Install and Start

```shell
make install
```

## 🔄 Switching Flavors & Cleanup

You can easily switch between flavors or restart from scratch using the cleanup command. This will **delete** the current Symfony application and Docker configuration to allow a fresh generation.

```shell
# 1. Nuke the current setup (Containers, Volumes, Source code)
make kill_current_app

# 2. Generate a different flavor
make easy_admin
```

## 🧰 Developer Toolkit

This starter is a **daily companion**.
It embeds a robust `Makefile` to abstract complex Docker/Composer commands, speeding up your workflow.

Here is a glimpse of what's included:

| Category        | Key Commands               | Description                                                     |
|-----------------|----------------------------|-----------------------------------------------------------------|
| **🐳 Docker**   | `make start` / `make stop` | Start/Stop the stack (detached mode).                           |
|                 | `make sh`                  | Access the PHP container shell.                                 |
|                 | `make logs`                | View live logs from all containers.                             |
| **🚀 Symfony**  | `make cc`                  | Clear the cache (`cache:clear`).                                |
|                 | `make symfony c="..."`     | Run any Symfony command (e.g. `make symfony c="debug:router"`). |
| **🐘 Database** | `make db_init`             | Create DB, run migrations and load fixtures in one go.          |
|                 | `make migration`           | Generate a new migration file.                                  |
| **✅ Quality**   | `make tests`               | Run PHPUnit tests.                                              |
|                 | `make phpmd`               | Run PHP Mess Detector.                                          |
| **🎨 Assets**   | `make assets`              | Generate all assets.                                            |

> 💡 **Tip: 90+ available makefile commands**
> * Just run `make` (or `make help`) in your terminal to see the beautiful, self-documented list of available commands**.
> * See [Makefile documentation](docs/makefile.md) for details.

## 🏗️ Project Structure

After `make minimalist`, your project structure will look like this:

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

**(*)** Indicates files/directories generated or copied from `dunglas/symfony-docker` or `symfony/skeleton`.

To visualize your structure (requires `tree` command):

```shell
tree -A -L 1 -F --dirsfirst
```

## 🔍 Traceable Generation Process

The `Makefile` commits every significant step of the generation process (applying patches, modifying configuration, installing bundles). This creates a clean, readable Git history that lets you understand exactly how your application was constructed.

**Example of a generated `git log`:**

```text
🤖 [starter] make git_apply f=common/docker-entrypoint-clean-composer.patch
🤖 [starter] make build up_detached
🤖 [starter] make yq_update f=compose.yaml k=services.php.environment.DATABASE_URL v=${DATABASE_URL}
🤖 [starter] make yq_add f=compose.override.yaml k=services.php.volumes v=./var/log:/app/var/log
🤖 [starter] make yq_add f=compose.override.yaml k=services.php.volumes v=./var:/app/var
🤖 [starter] make clone_symfony_docker
Initial commit
```

**Benefits:**

* **Audit:** You see exactly which files were modified by the starter.
* **Safety:** You can easily revert a specific step if a patch conflicts with your needs.
* **Learning:** It helps understand the integration between Docker and Symfony.

**Check the git history of these branches to see it in action:**

* **Stable:** [minimalist](https://github.com/jprivet-dev/symfony-starter/tree/minimalist) | [webapp](https://github.com/jprivet-dev/symfony-starter/tree/webapp) | [easy_admin](https://github.com/jprivet-dev/symfony-starter/tree/easy_admin) | [demo](https://github.com/jprivet-dev/symfony-starter/tree/demo)
* **LTS:** [minimalist@lts](https://github.com/jprivet-dev/symfony-starter/tree/minimalist@lts) | [webapp@lts](https://github.com/jprivet-dev/symfony-starter/tree/webapp@lts) | [api@lts](https://github.com/jprivet-dev/symfony-starter/tree/api@lts) | [easy_admin@lts](https://github.com/jprivet-dev/symfony-starter/tree/easy_admin@lts)

## 📚 Documentation

**🐳 Docker & Configuration**

* [Caddy - Validate certificates](docs/certificates.md)
* [Compose - Accessing the `var/` directory](docs/var.md)
* [Makefile - Discover all commands](docs/makefile.md)
* [Symfony - Save your generated application](docs/save.md)
* [Symfony and Docker - Use build options](docs/options.md)

**🐘 Database**

* [PhpStorm - Connect it to PostgreSQL](docs/postgre.md)
* *Switching to MySQL/MariaDB (Coming soon)*
* *Switching to SQLite (Coming soon)*

**💻 IDE & Quality (DX)**

* [PHP - Quality Tools (PHPStan, CS Fixer, etc.)](docs/quality.md)
* [PHP - Testing (PHPUnit)](docs/testing.md)
* [PhpStorm - Configure Remote PHP Interpreter](docs/remote-php-interpreter.md)

**🔧 Advanced**

* [ADR (Architecture Decision Records)](docs/adr.md)
* [Shell Aliases: Seamless Docker Experience](docs/aliases.md)
* [Troubleshooting](docs/troubleshooting.md)

**🤝 Contributing**

* [Contributing to Symfony: Connect Your Local Symfony Repository](docs/contributing.md)

## 🔗 Main links

* https://symfony.com/doc/current/setup/docker.html
* https://github.com/dunglas/symfony-docker
* https://github.com/jprivet-dev/symfony-docker

## 📝 Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-starter/issues).

## 🤝 Credits & License

* Based on [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker).
* This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter/blob/main/LICENSE).

