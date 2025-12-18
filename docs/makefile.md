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
  minimalist_lts                Generate a minimalist Symfony application with Docker configuration (LTS - long-term support release)

  clone_symfony_docker          Clone and extract https://github.com/dunglas/symfony-docker files at the root
  clone_symfony_demo            Clone and extract https://github.com/symfony/demo files at the root --- 🧪 EXPERIMENTAL 🧪 ---
  remove_all                    Remove all fresh Symfony application files

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
  install                       Start the project, install dependencies and show info

  start                         Start the project and show info (up_detached & info alias command)
  stop                          Stop the project (down alias command)
  restart                       Stop & Start the project and show info (up_detached & info alias command)
  info                          Show project access info

  check_level_1              c1 Check everything before you deliver - Composer, Doctrine validation, linters (stop on failure)
  check_level_2              c2 Check everything before you deliver - Composer, Doctrine validation, linters, PHPUnit (stop on failure)

— DOCKER 🐳 ————————————————————————————————————————————————————————————————
  up                            Start the containers - $ make up [a=<arguments>] - Example: $ make up a=-d
  up_detached                   Start the containers (wait for services to be running|healthy - detached mode)
  down                          Stop and remove the containers
  build                         Build or rebuild Docker services - $ make build [a=<arguments>] - Example: $ make build a=--no-cache
  build_force                   Build or rebuild Docker services (no cache) - $ make build [a=<arguments>]
  logs                          View logs (follow mode)
  clean                         Clean everything (containers, networks, images)
  config                        Parse, resolve, and render compose file in canonical format
  images                        List images used by the current containers

— SYMFONY 🎵 ———————————————————————————————————————————————————————————————
  symfony                    sf Run Symfony console command - $ make symfony [a=<arguments>]- Example: $ make symfony a=cache:clear
  cc                            Clear the Symfony cache
  about                         Display information about the current Symfony project
  routes                        Display current routes with assigned controllers and aliases

  dotenv                        Lists all .env files with variables and values
  dumpenv                       Generate .env.local.php for production

— PHP 🐘 ———————————————————————————————————————————————————————————————————
  php                           Run PHP command - $ make php [a=<arguments>]- Example: $ make php a=--version

  php_sh                     sh Connect to the PHP container shell
  php_env                       Display all environment variables set within the PHP container
  php_command                   Run a command inside the PHP container - $ make php_command [a=<arguments>]- Example: $ make php_command a="ls -al"

— COMPOSER 🧙 ——————————————————————————————————————————————————————————————
  composer                      Run composer command - $ make composer [a=<arguments>] - Example: $ make composer a="require --dev phpunit/phpunit"
  composer_install              Install Composer packages
  composer_update               Update Composer packages
  composer_update_lock          Update only the content hash of composer.lock without updating dependencies
  composer_validate             Check if lock file is up to date (even when config.lock is false)

— DOCTRINE & SQL 💽 ————————————————————————————————————————————————————————
  db_drop                       Drop the database - $ make db_drop [a=<arguments>] - Example: $ make db_drop a="--env=test"
  db_create                     Create the database - $ make db_create [a=<arguments>] - Example: $ make db_create a="--env=test"
  db_init                       Drop and create the database and migrate

  validate                      Validate the mapping files - $ make validate [a=<arguments>] - Example: $ make validate a="--env=test"
  update_dump                   Generate and output the SQL needed to synchronize the database schema with the current mapping metadata
  update_force                  Execute the generated SQL needed to synchronize the database schema with the current mapping metadata

  migration                     Create a new migration based on database changes (format the generated SQL)
  migrate                       Execute a migration to the latest available version (in a transaction) - $ make migrate [a=<param>] - Example: $ make migrate a="current+3"
  list                          Display a list of all available migrations and their status
  execute                       Execute one or more migration versions up or down manually - $ make execute a=<arguments> - Example: $ make execute a="DoctrineMigrations\Version20240205143239"
  generate                      Generate a blank migration class

  sql                           Execute the given SQL query and output the results - $ make sql [q=<query>] - Example: $ make sql q="SELECT * FROM user"
  fixtures                      Load fixtures (CAUTION! The load command purges the database) - $ make fixtures [a=<param>] - Example: $ make fixtures a="--append"

— POSTGRESQL 💽 ————————————————————————————————————————————————————————————
  psql                          Execute psql - $ make psql [a=<arguments>] - Example: $ make psql a="-V"
  psql_sh                       Open a shell on the PostgreSQL container
  tables                        Show all tables

  dump                          Create a SQL dump
  dump_gz                       Create a compressed SQL dump (gzip)
  restore                       Restore a dump (CAUTION! The command purges the database) - $ make restore f=<file> - Example: $ make restore f="build/dumps/dump.sql"

— TESTS ✅ —————————————————————————————————————————————————————————————————
  phpunit                       Run PHPUnit - $ make phpunit [a=<arguments>] - Example: $ make phpunit a="tests/myTest.php"
  phpunit_log                   Exporting PHPUnit terminal output to a log file
  coverage                      Generate code coverage report in HTML format - $ make coverage [a=<arguments>] - Example: $ make coverage a="tests/myTest.php"
  dox                           Report test execution progress in TestDox format - $ make dox [a=<arguments>] - Example: $ make dox a="tests/myTest.php"
  dox_text                      Report test execution progress in TestDox format and export it in text file
  dox_html                      Report test execution progress in TestDox format and export it in HTML file
  xdebug_version                Xdebug version number

— QUALITY ✅ ———————————————————————————————————————————————————————————————
  phpcsfixer                    Run PHP CS Fixer - $ make phpcsfixer [a=<arguments>] - Example: $ make phpcsfixer a=list
  phpcsfixer_lint               Check code style
  phpcsfixer_fix                Fix code style

  phpstan                       Run PHPStan - $ make phpstan [a=<arguments>] - Example: $ make phpstan a="src tests"
  phpstan_lint                  Run PHPStan analyse - $ make phpstan_analyse [a=<arguments>] - Example: $ make phpstan_analyse a="src tests"
  phpstan_baseline              Generate PHPStan baseline - $ make phpstan_baseline [a=<arguments>] - Example: $ make phpstan_baseline a="src tests"

  phpmd                         Run PHP Mess Detector - $ make phpmd [a=<arguments>] - Example: $ make phpmd a="src ansi cleancode"
  phpmd_lint                    Run PHP Mess Detector with all rules

  twigcsfixer                   Run Twig CS Fixer - $ make twigcsfixer [a=<arguments>] - Example: $ make twigcsfixer a="lint /path/to/code"
  twigcsfixer_lint              Check Twig style
  twigcsfixer_fix               Fix Twig style

  lint                          Run all linters (stop on failure)
  fix                           Fix with all linters

  phpmetrics_report             Run PHPMetrics and generate detailed report

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
  git_hooks_init                Init the project's hooks directory (set GIT_HOOKS var)
  git_hooks_enable              Enable the project's hooks directory
  git_hooks_disable             Disable the project's hooks directory
  git_pre_push                  Actions on Git pre-push

— TROUBLESHOOTING 😵️ ———————————————————————————————————————————————————————
  permissions                p  Fix file permissions (primarily for Linux hosts)
  safe                          Add /app to Git's safe directories within the php container

— UTILITIES 🛠️ —————————————————————————————————————————————————————————————
  env_files                     Show env files loaded into this Makefile
  vars                          Show key Makefile variables
  tree                          Visualize your structure (requires `tree` command) - $ make tree [l=<level>] - Example: $ make tree l=1
```

<!-- MAKEFILE_COMMANDS_END -->

---

[⬅️ README](../README.md)

