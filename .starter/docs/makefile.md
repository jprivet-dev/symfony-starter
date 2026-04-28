# Makefile - Discover all commands

[⬅️ README](README.md)

---

This project uses a modular Makefile system. Commands are **loaded dynamically based on the components currently installed** in your project.

<!-- MAKEFILE_COMMANDS_START -->

```
Usage: make <target>
       make f=<find>

— 🐳 🎵 THE SYMFONY STARTER MAKEFILE 🎵 🐳 —————————————————————————————————
  help                                    Display this help message with available commands

  install                                 Start the project, install dependencies and show info
  info                                    Show project access info

  start                                   Start the project and show info (detached mode)
  stop                                    Stop the project (down)

  restart                                 [Level 1] Standard restart - Reloading containers (triggers: .env, compose.yaml, code changes)
  build_start                             [Level 2] Build & Start - Updating image with cache (triggers: composer.lock, CaddyFile, *.ini, entrypoint.sh)
  build_force_start                       [Level 3] Force build & Start - Rebuilding from scratch (triggers: Dockerfile, system packages, cache issues)

  check                                   Check everything before you deliver - Composer, Doctrine validation, linters, ... (no stop on failure)
  check_all                               Check everything before you deliver - check + tests (no stop on failure)
  check_push                              Check on git push (stop on failure)
  tests                                t  Run all tests

— DOCKER 🐳 ————————————————————————————————————————————————————————————————
  build [a=<args>]                        Build or rebuild Docker services using cache (e.g. make build a=--no-cache)
  build_force                             Build or rebuild Docker services without cache (force fresh install)

  up [a=<args>]                           Start the containers (e.g. make up a=-d)
  up_detached                             Start the containers (wait for services to be running|healthy - detached mode)

  down                                    Stop the containers
  kill                                    Remove containers and networks (keep database data)
  kill_all                                Remove containers, networks AND VOLUMES (database destroyed)
  deep_clean                              [Danger] Remove containers, volumes, networks and images, including orphans (triggers: webapp-pack, database, branch switch) [y/N]

  canonical                               Parse, resolve, and render compose file in canonical format
  images                                  List images used by the current containers
  logs                                    View logs (follow mode)

— SYMFONY 🎵 ———————————————————————————————————————————————————————————————
  symfony [c=<command>]                sf Run any Symfony console command (e.g. make symfony c=cache:clear)
  console [c=<command>]                   Symfony console alias (e.g. make console c=cache:clear)

  about                                   Display information about the current Symfony project
  cache_clear                          cc Clear the Symfony cache
  dotenv                                  Lists all .env files with variables and values
  dumpenv                                 Generate .env.local.php for production
  routes                                  Display current routes with assigned controllers and aliases

— PHP 🐘 ———————————————————————————————————————————————————————————————————
  php [a=<args>]                          Run PHP command (e.g. make php a=--version)

  php_command [a=<args>]                  Run a command inside the PHP container (e.g. make php_command a="ls -al")
  php_env                                 Display all environment variables set within the PHP container
  php_sh                               sh Connect to the PHP container shell

— COMPOSER 🧙 ——————————————————————————————————————————————————————————————
  composer [a=<args>]                     Run composer command (e.g. make composer a="require --dev phpunit/phpunit")
  composer_install                     i  Install Composer packages
  composer_validate                       Check if lock file is up to date (even when config.lock is false)

  config k=<key> [v=<value>]              Run composer config (e.g. make config k=repositories.monolog-bundle v='{"type": "path", "url": "/monolog-bundle"}')
  hash                                    Update only the content hash of composer.lock without updating dependencies
  outdated                                Show a list of installed packages that have updates available, including their latest version
  remove [a=<args>]                       Remove a package from the require or require-dev (e.g. make remove a="phpunit/phpunit")
  require [a=<args>]                      Add required packages to your composer.json and installs them (e.g. make require a="--dev phpunit/phpunit")
  update [a=<args>]                       Update Composer packages (e.g. make update a="symfony/monolog-bundle")

— DOCTRINE / SQL 💽 ————————————————————————————————————————————————————————
  db                                      Drop and create the database and migrate
  db@test                                 Drop and create the database and migrate (env=test)

  drop [a=<args>]                         Drop the database [y/N] (e.g. make drop a="--env=test")
  create [a=<args>]                       Create the database (e.g. make create a="--env=test")

  diff [a=<args>]                         Generate a migration by comparing your current database to your mapping information (format the generated SQL) (e.g. make diff a="--profile")
  execute a=<args>                        Execute one or more migration versions up or down manually (e.g. make execute a="DoctrineMigrations\Version20240205143239")
  generate                                Generate a blank migration class
  list                                    Display a list of all available migrations and their status
  migrate [a=<args>]                      Execute a migration to the latest available version (in a transaction) (e.g. make migrate a="current+3")
  migration [a=<args>]                    Create (via MakerBundle) a new migration based on database changes (format the generated SQL) (e.g. make migration a="--profile")

  fixtures [a=<args>]                     Load fixtures (CAUTION! The load command purges the database) (e.g. make fixtures a="--append")
  fixtures@test                           Load fixtures (env=test)
  sql [q=<query>]                         Execute the given SQL query and output the results (e.g. make sql q="SELECT * FROM user")
  update_dump                             Generate and output the SQL needed to synchronize the database schema with the current mapping metadata
  update_force                            Execute the generated SQL needed to synchronize the database schema with the current mapping metadata
  validate [a=<args>]                     Validate the mapping files (e.g. make validate a="--env=test")

  phpstorm_config                         Display database connection details for PhpStorm "Data Sources and Drivers" dialog

— POSTGRESQL 🛢️ ————————————————————————————————————————————————————————————
  psql [a=<args>]                         Execute psql (e.g. make psql a="-V")
  psql_sh                                 Open a shell on the PostgreSQL container
  table n=<name>                          Show the content of a table (e.g. make table n=user)
  tables                                  Show all tables

  dump                                    Create a SQL dump
  dump_gz                                 Create a compressed SQL dump (gzip)
  restore f=<file>                        Restore a dump (CAUTION! The command purges the database) [y/N] (e.g. make restore f="build/dumps/dump.sql")

— MYSQL 🛢️ —————————————————————————————————————————————————————————————————
  mysql [a=<args>]                        Execute mysql (e.g. make mysql a="-V")
  mysql_sh                                Open a shell on the MySQL/MariaDB container
  table n=<name>                          Show the content of a table (e.g. make table n=user)
  tables                                  Show all tables

  dump                                    Create a SQL dump
  dump_gz                                 Create a compressed SQL dump (gzip)
  restore f=<file>                        Restore a dump (CAUTION! The command purges the database) [y/N] (e.g. make restore f="build/dumps/dump.sql")

— SQLITE 🛢️ ————————————————————————————————————————————————————————————————
  sqlite [a=<args>]                       Execute sqlite3 (e.g. make sqlite a="-version")
  sqlite_sh                               Open a SQLite shell on the PHP container
  table n=<name>                          Show the content of a table (e.g. make table n=user)
  tables                                  Show all tables

  dump                                    Create a SQL dump
  dump_gz                                 Create a compressed SQL dump (gzip)
  restore f=<file>                        Restore a dump (CAUTION! The command purges the database) [y/N] (e.g. make restore f="build/dumps/dump.sql")

— MONOLOG 📝 ———————————————————————————————————————————————————————————————
  monolog                                 Export the Monolog current configuration (debug:config) to a YAML file
  monolog@prod                            Export the Monolog current configuration (debug:config) to a YAML file (PROD)
  monolog_default                         Export the Monolog default configuration (config:dump-reference) to a YAML file

— PHPUNIT ✅ ———————————————————————————————————————————————————————————————
  phpunit [a=<args>]                   p  Run PHPUnit (e.g. make phpunit a="tests/myTest.php")
  phpunit_log                             Exporting PHPUnit terminal output to a log file

  coverage [a=<args>]                     Generate code coverage report in HTML format (e.g. make coverage a="tests/myTest.php")
  dox [a=<args>]                          Report test execution progress in TestDox format (e.g. make dox a="tests/myTest.php")
  dox_html                                Report test execution progress in TestDox format and export it to an HTML file
  dox_text                                Report test execution progress in TestDox format and export it to a text file
  xdebug_version                          Xdebug version number

— QUALITY ✅ ———————————————————————————————————————————————————————————————
  fix                                     Fix with all linters
  lint                                    Run all linters (stop on failure)

  phpcsfixer [a=<args>]                   Run PHP CS Fixer (e.g. make phpcsfixer a=list)
  phpcsfixer_fix                          Fix code style
  phpcsfixer_lint                         Check code style

  phpmd [a=<args>]                        Run PHP Mess Detector (e.g. make phpmd a="src ansi cleancode")
  phpmd_lint                              Run PHP Mess Detector with all rules

  phpmetrics_report                       Run PHPMetrics and generate detailed report

  phpstan [a=<args>]                      Run PHPStan (e.g. make phpstan a="src tests")
  phpstan_baseline [a=<args>]             Generate PHPStan baseline (e.g. make phpstan_baseline a="src tests")
  phpstan_lint [a=<args>]                 Run PHPStan analyse (e.g. make phpstan_lint a="src tests")

  twigcsfixer [a=<args>]                  Run Twig CS Fixer (e.g. make twigcsfixer a="lint /path/to/code")
  twigcsfixer_fix                         Fix Twig style
  twigcsfixer_lint                        Check Twig style

— ASSETS 🎨‍ ————————————————————————————————————————————————————————————————
  assets                                  Generate all assets

  asset_map_clear                         Clear all assets in the public output directory
  asset_map_compile                       Compile all mapped assets and write them to the final public output directory
  asset_map_debug                         See all of the mapped assets

  importmap_audit                         Check for security vulnerability advisories for dependencies
  importmap_install                       Download all assets that should be downloaded
  importmap_outdated                      List outdated JavaScript packages and their latest versions
  importmap_remove                        Remove JavaScript packages
  importmap_require                       Require JavaScript packages
  importmap_update                        Update JavaScript packages to their latest versions

  tailwind_init                           Initializes Tailwind CSS for your project
  tailwind_clear                          Clear var/tailwind directory
  tailwind_build [a=<args>]               Build the Tailwind CSS assets (e.g. make tailwind_build a=--help)
  tailwind_watch                       w  Watch for changes and rebuild automatically.
  tailwind_minify                         Minify the output CSS.
  tailwind_debug                          See the full config from TailwindBundle

— TRANSLATION 🇬🇧 ———————————————————————————————————————————————————————————
  extract                                 Extract translation strings from templates

— CERTIFICATES 🔐‍️ ——————————————————————————————————————————————————————————
  certificates                            Install the Caddy TLS certificate to the trust store
  certificates_export                     Export the Caddy root certificate from the container to the host
  hosts                                   Add the server name to /etc/hosts file

— GIT 🐙 ———————————————————————————————————————————————————————————————————
  git_hooks_init                          Initialize the project's hooks directory (set GIT_HOOKS var)

  git_hooks_disable                       Disable the project's hooks directory
  git_hooks_enable                        Enable the project's hooks directory
  git_pre_push                            Actions on Git pre-push

— TROUBLESHOOTING 😵️ ———————————————————————————————————————————————————————
  permissions                             Fix file permissions (primarily for Linux hosts)
  safe                                    Add configured directories to Git's safe directories

— UTILITIES 🛠️ —————————————————————————————————————————————————————————————
  aliases                                 Show aliases info and loading instructions
  env_files                               Show env files loaded into this Makefile
  tree [l=<level>]                        Visualize your structure (requires `tree` command) (e.g. make tree l=1)
  vars                                    Show key Makefile variables

— SYMFONY CONTRIBUTION 🔗 ——————————————————————————————————————————————————

  (to delete this section, delete make/contrib.mk)

  contrib_dockerfile                      Inject PHP extensions required for contribution into Dockerfile (xsl, etc.)

  bundle_status d=<dir>                   Show current branch for reproducer and a local repository
  bundle_volume d=<dir>                   Add a Docker volume for a local repository (e.g. make bundle_volume d=symfony)
  bundle_add d=<dir>                      Register a path repository in composer.json (e.g. make bundle_add d=monolog-bundle)
  bundle_remove d=<dir>                   Unregister a path repository from composer.json (e.g. make bundle_remove d=monolog-bundle)
  bundle_install d=<dir>                  Install external dependencies used during the tests (e.g. make bundle_install d=symfony)
  bundle_clean d=<dir>                    Remove vendor and lock file from a local repository (e.g. make bundle_clean d=symfony)
  bundle_tests d=<dir> [a=<args>]         Run PHPUnit tests in a local repository (e.g. make bundle_tests d=symfony a=/symfony/src/Symfony/Bundle/FrameworkBundle)
  bundle_tests_clean d=<dir>              Clean PHPUnit cache and temporary files in a local repository (e.g. make bundle_tests_clean d=symfony)

  monorepo_volume                         Add a Docker volume for the Symfony monorepo
  monorepo_link                           Replace vendors with symlinks to the Symfony monorepo
  monorepo_unlink                         Restore original vendors (rollback symlinks to the Symfony monorepo)
  monorepo_install                        Install external dependencies used during the tests in the Symfony monorepo
  monorepo_clean                          Remove vendor and lock file from the Symfony monorepo
  monorepo_tests [a=<args>]               Run PHPUnit tests in the Symfony monorepo (e.g. make monorepo_tests a=/symfony/src/Symfony/Bundle/FrameworkBundle)
  monorepo_tests_clean                    Clean PHPUnit cache and temporary files in the Symfony monorepo

— GENERATE 🔨 ——————————————————————————————————————————————————————————————

  (to delete this section, delete make/generate.mk)

  clean_app                               Remove all fresh Symfony application files (var/, vendor/, ...)

  minimalist                              Generate a minimalist Symfony application with Docker configuration (stable release)
  minimalist@lts                          Generate a minimalist Symfony application with Docker configuration (LTS - long-term support release)
  webapp                                  Generate a webapp Symfony application (with PostgreSQL) with Docker configuration (stable release)
  webapp@lts                              Generate a webapp Symfony application (with PostgreSQL) with Docker configuration (LTS - long-term support release)

  api                                     Generate an ApiPlatform application (with PostgreSQL) with Docker configuration
  api@lts                                 Generate an ApiPlatform application (with PostgreSQL) with Docker configuration (LTS - long-term support release)
  demo                                    Generate a Symfony Demo application (with SQLite) with Docker configuration
  easy_admin                              Generate an EasyAdmin application (with PostgreSQL) with Docker configuration
  easy_admin@lts                          Generate an EasyAdmin application (with PostgreSQL) with Docker configuration (LTS - long-term support release)

  contrib                                 Generate a minimalist Symfony application with Docker configuration for contribution (stable release)
  contrib@lts                             Generate a minimalist Symfony application with Docker configuration for contribution (LTS - long-term support release)
  contrib@6x                              Generate a minimalist Symfony 6.x application with Docker configuration for contribution

  update_symfony_docker                   Update the vendored dunglas/symfony-docker snapshot at the root
  skeleton                                Install symfony/skeleton from the versioned dunglas/symfony-docker files at the root
  clone_symfony_demo                      Clone and extract https://github.com/symfony/demo files at the root

  COMPLETE INSTALLATION
  require_api                             Install API Platform - https://api-platform.com/docs/symfony/
  require_easy_admin                      Install EasyAdmin Bundle - https://symfony.com/bundles/EasyAdminBundle/current/index.html
  require_stimulus                        Install StimulusBundle - https://ux.symfony.com/
  require_webapp                          Install a web application - https://symfony.com/doc/current/setup.html

  require_asset_mapper                    Install AssetMapper - https://symfony.com/doc/current/frontend/asset_mapper.html
  require_maker_bundle                    Install MakerBundle - https://symfony.com/bundles/SymfonyMakerBundle/current/index.html
  require_orm                             Install Doctrine (with PostgreSQL by default) - https://symfony.com/doc/current/doctrine.html
  require_profiler                        Install Profiler - https://symfony.com/doc/current/profiler.html
  require_test_pack                       Install PHPUnit - https://symfony.com/doc/current/testing.html
  require_translation                     Install Translation - https://symfony.com/doc/current/translation.html

  require_phpcsfixer                      Install PHP CS Fixer - https://github.com/PHP-CS-Fixer/PHP-CS-Fixer
  require_phpmd                           Install PHP Mess Detector - https://phpmd.org/
  require_phpmetrics                      Install PHPMetrics - https://phpmetrics.github.io/website/
  require_phpstan                         Install PHPStan - https://phpstan.org/
  require_twigcsfixer                     Install Twig CS Fixer - https://github.com/VincentLanglet/Twig-CS-Fixer

  require_bootstrap                       Install Bootstrap - https://getbootstrap.com/
  require_tailwind                        Install Tailwind CSS - https://tailwindcss.com/

  health [c=<status_code>] [t=<text>]     Check the website and database connection (via Doctrine) (e.g. make health c=404 t="Welcome to Symfony")

  DATABASE
  switch_to_mariadb                       Switch the stack from PostgreSQL to MySQL/MariaDB
  switch_to_sqlite                        Switch the stack from PostgreSQL to SQLite

  YQ
  yq [a=<argument>]                       Run yq, a lightweight and portable command-line YAML, JSON, INI and XML processor (e.g. make yq a=--help)
  yq_add f=<file> k=<key> v=<value>    ya Append a value to an array key in a YAML file (e.g. make yq_add f=compose.yaml k=services.php.extra_hosts v=host.docker.internal:host-gateway)
  yq_clear f=<file> k=<key>            yc Clear a key's value in a YAML file (sets it to empty string) (e.g. make yq_clear f=compose.yaml k=services.php.extra_hosts)
  yq_delete f=<file> k=<key>           yd Delete a key from a YAML file (e.g. make yq_delete f=compose.yaml k=services.php.extra_hosts)
  yq_print f=<file>                       Print contents of a file as idiomatic YAML with colors (e.g. make yq_print f=compose.yaml)
  yq_update f=<file>                   yu Set or update a key's value in a YAML file (e.g. make yq_update f=compose.yaml k=services.php.build.target v=frankenphp_prod)
```

<!-- MAKEFILE_COMMANDS_END -->

---

[⬅️ README](README.md)

