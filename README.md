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
make minimalist

# Minimalist Long-Term Support Release (LTS)
make minimalist@lts

# Webapp Stable Release
make webapp

# Webapp Long-Term Support Release (LTS)
make webapp@lts

# Specific Minimalist Version
SYMFONY_VERSION=6.4.3 make minimalist

# Specific Webapp Version
SYMFONY_VERSION=6.4.3 make webapp
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
git clone git@github.com:jprivet-dev/symfony-starter.git && cd symfony-starter && make minimalist

# Minimalist Long-Term Support Release (LTS)
git clone git@github.com:jprivet-dev/symfony-starter.git && cd symfony-starter && make minimalist@lts

# Webapp Stable Release
git clone git@github.com:jprivet-dev/symfony-starter.git && cd symfony-starter && make webapp

# Webapp Long-Term Support Release (LTS)
git clone git@github.com:jprivet-dev/symfony-starter.git && cd symfony-starter && make webapp@lts
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

# Then regenerate the Symfony app (LTS version for example):
make minimalist@lts
```

## Daily usage

```shell
make start # Start the project and show info (up_detached & info alias)
make stop  # Stop the project (down alias)
```

* Run `make` to see all shorcuts for the most common tasks:

<!-- MAKEFILE_COMMANDS_START -->

```

— 🐳 🎵 THE SYMFONY STARTER MAKEFILE 🎵 🐳 —————————————————————————————————
  help                          Display this help message with available commands

— GENERATION 🔨 ————————————————————————————————————————————————————————————
  minimalist                    Generate a minimalist Symfony application with Docker configuration (stable release)
  minimalist@lts                Generate a minimalist Symfony application with Docker configuration (LTS - long-term support release)

  clone_symfony_docker          Clone and extract https://github.com/dunglas/symfony-docker files at the root
  clone_symfony_demo            Clone and extract https://github.com/symfony/demo files at the root --- 🧪 EXPERIMENTAL 🧪 ---
  clear_all                     Remove all fresh Symfony application files

  COMPLETE INSTALLATION
  install_doctrine              Install Doctrine - https://symfony.com/doc/current/doctrine.html
  install_phpunit               Install PHPUnit - https://symfony.com/doc/current/testing.html
  install_asset_mapper          Install AssetMapper - https://symfony.com/doc/current/frontend/asset_mapper.html
  install_translation           Install translation - https://symfony.com/doc/current/translation.html

  install_profiler              Install the profiler - https://symfony.com/doc/current/profiler.html
  install_maker_bundle          Install the MakerBundle - https://symfony.com/bundles/SymfonyMakerBundle/current/index.html
  install_bootstrap             Install Bootstrap - https://getbootstrap.com/
  install_stimulus              Install StimulusBundle - https://ux.symfony.com/

  install_webapp                Install a web application - https://symfony.com/doc/current/setup.html
  install_api                   Install API Platform - https://api-platform.com/docs/symfony/
  install_easy_admin            Install EasyAdmin Bundle - https://symfony.com/bundles/EasyAdminBundle/current/index.html

— PROJECT 🚀 ———————————————————————————————————————————————————————————————
  start                         Start the project and show info (up_detached & info alias)
  stop                          Stop the project (down alias)
  restart                       Stop & Start the project and show info (up_detached & info alias)
  info                          Show project access info

  install                       Start the project, install dependencies and show info
  check                         Check everything before you deliver

— SYMFONY 🎵 ———————————————————————————————————————————————————————————————
  symfony                    sf Run Symfony console command - $ make symfony [ARG=<arguments>]- Example: $ make symfony ARG=cache:clear
  cc                            Clear the Symfony cache
  about                         Display information about the current Symfony project
  routes                        Display current routes with assigned controllers and aliases

  dotenv                        Lists all .env files with variables and values
  dumpenv                       Generate .env.local.php for production

— PHP 🐘 ———————————————————————————————————————————————————————————————————
  php                           Run PHP command - $ make php [ARG=<arguments>]- Example: $ make php ARG=--version

  php_sh                        Connect to the PHP container shell
  php_env                       Display all environment variables set within the PHP container
  php_command                   Run a command inside the PHP container - $ make php_command [ARG=<arguments>]- Example: $ make php_command ARG="ls -al"

— COMPOSER 🧙 ——————————————————————————————————————————————————————————————
  composer                      Run composer command - $ make composer [ARG=<arguments>] - Example: $ make composer ARG="require --dev phpunit/phpunit"
  composer_install              Install Composer packages
  composer_update               Update Composer packages
  composer_update_lock          Update only the content hash of composer.lock without updating dependencies
  composer_validate             Check if lock file is up to date (even when config.lock is false)

