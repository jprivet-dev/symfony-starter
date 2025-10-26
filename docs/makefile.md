# Makefile - Discover all commands

[⬅️ README](../README.md)

---

> Run `make` to see all

<!-- MAKEFILE_COMMANDS_START -->

```

— 🐳 🎵 THE SYMFONY STARTER MAKEFILE 🎵 🐳 —————————————————————————————————
  help                          Display this help message with available commands

— GENERATION 🔨 (CAN BE REMOVED AFTER SAVING THE PROJECT) ——————————————————
  minimalist                    Generate a minimalist Symfony application with Docker configuration (stable release)
  minimalist@lts                Generate a minimalist Symfony application with Docker configuration (LTS - long-term support release)

  clone_symfony_docker          Clone and extract https://github.com/dunglas/symfony-docker files at the root
  clone_symfony_demo            Clone and extract https://github.com/symfony/demo files at the root --- 🧪 EXPERIMENTAL 🧪 ---
  clear_all                     Remove all fresh Symfony application files

COMPLETE INSTALLATION
  require_doctrine              Install Doctrine - https://symfony.com/doc/current/doctrine.html
  require_phpunit               Install PHPUnit - https://symfony.com/doc/current/testing.html
  require_asset_mapper          Install AssetMapper - https://symfony.com/doc/current/frontend/asset_mapper.html
  require_translation           Install translation - https://symfony.com/doc/current/translation.html

  require_profiler              Install the profiler - https://symfony.com/doc/current/profiler.html
  require_maker_bundle          Install the MakerBundle - https://symfony.com/bundles/SymfonyMakerBundle/current/index.html
  require_bootstrap             Install Bootstrap - https://getbootstrap.com/
  require_stimulus              Install StimulusBundle - https://ux.symfony.com/

  require_phpcsfixer            Install PHP CS Fixer - https://github.com/PHP-CS-Fixer/PHP-CS-Fixer
  require_phpstan               Install PHPStan - https://phpstan.org/
  require_phpmd                 Install PHP Mess Detector - https://phpmd.org/
  require_twigcsfixer           Install Twig CS Fixer - https://github.com/VincentLanglet/Twig-CS-Fixer
  require_phpmetrics            Install PHPMetrics - https://phpmetrics.github.io/website/

  require_webapp                Install a web application - https://symfony.com/doc/current/setup.html
  require_api                   Install API Platform - https://api-platform.com/docs/symfony/
  require_easy_admin            Install EasyAdmin Bundle - https://symfony.com/bundles/EasyAdminBundle/current/index.html

— PROJECT 🚀 ———————————————————————————————————————————————————————————————
  start                         Start the project and show info (up_detached & info alias)
  stop                          Stop the project (down alias)
  restart                       Stop & Start the project and show info (up_detached & info alias)
  info                          Show project access info

  install                       Start the project, install dependencies and show info
  check                         Check everything before you deliver

— DOCKER 🐳 ————————————————————————————————————————————————————————————————
  up                            Start the containers - $ make up [ARG=<arguments>] - Example: $ make up ARG=-d
  up_detached                   Start the containers (wait for services to be running|healthy - detached mode)
  down                          Stop and remove the containers
  build                         Build or rebuild Docker services - $ make build [ARG=<arguments>] - Example: $ make build ARG=--no-cache
  build_force                   Build or rebuild Docker services (no cache) - $ make build [ARG=<arguments>]
  logs                          Display container logs
  images                        List images used by the current containers
  config                        Parse, resolve, and render compose file in canonical format

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
  db_init                       Drop and create the database and migrate

  validate                      Validate the mapping files - $ make validate [ARG=<arguments>] - Example: $ make validate ARG="--env=test"
  update_dump                   Generate and output the SQL needed to synchronize the database schema with the current mapping metadata
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
  coverage                      Generate code coverage report in HTML format - $ make coverage [ARG=<arguments>] - Example: $ make coverage ARG="tests/myTest.php"
  dox                           Report test execution progress in TestDox format - $ make dox [ARG=<arguments>] - Example: $ make dox ARG="tests/myTest.php"
  dox@text                      Report test execution progress in TestDox format and export it in text file
  dox@html                      Report test execution progress in TestDox format and export it in HTML file
  xdebug_version                Xdebug version number

— QUALITY ✅ ———————————————————————————————————————————————————————————————
  phpcsfixer                    Run PHP CS Fixer - $ make phpcsfixer [ARG=<arguments>] - Example: $ make phpcsfixer ARG=list
  phpcsfixer_lint               Check code style
  phpcsfixer_fix                Fix code style

  phpstan                       Run PHPStan - $ make phpstan [ARG=<arguments>] - Example: $ make phpstan ARG="src tests"
  phpstan_lint                  Run PHPStan analyse - $ make phpstan_analyse [ARG=<arguments>] - Example: $ make phpstan_analyse ARG="src tests"
  phpstan_baseline              Generate PHPStan baseline - $ make phpstan_baseline [ARG=<arguments>] - Example: $ make phpstan_baseline ARG="src tests"

  phpmd                         Run PHP Mess Detector - $ make phpmd [ARG=<arguments>] - Example: $ make phpmd ARG="src ansi cleancode"
  phpmd_lint                    Run PHP Mess Detector with all rules

  twigcsfixer                   Run Twig CS Fixer - $ make twigcsfixer [ARG=<arguments>] - Example: $ make twigcsfixer ARG="lint /path/to/code"
  twigcsfixer_lint              Check Twig style
  twigcsfixer_fix               Fix Twig style

  lint                          Run all linters (stop on failure)
  fix                           Fix with all linters

  phpmetrics_report             Run PHPMetrics and generate detailled report

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

— CERTIFICATES 🔐‍️ ——————————————————————————————————————————————————————————
  certificates                  Installs the Caddy TLS certificate to the trust store
  certificates_export           Exports the Caddy root certificate from the container to the host
  hosts                         Add the server name to /etc/hosts file

— GIT 🐙 ———————————————————————————————————————————————————————————————————
  git_hooks_on                  Enable the project's hooks directory
  git_hooks_off                 Disable the project's hooks directory
  git_pre_push                  Actions on Git pre-push

— TROUBLESHOOTING 😵️ ———————————————————————————————————————————————————————
  permissions                p  Fix file permissions (primarily for Linux hosts)
  safe                          Add /app to Git's safe directories within the php container

— UTILITIES 🛠️ —————————————————————————————————————————————————————————————
  env_files                     Show env files loaded into this Makefile
  vars                          Show key Makefile variables
```

<!-- MAKEFILE_COMMANDS_END -->

---

[⬅️ README](../README.md)

