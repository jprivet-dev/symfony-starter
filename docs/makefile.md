# Makefile - Discover all commands

[⬅️ README](../README.md)

---

> Run `make` (or `make help`) to see all

<!-- MAKEFILE_COMMANDS_START -->

```

— 🐳 🎵 THE SYMFONY STARTER MAKEFILE 🎵 🐳 —————————————————————————————————
  help                          Display this help message with available commands

— PROJECT 🚀 ———————————————————————————————————————————————————————————————
  install                       Start the project, install dependencies and show info
  info                          Show project access info

  restart                       Stop & Start the project and show info (detached mode)
  start                         Start the project and show info (detached mode)
  stop                          Stop the project (down)

  check_level_1              c1 Check everything before you deliver - Composer, Doctrine validation, linters (stop on failure)
  check_level_2              c2 Check everything before you deliver - Composer, Doctrine validation, linters, PHPUnit (stop on failure)
  tests                      t  Run all tests

— DOCKER 🐳 ————————————————————————————————————————————————————————————————
  build                         Build or rebuild Docker services - $ make build [a=<arguments>] - Example: $ make build a=--no-cache
  build_force                   Build or rebuild Docker services (no cache) - $ make build [a=<arguments>]
  down                          Stop and remove the containers
  up                            Start the containers - $ make up [a=<arguments>] - Example: $ make up a=-d
  up_detached                   Start the containers (wait for services to be running|healthy - detached mode)

  deep_clean                    Cleaning local containers, networks, volumes & images [y/N]

  config                        Parse, resolve, and render compose file in canonical format
  images                        List images used by the current containers
  logs                          View logs (follow mode)

— SYMFONY 🎵 ———————————————————————————————————————————————————————————————
  symfony                    sf Run any Symfony console command - $ make symfony [c=<command>]- Example: $ make symfony c=cache:clear

  about                         Display information about the current Symfony project
  cache_clear                cc Clear the Symfony cache
  dotenv                        Lists all .env files with variables and values
  dumpenv                       Generate .env.local.php for production
  routes                        Display current routes with assigned controllers and aliases

— PHP 🐘 ———————————————————————————————————————————————————————————————————
  php                           Run PHP command - $ make php [a=<arguments>]- Example: $ make php a=--version

  php_command                c  Run a command inside the PHP container - $ make php_command [a=<arguments>]- Example: $ make php_command a="ls -al"
  php_env                       Display all environment variables set within the PHP container
  php_sh                     sh Connect to the PHP container shell

— COMPOSER 🧙 ——————————————————————————————————————————————————————————————
  composer                      Run composer command - $ make composer [a=<arguments>] - Example: $ make composer a="require --dev phpunit/phpunit"
  composer_install           i  Install Composer packages
  composer_validate             Check if lock file is up to date (even when config.lock is false)

  outdated                      Show a list of installed packages that have updates available, including their latest version
  remove                        Remove a package from the require or require-dev - $ make remove [a=<arguments>] - Example: $ make remove a="phpunit/phpunit"
  require                       Add required packages to your composer.json and installs them - $ make require [a=<arguments>] - Example: $ make require a="--dev phpunit/phpunit"
  update                        Update Composer packages - $ make update [a=<arguments>] - Example: $ make update a="phpunit/phpunit"
  update_lock                   Update only the content hash of composer.lock without updating dependencies

— DOCTRINE / SQL 💽 ————————————————————————————————————————————————————————
  db_init                       Drop and create the database and migrate
  db_init@test                  Drop and create the database and migrate (env=test)

  db_drop                       Drop the database [y/N] - $ make db_drop [a=<arguments>] - Example: $ make db_drop a="--env=test"
  db_create                     Create the database - $ make db_create [a=<arguments>] - Example: $ make db_create a="--env=test"

  execute                       Execute one or more migration versions up or down manually - $ make execute a=<arguments> - Example: $ make execute a="DoctrineMigrations\Version20240205143239"
  generate                      Generate a blank migration class
  list                          Display a list of all available migrations and their status
  migrate                       Execute a migration to the latest available version (in a transaction) - $ make migrate [a=<param>] - Example: $ make migrate a="current+3"
  migration                     Create a new migration based on database changes (format the generated SQL)

  fixtures                      Load fixtures (CAUTION! The load command purges the database) - $ make fixtures [a=<param>] - Example: $ make fixtures a="--append"
  fixtures@test                 Load fixtures (env=test)
  sql                           Execute the given SQL query and output the results - $ make sql [q=<query>] - Example: $ make sql q="SELECT * FROM user"
  update_dump                   Generate and output the SQL needed to synchronize the database schema with the current mapping metadata
  update_force                  Execute the generated SQL needed to synchronize the database schema with the current mapping metadata
  validate                      Validate the mapping files - $ make validate [a=<arguments>] - Example: $ make validate a="--env=test"

— POSTGRESQL 🛢️ ————————————————————————————————————————————————————————————
  psql                          Execute psql - $ make psql [a=<arguments>] - Example: $ make psql a="-V"
  psql_sh                       Open a shell on the PostgreSQL container
  tables                        Show all tables

  dump                          Create a SQL dump
  dump_gz                       Create a compressed SQL dump (gzip)
  restore                       Restore a dump (CAUTION! The command purges the database) [y/N] - $ make restore f=<file> - Example: $ make restore f="build/dumps/dump.sql"

— TESTS ✅ —————————————————————————————————————————————————————————————————
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

— TRANSLATION 🇬🇧 ———————————————————————————————————————————————————————————
  extract                       Extract translation strings from templates

— CERTIFICATES 🔐‍️ ——————————————————————————————————————————————————————————
  certificates                  Install the Caddy TLS certificate to the trust store
  certificates_export           Export the Caddy root certificate from the container to the host
  hosts                         Add the server name to /etc/hosts file

— GIT 🐙 ———————————————————————————————————————————————————————————————————
  git_hooks_init                Initialize the project's hooks directory (set GIT_HOOKS var)

  git_hooks_disable             Disable the project's hooks directory
  git_hooks_enable              Enable the project's hooks directory
  git_pre_push                  Actions on Git pre-push

  git_apply                     Apply a patch to files and/or to the index - $ make git_apply f=<file> - Example: $ make git_apply f=file.patch
  git_patch                     Generate a patch from current diff or from hashes - $ make git_patch [h=<hashes>] - Example: $ make git_patch h="abcd123 efgh456"

— TROUBLESHOOTING 😵️ ———————————————————————————————————————————————————————
  permissions                   Fix file permissions (primarily for Linux hosts)
  safe                          Add /app to Git's safe directories within the php container

— UTILITIES 🛠️ —————————————————————————————————————————————————————————————
  aliases                       Show aliases info and loading instructions
  env_files                     Show env files loaded into this Makefile
  tree                          Visualize your structure (requires `tree` command) - $ make tree [l=<level>] - Example: $ make tree l=1
  vars                          Show key Makefile variables

  yq                            Run yq, a lightweight and portable command-line YAML, JSON, INI and XML processor - $ make yq [a=<argument>] - Example: $ make yq a=--help
  yq_print                      Print contents of a file as idiomatic YAML with colors - $ make yq_print f=<file> - Example: $ make yq_print f=compose.yaml

  yq_add                        Append a value to an array key in a YAML file - $ make yq_add f=<file> k=<key> v=<value> - Example: $ make yq_add f=compose.yaml k=.services.php.extra_hosts v=host.docker.internal:host-gateway
  yq_clear                      Clear a key's value in a YAML file (sets it to empty string) - $ make yq_clear f=<file> k=<key> - Example: $ make yq_clear f=compose.yaml k=.services.php.extra_hosts
  yq_delete                     Delete a key from a YAML file - $ make yq_delete f=<file> k=<key> - Example: $ make yq_delete f=compose.yaml k=.services.php.extra_hosts
  yq_update                     Set or update a key's value in a YAML file - $ make yq_update f=<file> - Example: $ make yq_add f=compose.yaml k=.services.php.build.target v=frankenphp_prod

— SYMFONY CONTRIBUTION 🔗 ——————————————————————————————————————————————————

  (to delete this section, delete .mk/contrib.mk)

  contrib_install               Install Composer packages in the local Symfony monorepo
  contrib_checkout              Switch App and Symfony monorepo branches - $ make contrib_checkout a=<app-branch> [s=<symfony-branch>] - Example: make contrib_checkout a=fix-123 s=fix-123-custom --- 🧪 EXPERIMENTAL 🧪 ---
  contrib_clean                 Remove vendor and lock file from the local Symfony monorepo

  contrib_tests                 Run PHPUnit tests in the local Symfony monorepo - $ make contrib_tests [a=<arguments>] - Example: $ make contrib_tests a="src/Symfony/Bundle/FrameworkBundle"
  contrib_tests_www_data        Run PHPUnit tests in the local Symfony monorepo as www-data user - $ make contrib_tests_www_data [a=<arguments>] - Example: $ make contrib_tests_www_data a="src/Symfony/Bundle/FrameworkBundle"
  contrib_tests_clean           Clean PHPUnit cache and temporary files in the local Symfony monorepo

  contrib_link                  Link local Symfony monorepo to the project (replace vendors with symlinks)
  contrib_unlink                Restore original vendors (rollback links)

— GENERATE 🔨 ——————————————————————————————————————————————————————————————

  (to delete this section, delete .mk/generate.mk)

  api                           Generate an ApiPlatform application (with PostgreSQL) with Docker configuration
  api@lts                       Generate an ApiPlatform application (with PostgreSQL) with Docker configuration (LTS - long-term support release)
  demo                          Generate a Symfony Demo application (with SQLite) with Docker configuration
  easy_admin                    Generate an EasyAdmin application (with PostgreSQL) with Docker configuration
  easy_admin@lts                Generate an EasyAdmin application (with PostgreSQL) with Docker configuration (LTS - long-term support release)
  minimalist                    Generate a minimalist Symfony application with Docker configuration (stable release)
  minimalist@lts                Generate a minimalist Symfony application with Docker configuration (LTS - long-term support release)
  webapp                        Generate a webapp Symfony application with Docker configuration (stable release)
  webapp@lts                    Generate a webapp Symfony application with Docker configuration (LTS - long-term support release)

  clone_symfony_docker          Clone and extract https://github.com/dunglas/symfony-docker files at the root
  clone_symfony_demo            Clone and extract https://github.com/symfony/demo files at the root
  kill_current_app              Remove all fresh Symfony application files

  COMPLETE INSTALLATION
  require_api                   Install API Platform - https://api-platform.com/docs/symfony/
  require_easy_admin            Install EasyAdmin Bundle - https://symfony.com/bundles/EasyAdminBundle/current/index.html
  require_stimulus              Install StimulusBundle - https://ux.symfony.com/
  require_webapp                Install a web application - https://symfony.com/doc/current/setup.html

  require_asset_mapper          Install AssetMapper - https://symfony.com/doc/current/frontend/asset_mapper.html
  require_bootstrap             Install Bootstrap - https://getbootstrap.com/
  require_maker_bundle          Install MakerBundle - https://symfony.com/bundles/SymfonyMakerBundle/current/index.html
  require_postgresql            Install Doctrine (PostgreSQL) - https://symfony.com/doc/current/doctrine.html
  require_profiler              Install Profiler - https://symfony.com/doc/current/profiler.html
  require_sqlite                Install Doctrine (SQLite) - https://symfony.com/doc/current/doctrine.html
  require_test_pack             Install PHPUnit - https://symfony.com/doc/current/testing.html
  require_translation           Install Translation - https://symfony.com/doc/current/translation.html

  require_phpcsfixer            Install PHP CS Fixer - https://github.com/PHP-CS-Fixer/PHP-CS-Fixer
  require_phpmd                 Install PHP Mess Detector - https://phpmd.org/
  require_phpmetrics            Install PHPMetrics - https://phpmetrics.github.io/website/
  require_phpstan               Install PHPStan - https://phpstan.org/
  require_twigcsfixer           Install Twig CS Fixer - https://github.com/VincentLanglet/Twig-CS-Fixer
```

<!-- MAKEFILE_COMMANDS_END -->

---

[⬅️ README](../README.md)