— DOCTRINE & SQL 💽 ————————————————————————————————————————————————————————
  db_drop                       Drop the database - $ make db_drop [ARG=<arguments>] - Example: $ make db_drop ARG="--env=test"
  db_create                     Create the database - $ make db_create [ARG=<arguments>] - Example: $ make db_create ARG="--env=test"
  db_clear                      Drop and create the database
  db_init                       Drop and create the database and add fixtures

  validate                      Validate the mapping files - $ make validate [ARG=<arguments>] - Example: $ make validate ARG="--env=test"
  update                        Generate and output the SQL needed to synchronize the database schema with the current mapping metadata
  update_force                  Execute the generated SQL needed to synchronize the database schema with the current mapping metadata

  migration                     Create a new migration based on database changes (format the generated SQL)
  migrate                       Execute a migration to the latest available version (in a transaction) - $ make migrate [ARG=<param>] - Example: $ make migrate ARG="current+3"
  list                          Display a list of all available migrations and their status
  execute                       Execute one or more migration versions up or down manually - $ make execute ARG=<arguments> - Example: $ make execute ARG="DoctrineMigrations\Version20240205143239"
  generate                      Generate a blank migration class

  sql                           Execute the given SQL query and output the results - $ make sql [QUERY=<query>] - Example: $ make sql QUERY="SELECT * FROM user"
  sql_tables                    Show all tables

  fixtures                      Load fixtures (CAUTION! by default the load command purges the database) - $ make fixtures [ARG=<param>] - Example: $ make fixtures ARG="--append"

— POSTGRESQL 💽 ————————————————————————————————————————————————————————————
  psql                          Execute psql - $ make psql [ARG=<arguments>] - Example: $ make psql ARG="-V"

— TESTS ✅ —————————————————————————————————————————————————————————————————
  phpunit                       Run PHPUnit - $ make phpunit [ARG=<arguments>] - Example: $ make phpunit ARG="tests/myTest.php"
  coverage                      Generate code coverage report in HTML format for all tests
  dox                           Report test execution progress in TestDox format for all tests

  xdebug_version                Xdebug version number

— ASSETS 🎨‍ ————————————————————————————————————————————————————————————————
  assets                        Generate all assets

  asset_map_clear               Clear all assets in the public output directory
  asset_map_compile             Compile all mapped assets and writes them to the final public output directory
  asset_map_debug               See all of the mapped assets

  importmap_audit               Check for security vulnerability advisories for dependencies
  importmap_install             Download all assets that should be downloaded
  importmap_outdated            List outdated JavaScript packages and their latest versions
  importmap_remove              Remove JavaScript packages
  importmap_require             Require JavaScript packages
  importmap_update              Update JavaScript packages to their latest versions

— TRANSLATION 🇬🇧 ———————————————————————————————————————————————————————————
  extract                       Extracts translation strings from templates (fr)

— DOCKER 🐳 ————————————————————————————————————————————————————————————————
  up                            Start the containers - $ make up [ARG=<arguments>] - Example: $ make up ARG=-d
  up_detached                   Start the containers (wait for services to be running|healthy - detached mode)
  down                          Stop and remove the containers
  build                         Build or rebuild Docker services - $ make build [ARG=<arguments>] - Example: $ make build ARG=--no-cache
  build_force                   Build or rebuild Docker services (no cache) - $ make build [ARG=<arguments>]
  logs                          Display container logs
  images                        List images used by the current containers
  config                        Parse, resolve, and render compose file in canonical format

— CERTIFICATES 🔐‍️ ——————————————————————————————————————————————————————————
  certificates                  Installs the Caddy TLS certificate to the trust store
  certificates_export           Exports the Caddy root certificate from the container to the host
  hosts                         Add the server name to /etc/hosts file

— TROUBLESHOOTING 😵️ ———————————————————————————————————————————————————————
  permissions                p  Fix file permissions (primarily for Linux hosts)
  git_safe_dir                  Add /app to Git's safe directories within the php container

— UTILITIES 🛠️ —————————————————————————————————————————————————————————————
  env_files                     Show env files loaded into this Makefile
  vars                          Show key Makefile variables
```

<!-- MAKEFILE_COMMANDS_END -->

## Project structure

After `make minimalist`, your project structure will look like this (Minimalist Stable Release):

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

* [Validate certificates](docs/certificates.md)
* [Save your generated Symfony application](docs/save.md)
* [Configure a remote PHP interpreter (Docker)](docs/remote-php-interpreter.md)
* [Accessing the `var/` directory](docs/var.md)
* [Docker build options](docs/options.md)
* [Testing](docs/testing.md)
* [Quality](docs/quality.md)
* [Troubleshooting](docs%2Ftroubleshooting.md)

## Main resources

* https://symfony.com/doc/current/setup/docker.html
* https://github.com/dunglas/symfony-docker
* https://github.com/jprivet-dev/symfony-docker

## Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-starter/issues).

## License

This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter/blob/main/LICENSE).
