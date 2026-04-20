# Makefile - Discover all commands

[⬅️ README](README.md)

---

> **Tip: A Dynamic Makefile**
>
> This project uses a modular Makefile system. Commands are loaded **dynamically** based on the components currently installed in your project.
>
> * Run `make` (or `make help`) to see **context-sensitive commands** (only those relevant to your current environment).
> * Run `make all` to see the **full catalog** of commands available in the Starter Kit (including inactive ones).

<!-- MAKEFILE_COMMANDS_START -->

```

— 🐳 🎵 THE SYMFONY STARTER MAKEFILE 🎵 🐳 —————————————————————————————————
  help                          Display this help message with available commands - $ make [f=<filter>] - $ make f=restart
  all                           See the full catalog of commands available in the Starter Kit (including inactive ones)

— PROJECT 🚀 ———————————————————————————————————————————————————————————————
  install                       Start the project, install dependencies and show info
  info                          Show project access info

  start                         Start the project and show info (detached mode)
  stop                          Stop the project (down)

  restart                       [Level 1] Standard restart - Reloading containers (triggers: .env, compose.yaml, code changes)
  build_start                   [Level 2] Build & Start - Updating image with cache (triggers: composer.lock, CaddyFile, *.ini, entrypoint.sh)
  build_force_start             [Level 3] Force build & Start - Rebuilding from scratch (triggers: Dockerfile, system packages, cache issues)

  check_level_1              c1 Check everything before you deliver - Composer, Doctrine validation, linters (stop on failure)
  check_level_2              c2 Check everything before you deliver - Composer, Doctrine validation, linters, PHPUnit (stop on failure)
  tests                      t  Run all tests

— DOCKER 🐳 ————————————————————————————————————————————————————————————————
  build                         Build or rebuild Docker services using cache - $ make build [a=<arguments>] - Example: $ make build a=--no-cache
  build_force                   Build or rebuild Docker services without cache (force fresh install)

  up                            Start the containers - $ make up [a=<arguments>] - Example: $ make up a=-d
  up_detached                   Start the containers (wait for services to be running|healthy - detached mode)

  down                          Stop the containers
  kill                          Remove containers and networks (keep database data)
  kill_all                      Remove containers, networks AND VOLUMES (database destroyed)

  deep_clean                    [Danger] Remove containers, volumes, networks and images, including orphans (triggers: webapp-pack, database, branch switch) [y/N]

  config                        Parse, resolve, and render compose file in canonical format
  images                        List images used by the current containers
  logs                          View logs (follow mode)

— SYMFONY 🎵 ———————————————————————————————————————————————————————————————
  symfony                    sf Run any Symfony console command - $ make symfony [c=<command>]- Example: $ make symfony c=cache:clear
  console                       Symfony console alias - $ make console [c=<command>]- Example: $ make console c=cache:clear

  about                         Display information about the current Symfony project
  cache_clear                cc Clear the Symfony cache
  dotenv                        Lists all .env files with variables and values
  dumpenv                       Generate .env.local.php for production
  routes                        Display current routes with assigned controllers and aliases

— PHP 🐘 ———————————————————————————————————————————————————————————————————
  php                           Run PHP command - $ make php [a=<arguments>]- Example: $ make php a=--version

  php_command                   Run a command inside the PHP container - $ make php_command [a=<arguments>]- Example: $ make php_command a="ls -al"
  php_env                       Display all environment variables set within the PHP container
  php_sh                     sh Connect to the PHP container shell

— COMPOSER 🧙 ——————————————————————————————————————————————————————————————
  composer                      Run composer command - $ make composer [a=<arguments>] - Example: $ make composer a="require --dev phpunit/phpunit"
  composer_install           i  Install Composer packages
  composer_validate             Check if lock file is up to date (even when config.lock is false)

  outdated                      Show a list of installed packages that have updates available, including their latest version
  remove                        Remove a package from the require or require-dev - $ make remove [a=<arguments>] - Example: $ make remove a="phpunit/phpunit"
  require                       Add required packages to your composer.json and installs them - $ make require [a=<arguments>] - Example: $ make require a="--dev phpunit/phpunit"
  update                        Update Composer packages - $ make update [a=<arguments>] - Example: $ make update a="symfony/monolog-bundle"
  update_lock                   Update only the content hash of composer.lock without updating dependencies
  config                        Run composer config - $ make config k=<key> [v=<value>] - Example: $ make config k=repositories.monolog-bundle v='{"type": "path", "url": "/monolog-bundle"}'

— CERTIFICATES 🔐‍️ ——————————————————————————————————————————————————————————
  certificates                  Install the Caddy TLS certificate to the trust store
  certificates_export           Export the Caddy root certificate from the container to the host
  hosts                         Add the server name to /etc/hosts file

— GIT 🐙 ———————————————————————————————————————————————————————————————————
  git_hooks_init                Initialize the project's hooks directory (set GIT_HOOKS var)

  git_hooks_disable             Disable the project's hooks directory
  git_hooks_enable              Enable the project's hooks directory
  git_pre_push                  Actions on Git pre-push

— TROUBLESHOOTING 😵️ ———————————————————————————————————————————————————————
  permissions                   Fix file permissions (primarily for Linux hosts)
  safe                          Add /app to Git's safe directories within the php container

— UTILITIES 🛠️ —————————————————————————————————————————————————————————————
  aliases                       Show aliases info and loading instructions
  env_files                     Show env files loaded into this Makefile
  tree                          Visualize your structure (requires `tree` command) - $ make tree [l=<level>] - Example: $ make tree l=1
  vars                          Show key Makefile variables

— DOCTRINE / SQL 💽 ————————————————————————————————————————————————————————
  db                            Drop and create the database and migrate
  db@test                       Drop and create the database and migrate (env=test)

  drop                          Drop the database [y/N] - $ make drop [a=<arguments>] - Example: $ make drop a="--env=test"
  create                        Create the database - $ make create [a=<arguments>] - Example: $ make create a="--env=test"

  diff                          Generate a migration by comparing your current database to your mapping information (format the generated SQL) - $ make diff [a=<param>] - Example: $ make diff a="--profile"
  execute                       Execute one or more migration versions up or down manually - $ make execute a=<arguments> - Example: $ make execute a="DoctrineMigrations\Version20240205143239"
  generate                      Generate a blank migration class
  list                          Display a list of all available migrations and their status
  migrate                       Execute a migration to the latest available version (in a transaction) - $ make migrate [a=<param>] - Example: $ make migrate a="current+3"
  migration                     Create (via MakerBundle) a new migration based on database changes (format the generated SQL) - $ make migration [a=<param>] - Example: $ make migration a="--profile"

  fixtures                      Load fixtures (CAUTION! The load command purges the database) - $ make fixtures [a=<param>] - Example: $ make fixtures a="--append"
  fixtures@test                 Load fixtures (env=test)
  sql                           Execute the given SQL query and output the results - $ make sql [q=<query>] - Example: $ make sql q="SELECT * FROM user"
  update_dump                   Generate and output the SQL needed to synchronize the database schema with the current mapping metadata
  update_force                  Execute the generated SQL needed to synchronize the database schema with the current mapping metadata
  validate                      Validate the mapping files - $ make validate [a=<arguments>] - Example: $ make validate a="--env=test"

  phpstorm_config               Display database connection details for PhpStorm "Data Sources and Drivers" dialog

— POSTGRESQL 🛢️ ————————————————————————————————————————————————————————————
  psql                          Execute psql - $ make psql [a=<arguments>] - Example: $ make psql a="-V"
  psql_sh                       Open a shell on the PostgreSQL container
  table                         Show the content of a table - $ make table n=<name> - Example: $ make table n=user
  tables                        Show all tables

  dump                          Create a SQL dump
  dump_gz                       Create a compressed SQL dump (gzip)
  restore                       Restore a dump (CAUTION! The command purges the database) [y/N] - $ make restore f=<file> - Example: $ make restore f="build/dumps/dump.sql"

— MYSQL 🛢️ —————————————————————————————————————————————————————————————————
  mysql                         Execute mysql - $ make mysql [a=<arguments>] - Example: $ make mysql a="-V"
  mysql_sh                      Open a shell on the MySQL/MariaDB container
  table                         Show the content of a table - $ make table n=<name> - Example: $ make table n=user
  tables                        Show all tables

  dump                          Create a SQL dump
  dump_gz                       Create a compressed SQL dump (gzip)
  restore                       Restore a dump (CAUTION! The command purges the database) [y/N] - $ make restore f=<file> - Example: $ make restore f="build/dumps/dump.sql"

— SQLITE 🛢️ ————————————————————————————————————————————————————————————————
  sqlite                        Execute sqlite3 - $ make sqlite [a=<arguments>] - Example: $ make sqlite a="-version"
  sqlite_sh                     Open a SQLite shell on the PHP container
  table                         Show the content of a table - $ make table n=<name> - Example: $ make table n=user
  tables                        Show all tables

  dump                          Create a SQL dump
  dump_gz                       Create a compressed SQL dump (gzip)
  restore                       Restore a dump (CAUTION! The command purges the database) [y/N] - $ make restore f=<file> - Example: $ make restore f="build/dumps/dump.sql"

— PHPUNIT ✅ ———————————————————————————————————————————————————————————————
  phpunit                    p  Run PHPUnit - $ make phpunit [a=<arguments>] - Example: $ make phpunit a="tests/myTest.php"
  phpunit_log                   Exporting PHPUnit terminal output to a log file

  coverage                      Generate code coverage report in HTML format - $ make coverage [a=<arguments>] - Example: $ make coverage a="tests/myTest.php"
  dox                           Report test execution progress in TestDox format - $ make dox [a=<arguments>] - Example: $ make dox a="tests/myTest.php"
  dox_html                      Report test execution progress in TestDox format and export it to an HTML file
  dox_text                      Report test execution progress in TestDox format and export it to a text file
  xdebug_version                Xdebug version number

— QUALITY ✅ ———————————————————————————————————————————————————————————————
  fix                           Fix with all linters
  lint                          Run all linters (stop on failure)

  phpcsfixer                    Run PHP CS Fixer - $ make phpcsfixer [a=<arguments>] - Example: $ make phpcsfixer a=list
  phpcsfixer_fix                Fix code style
  phpcsfixer_lint               Check code style

  phpmd                         Run PHP Mess Detector - $ make phpmd [a=<arguments>] - Example: $ make phpmd a="src ansi cleancode"
  phpmd_lint                    Run PHP Mess Detector with all rules

  phpmetrics_report             Run PHPMetrics and generate detailed report

  phpstan                       Run PHPStan - $ make phpstan [a=<arguments>] - Example: $ make phpstan a="src tests"
  phpstan_baseline              Generate PHPStan baseline - $ make phpstan_baseline [a=<arguments>] - Example: $ make phpstan_baseline a="src tests"
  phpstan_lint                  Run PHPStan analyse - $ make phpstan_analyse [a=<arguments>] - Example: $ make phpstan_analyse a="src tests"

  twigcsfixer                   Run Twig CS Fixer - $ make twigcsfixer [a=<arguments>] - Example: $ make twigcsfixer a="lint /path/to/code"
  twigcsfixer_fix               Fix Twig style
  twigcsfixer_lint              Check Twig style

— ASSETS 🎨‍ ————————————————————————————————————————————————————————————————
  assets                        Generate all assets

  asset_map_clear               Clear all assets in the public output directory
  asset_map_compile             Compile all mapped assets and write them to the final public output directory
  asset_map_debug               See all of the mapped assets

  importmap_audit               Check for security vulnerability advisories for dependencies
  importmap_install             Download all assets that should be downloaded
  importmap_outdated            List outdated JavaScript packages and their latest versions
  importmap_remove              Remove JavaScript packages
  importmap_require             Require JavaScript packages
  importmap_update              Update JavaScript packages to their latest versions

  tailwind_init                 Initializes Tailwind CSS for your project
  tailwind_clear                Clear var/tailwind directory
  tailwind_build                Build the Tailwind CSS assets - $ make tailwind_build [a=<arguments>] - Example: $ make tailwind_build a=--help
  tailwind_watch             w  Watch for changes and rebuild automatically.
  tailwind_minify               Minify the output CSS.
  tailwind_debug                See the full config from TailwindBundle

— TRANSLATION 🇬🇧 ———————————————————————————————————————————————————————————
  extract                       Extract translation strings from templates

— SYMFONY CONTRIBUTION 🔗 ——————————————————————————————————————————————————

  (to delete this section, delete make/contrib.mk)

  contrib_volume                Add a Docker volume for a repository - $ make contrib_volume f=<folder> - Example: $ make contrib_volume f=symfony

  contrib_link                  Link the Symfony monorepo to the project (replace vendors with symlinks) - $ make contrib_link f=<folder> - Example: $ make contrib_link f=symfony
  contrib_unlink                Restore original vendors (rollback links) - $ make contrib_unlink f=<folder> - Example: $ make contrib_unlink f=symfony

  contrib_install               Install Composer packages in a repository - $ make contrib_install f=<folder> - Example: $ make contrib_install f=symfony
  contrib_clean                 Remove vendor and lock file from a repository - $ make contrib_clean f=<folder> - Example: $ make contrib_clean f=symfony

  contrib_tests                 Run PHPUnit tests in a repository - $ make contrib_tests f=<folder> [a=<arguments>] - Example: $ make contrib_tests f=symfony a="src/Symfony/Bundle/FrameworkBundle"
  contrib_tests_www_data        Run PHPUnit tests as www-data user - $ make contrib_tests_www_data f=<folder> [a=<arguments>]
  contrib_tests_clean           Clean PHPUnit cache and temporary files - $ make contrib_tests_clean f=<folder> - Example: $ make contrib_tests_clean f=symfony

— GENERATE 🔨 ——————————————————————————————————————————————————————————————

  (to delete this section, delete make/generate.mk)

  clean_app                     Remove all fresh Symfony application files (var/, vendor/, ...)

  minimalist                    Generate a minimalist Symfony application with Docker configuration (stable release)
  minimalist@lts                Generate a minimalist Symfony application with Docker configuration (LTS - long-term support release)
  webapp                        Generate a webapp Symfony application (with PostgreSQL) with Docker configuration (stable release)
  webapp@lts                    Generate a webapp Symfony application (with PostgreSQL) with Docker configuration (LTS - long-term support release)

  api                           Generate an ApiPlatform application (with PostgreSQL) with Docker configuration
  api@lts                       Generate an ApiPlatform application (with PostgreSQL) with Docker configuration (LTS - long-term support release)
  demo                          Generate a Symfony Demo application (with SQLite) with Docker configuration
  easy_admin                    Generate an EasyAdmin application (with PostgreSQL) with Docker configuration
  easy_admin@lts                Generate an EasyAdmin application (with PostgreSQL) with Docker configuration (LTS - long-term support release)

  update_symfony_docker         Update the vendored dunglas/symfony-docker snapshot at the root
  skeleton                      Install symfony/skeleton from the versioned dunglas/symfony-docker files at the root
  clone_symfony_demo            Clone and extract https://github.com/symfony/demo files at the root

  COMPLETE INSTALLATION
  require_api                   Install API Platform - https://api-platform.com/docs/symfony/
  require_easy_admin            Install EasyAdmin Bundle - https://symfony.com/bundles/EasyAdminBundle/current/index.html
  require_stimulus              Install StimulusBundle - https://ux.symfony.com/
  require_webapp                Install a web application - https://symfony.com/doc/current/setup.html

  require_asset_mapper          Install AssetMapper - https://symfony.com/doc/current/frontend/asset_mapper.html
  require_maker_bundle          Install MakerBundle - https://symfony.com/bundles/SymfonyMakerBundle/current/index.html
  require_orm                   Install Doctrine (with PostgreSQL by default) - https://symfony.com/doc/current/doctrine.html
  require_profiler              Install Profiler - https://symfony.com/doc/current/profiler.html
  require_test_pack             Install PHPUnit - https://symfony.com/doc/current/testing.html
  require_translation           Install Translation - https://symfony.com/doc/current/translation.html

  require_phpcsfixer            Install PHP CS Fixer - https://github.com/PHP-CS-Fixer/PHP-CS-Fixer
  require_phpmd                 Install PHP Mess Detector - https://phpmd.org/
  require_phpmetrics            Install PHPMetrics - https://phpmetrics.github.io/website/
  require_phpstan               Install PHPStan - https://phpstan.org/
  require_twigcsfixer           Install Twig CS Fixer - https://github.com/VincentLanglet/Twig-CS-Fixer

  require_bootstrap             Install Bootstrap - https://getbootstrap.com/
  require_tailwind              Install Tailwind CSS - https://tailwindcss.com/

  health                        Check the website and database connection (via Doctrine) - $ make health [c=<status_code>] [t=<text>] - Example: $ make health c=404 t="Welcome to Symfony"

  DATABASE
  switch_to_mariadb             Switch the stack from PostgreSQL to MySQL/MariaDB
  switch_to_sqlite              Switch the stack from PostgreSQL to SQLite

  YQ
  yq                            Run yq, a lightweight and portable command-line YAML, JSON, INI and XML processor - $ make yq [a=<argument>] - Example: $ make yq a=--help
  yq_add                     ya Append a value to an array key in a YAML file - $ make yq_add f=<file> k=<key> v=<value> - Example: $ make yq_add f=compose.yaml k=services.php.extra_hosts v=host.docker.internal:host-gateway
  yq_clear                   yc Clear a key's value in a YAML file (sets it to empty string) - $ make yq_clear f=<file> k=<key> - Example: $ make yq_clear f=compose.yaml k=services.php.extra_hosts
  yq_delete                  yd Delete a key from a YAML file - $ make yq_delete f=<file> k=<key> - Example: $ make yq_delete f=compose.yaml k=services.php.extra_hosts
  yq_print                      Print contents of a file as idiomatic YAML with colors - $ make yq_print f=<file> - Example: $ make yq_print f=compose.yaml
  yq_update                  yu Set or update a key's value in a YAML file - $ make yq_update f=<file> - Example: $ make yq_add f=compose.yaml k=services.php.build.target v=frankenphp_prod
```

<!-- MAKEFILE_COMMANDS_END -->

---

[⬅️ README](README.md)

