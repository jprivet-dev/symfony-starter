#
# COLORS
#

# (G)REEN, (R)ED, (Y)ELLOW & RE(S)ET
G = "\\033[32m"
R = "\\033[31m"
Y = "\\033[33m"
S = "\\033[0m"

#
# USER
#

USER_ID  = $(shell id -u)
GROUP_ID = $(shell id -g)
USER     = $(USER_ID):$(GROUP_ID)

#
# OS DETECTION
#

UNAME_S := $(shell uname -s)

#
# SYMFONY ENVIRONMENT VARIABLES
#

# Files are loaded in order of increasing priority. For more details, refer to:
# - https://github.com/jprivet-dev/makefiles/tree/main/symfony-env-include
# - https://www.gnu.org/software/make/manual/html_node/Environment.html
# - https://github.com/symfony/recipes/issues/18
# - https://symfony.com/doc/current/quick_tour/the_architecture.html#environment-variables
# - https://symfony.com/doc/current/configuration.html#listing-environment-variables
# - https://symfony.com/doc/current/configuration.html#overriding-environment-values-via-env-local
-include .env
-include .env.local
-include .env.$(APP_ENV)
-include .env.$(APP_ENV).local

ifeq ($(APP_ENV),prod)
$(warning [WARNING] You are in the PROD environment)
endif

# See https://symfony.com/doc/current/deployment.html#b-configure-your-environment-variables
ifneq ($(wildcard .env.local.php),)
$(warning [WARNING] In this Makefile it is not possible to use variables from .env.local.php file)
endif

#
# GENERATION
#

# "GENERATION" BLOCK CAN BE REMOVED AFTER SAVING THE PROJECT.
# These variables are only used for the initial setup.

# Symfony 6.* is the current long-term support version.
# Released on          : November 2023
# End of bug fixes     : November 2026
# End of security fixes: November 2027
# See https://symfony.com/releases
SYMFONY_LTS_VERSION       = 6.*
REPOSITORY_SYMFONY_DOCKER = git@github.com:dunglas/symfony-docker.git
REPOSITORY_SYMFONY_DEMO   = git@github.com:symfony/demo.git
CLONE_DIR                 = clone

#
# FILES & DIRECTORIES
#

PWD       = $(shell pwd)
SRC       = src
TEMPLATES = templates
TESTS     = tests

BIN_CONSOLE        = bin/console
BIN_PHPUNIT        = bin/phpunit
COMPOSER_JSON      = composer.json
DOCKERFILE         = Dockerfile
VENDOR_API         = vendor/api-platform
VENDOR_ASSETS      = vendor/symfony/asset-mapper
VENDOR_DOCTRINE    = vendor/doctrine
VENDOR_MAILER      = vendor/symfony/mailer
VENDOR_PHPCSFIXER  = vendor/bin/php-cs-fixer
VENDOR_PHPMD       = vendor/bin/phpmd
VENDOR_PHPMETRICS  = vendor/bin/phpmetrics
VENDOR_PHPSTAN     = vendor/bin/phpstan
VENDOR_PROFILER    = vendor/symfony/web-profiler-bundle
VENDOR_TRANSLATION = vendor/symfony/translation
VENDOR_TWIGCSFIXER = vendor/bin/twig-cs-fixer

#
# COMPONENTS CONFIG
#

NOW              := $(shell date +%Y%m%d-%H%M%S-%3N)
BUILD_DIR         = build
COVERAGE_DIR      = $(BUILD_DIR)/coverage-$(NOW)
COVERAGE_INDEX    = $(PWD)/$(COVERAGE_DIR)/index.html
TESTDOX_TEXT      = $(BUILD_DIR)/testdox-$(NOW).txt
TESTDOX_TEXT_PATH = $(PWD)/$(TESTDOX_TEXT)
TESTDOX_HTML      = $(BUILD_DIR)/testdox-$(NOW).html
TESTDOX_HTML_PATH = $(PWD)/$(TESTDOX_HTML)
PHPSTAN_CONFIG    = phpstan.dist.neon
PHPSTAN_BASELINE  = phpstan-baseline.php
PHPCSFIXER_CONFIG = .php-cs-fixer.dist.php
PHPMETRICS_DIR    = $(BUILD_DIR)/phpmetrics-$(NOW)
PHPMETRICS_INDEX  = $(PWD)/$(PHPMETRICS_DIR)/index.html

#
# DOCKER OPTIONS
# See https://github.com/dunglas/symfony-docker/blob/main/docs/options.md
#

PROJECT_NAME  ?= $(shell basename $(CURDIR) | tr '[:upper:]' '[:lower:]')
SERVER_NAME    = $(PROJECT_NAME).localhost
IMAGES_PREFIX  = $(PROJECT_NAME)-

HTTP_PORT     ?= 8080
HTTPS_PORT    ?= 8443
HTTP3_PORT    ?= $(HTTPS_PORT)
DATABASE_PORT ?= 5432

# Will be ":PORT" if HTTP_PORT is defined, otherwise empty.
HTTP_PORT_SUFFIX  = $(if $(HTTP_PORT),:$(HTTP_PORT))
# Will be ":PORT" if HTTPS_PORT is defined and not 443, otherwise empty.
HTTPS_PORT_SUFFIX = $(if $(HTTPS_PORT),$(if $(filter-out 443,$(HTTPS_PORT)),:$(HTTPS_PORT)))

UP_ENV ?=

define append
  ifneq ($($1),)
    UP_ENV += $1=$($1)
  endif
endef

$(eval $(call append,APP_ENV))
$(eval $(call append,XDEBUG_MODE))
$(eval $(call append,SERVER_NAME))
$(eval $(call append,IMAGES_PREFIX))
$(eval $(call append,SYMFONY_VERSION))
$(eval $(call append,STABILITY))
$(eval $(call append,HTTP_PORT))
$(eval $(call append,HTTPS_PORT))
$(eval $(call append,HTTP3_PORT))

ifneq ($(DATABASE_URL),)
$(eval $(call append,DATABASE_URL))
$(eval $(call append,DATABASE_PORT))
endif

#
# DOCKER COMMANDS
#

COMPOSE_V2 := $(shell docker compose version 2> /dev/null)

ifndef COMPOSE_V2
$(warning [WARNING] Docker Compose CLI plugin is required but is not available on your system)
endif

COMPOSE = docker compose

# In a first step, you can test the application's production behavior in a development environment by setting APP_ENV=prod.
# To test the full Docker production setup (e.g., optimized images, production-specific configurations), you can also add USE_COMPOSE_PROD_YAML=true.
# This allows for a smooth transition from testing the code's behavior to testing the full Docker infrastructure.
ifeq ($(USE_COMPOSE_PROD_YAML),prod)
ifeq ($(APP_ENV),prod)
COMPOSE = docker compose -f compose.yaml -f compose.prod.yaml
endif
endif

# -T : avoid "the input device is not a TTY" error - Example: $ NO_TTY=true make my_command
NO_TTY ?= false
ifeq ($(NO_TTY), true)
EXEC = $(COMPOSE) exec -T
else
EXEC = $(COMPOSE) exec
endif

CONTAINER_PHP          = $(EXEC) $(DOCKER_EXEC_ENV) php
CONTAINER_PHP_COVERAGE = $(EXEC) -e XDEBUG_MODE=coverage $(DOCKER_EXEC_ENV) php

PHP              = $(CONTAINER_PHP) php
COMPOSER         = $(CONTAINER_PHP) composer
BASH_COMMAND     = $(CONTAINER_PHP) bash -c
CONSOLE          = $(CONTAINER_PHP) $(BIN_CONSOLE)
PHPUNIT          = $(CONTAINER_PHP) $(BIN_PHPUNIT)
PHPUNIT_COVERAGE = $(CONTAINER_PHP_COVERAGE) $(BIN_PHPUNIT)

PHPCSFIXER       = $(PHP) $(VENDOR_PHPCSFIXER)
PHPSTAN          = $(PHP) $(VENDOR_PHPSTAN)
PHPMD            = $(PHP) -d error_reporting="E_ALL & ~E_DEPRECATED" $(VENDOR_PHPMD)
TWIGCSFIXER      = $(PHP) $(VENDOR_TWIGCSFIXER)
PHPMETRICS       = $(PHP) $(VENDOR_PHPMETRICS)

#
# EXTENDS THE MAIN MAKEFILE WITH YOUR OWN LOCAL MAKEFILE
#

ifeq ($(APP_ENV),dev)
-include .mk/local.mk
endif

## — 🐳 🎵 THE SYMFONY STARTER MAKEFILE 🎵 🐳 —————————————————————————————————

# Print self-documented Makefile:
# $ make
# $ make help

.DEFAULT_GOAL = help
.PHONY: help
help: ## Display this help message with available commands
	@grep -E '(^[.a-zA-Z_-]+[^:]+:.*##.*?$$)|(^#{2})' Makefile | awk 'BEGIN {FS = "## "}; { \
		split($$1, line, ":"); targets=line[1]; description=$$2; \
		if (targets == "##") { printf "\033[33m%s\n", ""; } \
		else if (targets == "" && description != "") { printf "\033[33m\n%s\n", description; } \
		else if (targets != "" && description != "") { split(targets, parts, " "); target=parts[1]; alias=parts[2]; printf "\033[32m  %-26s \033[34m%-2s \033[0m%s\n", target, alias, description; } \
	}'
	@echo

## — GENERATION 🔨 ————————————————————————————————————————————————————————————

# "GENERATION" BLOCK CAN BE REMOVED AFTER SAVING THE PROJECT.
# These following targets are only used for the initial setup.

.PHONY: minimalist
minimalist: clone_symfony_docker build up_detached permissions ## Generate a minimalist Symfony application with Docker configuration (stable release)
	$(MAKE) restart

minimalist@lts: ## Generate a minimalist Symfony application with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION) $(MAKE) minimalist

##

clone_symfony_docker: ## Clone and extract https://github.com/dunglas/symfony-docker files at the root
	@printf "\n$(Y)Clone https://github.com/dunglas/symfony-docker$(S)"
	@printf "\n$(Y)-----------------------------------------------$(S)\n\n"
ifeq ($(wildcard $(DOCKERFILE)),)
	@printf "Repository: $(Y)$(REPOSITORY_SYMFONY_DOCKER)$(S)\n"
	git clone $(REPOSITORY_SYMFONY_DOCKER) $(CLONE_DIR) --depth 1
	@printf "\n$(Y)Extract https://github.com/dunglas/symfony-docker at the root$(S)"
	@printf "\n$(Y)-------------------------------------------------------------$(S)\n\n"
	rsync -av --exclude=".editorconfig" --exclude=".git" --exclude=".gitattributes" --exclude=".github" --exclude="docs" --exclude="LICENSE" --exclude="README.md" $(CLONE_DIR)/ .
	rm -rf $(CLONE_DIR)
	@if [ -f LICENSE ]; then \
		git restore LICENSE; \
	fi
	@printf " $(G)✔$(S) https://github.com/dunglas/symfony-docker cloned and extracted at the root.\n\n"
else
	@printf " $(G)✔$(S) https://github.com/dunglas/symfony-docker files already present at the root.\n\n"
endif

clone_symfony_demo: ## Clone and extract https://github.com/symfony/demo files at the root --- 🧪 EXPERIMENTAL 🧪 ---
	@printf "\n$(Y)Clone https://github.com/symfony/demo$(S)"
	@printf "\n$(Y)-------------------------------------$(S)\n\n"
ifeq ($(wildcard .env.local.demo),)
	@printf "Repository: $(Y)$(REPOSITORY_SYMFONY_DEMO)$(S)\n"
	git clone $(REPOSITORY_SYMFONY_DEMO) $(CLONE_DIR) --depth 1
	@printf "\n$(Y)Extract https://github.com/symfony/demo at the root$(S)"
	@printf "\n$(Y)---------------------------------------------------$(S)\n\n"
	rsync -av --exclude=".editorconfig" --exclude=".git" --exclude=".gitattributes" --exclude=".github" --exclude="docs" --exclude="LICENSE" --exclude="README.md" $(CLONE_DIR)/ .
	rm -rf $(CLONE_DIR)
	@if [ -f LICENSE ]; then \
		git restore LICENSE; \
	fi
	@printf " $(G)✔$(S) https://github.com/symfony/demo cloned and extracted at the root.\n\n"
else
	@printf " $(G)✔$(S) https://github.com/symfony/demo files already present at the root.\n\n"
endif

clear_all: ## Remove all fresh Symfony application files
	-$(MAKE) permissions down
	git reset --hard
	git clean -f -d

## COMPLETE INSTALLATION

require_doctrine: ## Install Doctrine - https://symfony.com/doc/current/doctrine.html
	$(COMPOSER) require symfony/orm-pack
	$(MAKE) restart

require_phpunit: ## Install PHPUnit - https://symfony.com/doc/current/testing.html
	$(COMPOSER) require --dev symfony/test-pack

require_asset_mapper: ## Install AssetMapper - https://symfony.com/doc/current/frontend/asset_mapper.html
	$(COMPOSER) require symfony/asset-mapper symfony/asset symfony/twig-pack

require_translation: ## Install translation - https://symfony.com/doc/current/translation.html
	$(COMPOSER) require symfony/translation

##

require_profiler: ## Install the profiler - https://symfony.com/doc/current/profiler.html
	$(COMPOSER) require --dev symfony/profiler-pack

require_maker_bundle: ## Install the MakerBundle - https://symfony.com/bundles/SymfonyMakerBundle/current/index.html
	$(COMPOSER) require --dev symfony/maker-bundle

require_bootstrap: require_asset_mapper ## Install Bootstrap - https://getbootstrap.com/
	$(CONSOLE) importmap:require bootstrap

require_stimulus: ## Install StimulusBundle - https://ux.symfony.com/
	$(COMPOSER) require symfony/asset-mapper symfony/stimulus-bundle

##

require_phpcsfixer: ## Install PHP CS Fixer - https://github.com/PHP-CS-Fixer/PHP-CS-Fixer
	$(COMPOSER) require --dev friendsofphp/php-cs-fixer

require_phpstan: ## Install PHPStan - https://phpstan.org/
	$(COMPOSER) require --dev \
		phpstan/phpstan \
		phpstan/phpstan-symfony \
		phpstan/phpstan-doctrine \
		phpstan/phpstan-phpunit

require_phpmd: ## Install PHP Mess Detector - https://phpmd.org/
	$(COMPOSER) require --dev phpmd/phpmd

require_twigcsfixer: ## Install Twig CS Fixer - https://github.com/VincentLanglet/Twig-CS-Fixer
	$(COMPOSER) require --dev vincentlanglet/twig-cs-fixer

require_phpmetrics: ## Install PHPMetrics - https://phpmetrics.github.io/website/
	$(COMPOSER) require --dev phpmetrics/phpmetrics

##

require_webapp: ## Install a web application - https://symfony.com/doc/current/setup.html
	# Use "symfony/webapp-pack" instead of "webapp" to avoid "Could not find package webapp."
	$(COMPOSER) require symfony/webapp-pack
	$(MAKE) restart

require_api: ## Install API Platform - https://api-platform.com/docs/symfony/
	$(COMPOSER) require api
	$(MAKE) restart

require_easy_admin: ## Install EasyAdmin Bundle - https://symfony.com/bundles/EasyAdminBundle/current/index.html
	$(COMPOSER) require easycorp/easyadmin-bundle
	$(MAKE) restart

## — PROJECT 🚀 ———————————————————————————————————————————————————————————————

.PHONY: start
start: up_detached images info ## Start the project and show info (up_detached & info alias)

.PHONY: stop
stop: down ## Stop the project (down alias)

.PHONY: restart
restart: stop start ## Stop & Start the project and show info (up_detached & info alias)

.PHONY: info
info: ## Show project access info
	@printf "\n$(Y)Info$(S)"
	@printf "\n$(Y)----$(S)\n\n"
	@printf " $(Y)›$(S) Run $(Y). aliases$(S) or $(Y)source aliases$(S) to create bash aliases for main make commands ($(G)symfony$(S), $(G)php$(S), $(G)composer$(S), ...)\n"
	@printf " $(Y)›$(S) Go in your favourite browser and accept the auto-generated TLS certificate:\n"
	@printf "    - Homepage ....... $(G)https://$(SERVER_NAME)$(HTTPS_PORT_SUFFIX)/$(S)\n"
ifneq ($(wildcard $(VENDOR_API)),)
	@printf "    - API ............ $(G)https://$(SERVER_NAME)$(HTTPS_PORT_SUFFIX)/api$(S)\n"
endif
ifneq ($(wildcard $(VENDOR_PROFILER)),)
	@printf "    - Profiler ....... $(G)https://$(SERVER_NAME)$(HTTPS_PORT_SUFFIX)/_profiler$(S)\n"
endif
ifneq ($(wildcard $(VENDOR_MAILER)),)
	@printf "    - Mail Catcher ... $(G)http://$(SERVER_NAME):8025/$(S)\n"
endif
	@printf "\n"

##

.PHONY: install
install: up_detached ## Start the project, install dependencies and show info
	$(MAKE) composer_install
	-$(MAKE) assets
	$(MAKE) images
	$(MAKE) git_hooks_install
	$(MAKE) info

.PHONY: check
check: ## Check everything before you deliver
	-$(MAKE) composer_validate
	-$(MAKE) validate
	-$(MAKE) lint
	-$(MAKE) phpunit

check@stop_on_failure: composer_validate validate lint phpunit

## — SYMFONY 🎵 ———————————————————————————————————————————————————————————————

.PHONY: symfony
symfony sf: ## Run Symfony console command - $ make symfony [ARG=<arguments>]- Example: $ make symfony ARG=cache:clear
	$(CONSOLE) $(ARG)

.PHONY: cc
cc: ## Clear the Symfony cache
	$(CONSOLE) cache:clear

.PHONY: about
about: ## Display information about the current Symfony project
	$(CONSOLE) about

.PHONY: routes
routes: ## Display current routes with assigned controllers and aliases
	$(CONSOLE) debug:route --show-controllers --show-aliases

##

.PHONY: dotenv
dotenv: ## Lists all .env files with variables and values
	$(CONSOLE) debug:dotenv

.PHONY: dumpenv
dumpenv: ## Generate .env.local.php for production
	$(COMPOSER) dump-env prod

## — PHP 🐘 ———————————————————————————————————————————————————————————————————

.PHONY: php
php: ## Run PHP command - $ make php [ARG=<arguments>]- Example: $ make php ARG=--version
	$(PHP) $(ARG)

##

php_sh: ## Connect to the PHP container shell
	$(CONTAINER_PHP) sh

php_env: ## Display all environment variables set within the PHP container
	$(CONTAINER_PHP) env

.PHONY: php_command
php_command: ## Run a command inside the PHP container - $ make php_command [ARG=<arguments>]- Example: $ make php_command ARG="ls -al"
	$(BASH_COMMAND) "$(ARG)"

## — COMPOSER 🧙 ——————————————————————————————————————————————————————————————

.PHONY: composer
composer: ## Run composer command - $ make composer [ARG=<arguments>] - Example: $ make composer ARG="require --dev phpunit/phpunit"
	$(COMPOSER) $(ARG)

composer_install: ## Install Composer packages
ifeq ($(APP_ENV),prod)
	$(COMPOSER) install --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader
else
	$(COMPOSER) install
endif

composer_update: ## Update Composer packages
ifeq ($(APP_ENV),prod)
	$(COMPOSER) update --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader
else
	$(COMPOSER) update
endif

composer_update_lock: ## Update only the content hash of composer.lock without updating dependencies
	$(COMPOSER) update --lock

composer_validate: ## Check if lock file is up to date (even when config.lock is false)
	$(COMPOSER) validate --strict

## — DOCTRINE & SQL 💽 ————————————————————————————————————————————————————————

_doctrine:
ifeq ($(wildcard $(VENDOR_DOCTRINE)),)
	@printf " $(R)⨯$(S) $(Y)DOCTRINE & SQL 💽$(S): remove that block or install $(Y)Doctrine$(S) with $(G)make require_doctrine$(S)\n"
	@exit 1
endif

db_drop: _doctrine ## Drop the database - $ make db_drop [ARG=<arguments>] - Example: $ make db_drop ARG="--env=test"
	$(CONSOLE) doctrine:database:drop --if-exists --force $(ARG)

db_create: _doctrine ## Create the database - $ make db_create [ARG=<arguments>] - Example: $ make db_create ARG="--env=test"
	$(CONSOLE) doctrine:database:create --if-not-exists $(ARG)

db_init: _doctrine db_drop db_create migrate ## Drop and create the database and migrate

##

.PHONY: validate
validate: _doctrine ## Validate the mapping files - $ make validate [ARG=<arguments>] - Example: $ make validate ARG="--env=test"
	$(CONSOLE) doctrine:schema:validate -v $(ARG)

update_dump: _doctrine ## Generate and output the SQL needed to synchronize the database schema with the current mapping metadata
	$(CONSOLE) doctrine:schema:update --dump-sql

update_force: _doctrine ## Execute the generated SQL needed to synchronize the database schema with the current mapping metadata
	$(CONSOLE) doctrine:schema:update --force

##

.PHONY: migration
migration: ## Create a new migration based on database changes (format the generated SQL)
	$(CONSOLE) make:migration --formatted -v $(ARG)

.PHONY: migrate
migrate: _doctrine ## Execute a migration to the latest available version (in a transaction) - $ make migrate [ARG=<param>] - Example: $ make migrate ARG="current+3"
	$(CONSOLE) doctrine:migrations:migrate --no-interaction --all-or-nothing $(ARG)

.PHONY: list
list: _doctrine ## Display a list of all available migrations and their status
	$(CONSOLE) doctrine:migrations:list

.PHONY: execute
execute: _doctrine ## Execute one or more migration versions up or down manually - $ make execute ARG=<arguments> - Example: $ make execute ARG="DoctrineMigrations\Version20240205143239"
	$(CONSOLE) doctrine:migrations:execute $(ARG)

.PHONY: generate
generate: _doctrine ## Generate a blank migration class
	$(CONSOLE) doctrine:migrations:generate

##

.PHONY: sql
sql: _doctrine ## Execute the given SQL query and output the results - $ make sql [QUERY=<query>] - Example: $ make sql QUERY="SELECT * FROM user"
	$(CONSOLE) doctrine:query:sql "$(QUERY)"

# See https://stackoverflow.com/questions/769683/how-to-show-tables-in-postgresql
sql_tables: QUERY=SELECT * FROM pg_catalog.pg_tables;
sql_tables: sql ## Show all tables

##

.PHONY: fixtures
fixtures: _doctrine ## Load fixtures (CAUTION! by default the load command purges the database) - $ make fixtures [ARG=<param>] - Example: $ make fixtures ARG="--append"
	$(CONSOLE) doctrine:fixtures:load -n $(ARG)

## — POSTGRESQL 💽 ————————————————————————————————————————————————————————————

.PHONY: psql
psql: ## Execute psql - $ make psql [ARG=<arguments>] - Example: $ make psql ARG="-V"
	$(PSQL) $(ARG)

## — TESTS ✅ —————————————————————————————————————————————————————————————————

_phpunit:
ifeq ($(wildcard $(BIN_PHPUNIT)),)
	@printf " $(R)⨯$(S) $(Y)TESTS ✅$(S): remove that block or install $(Y)PHPUnit$(S) with $(G)make require_phpunit$(S)\n"
	@exit 1
endif

.PHONY: phpunit
phpunit: _phpunit ## Run PHPUnit - $ make phpunit [ARG=<arguments>] - Example: $ make phpunit ARG="tests/myTest.php"
	$(PHPUNIT) $(ARG)

.PHONY: coverage
coverage: _phpunit ## Generate code coverage report in HTML format - $ make coverage [ARG=<arguments>] - Example: $ make coverage ARG="tests/myTest.php"
	-$(PHPUNIT_COVERAGE) --coverage-html $(COVERAGE_DIR) $(ARG)
	@printf " $(G)✔$(S) Open in your favorite browser the file $(Y)$(COVERAGE_INDEX)$(S)\n"

.PHONY: dox
dox: _phpunit ## Report test execution progress in TestDox format - $ make dox [ARG=<arguments>] - Example: $ make dox ARG="tests/myTest.php"
	$(PHPUNIT) --testdox $(ARG)

dox@text: _phpunit ## Report test execution progress in TestDox format and export it in text file
	-$(PHPUNIT) --testdox-text $(TESTDOX_TEXT) $(ARG)
	@printf " $(G)✔$(S) Open in your favorite browser the file $(Y)$(TESTDOX_TEXT_PATH)$(S)\n"

dox@html: _phpunit ## Report test execution progress in TestDox format and export it in HTML file
	-$(PHPUNIT) --testdox-html $(TESTDOX_HTML) $(ARG)
	@printf " $(G)✔$(S) Open in your favorite browser the file $(Y)$(TESTDOX_HTML_PATH)$(S)\n"

#

xdebug_version: ## Xdebug version number
	$(PHP) -r "var_dump(phpversion('xdebug'));"

## — QUALITY ✅ ———————————————————————————————————————————————————————————————

_phpcsfixer:
ifeq ($(wildcard $(VENDOR_PHPCSFIXER)),)
	@printf " $(R)⨯$(S) $(Y)QUALITY ✅ / PHP CS Fixer$(S): remove that block or install $(Y)PHP CS Fixer$(S) with $(G)make require_phpcsfixer$(S)\n"
	@exit 1
endif

.PHONY: phpcsfixer
phpcsfixer: _phpcsfixer ## Run PHP CS Fixer - $ make phpcsfixer [ARG=<arguments>] - Example: $ make phpcsfixer ARG=list
	$(PHPCSFIXER) $(ARG)

phpcsfixer_lint: _phpcsfixer ## Check code style
	@printf "\n$(Y)PHP CS Fixer [LINT]$(S)"
	@printf "\n$(Y)-------------------$(S)\n\n"
	$(PHPCSFIXER) --config=$(PHPCSFIXER_CONFIG) check

phpcsfixer_fix: _phpcsfixer ## Fix code style
	$(PHPCSFIXER) --config=$(PHPCSFIXER_CONFIG) fix

##

_phpstan:
ifeq ($(wildcard $(VENDOR_PHPSTAN)),)
	@printf " $(R)⨯$(S) $(Y)QUALITY ✅ / PHPStan$(S): remove that block or install $(Y)PHPStan$(S) with $(G)make require_phpstan$(S)\n"
	@exit 1
endif

.PHONY: phpstan
phpstan: _phpstan ## Run PHPStan - $ make phpstan [ARG=<arguments>] - Example: $ make phpstan ARG="src tests"
	$(PHPSTAN) $(ARG)

phpstan_lint: _phpstan ## Run PHPStan analyse - $ make phpstan_analyse [ARG=<arguments>] - Example: $ make phpstan_analyse ARG="src tests"
	@printf "\n$(Y)PHPStan [LINT]$(S)"
	@printf "\n$(Y)--------------$(S)\n\n"
	$(PHPSTAN) analyse -c $(PHPSTAN_CONFIG) $(ARG)

phpstan_baseline: _phpstan ## Generate PHPStan baseline - $ make phpstan_baseline [ARG=<arguments>] - Example: $ make phpstan_baseline ARG="src tests"
	$(PHPSTAN) analyse -c $(PHPSTAN_CONFIG) $(ARG) --generate-baseline $(PHPSTAN_BASELINE)

##

_phpmd:
ifeq ($(wildcard $(VENDOR_PHPMD)),)
	@printf " $(R)⨯$(S) $(Y)QUALITY ✅ / PHP Mess Detector$(S): remove that block or install $(Y)PHP Mess Detector$(S) with $(G)make require_phpmd$(S)\n"
	@exit 1
endif

.PHONY: phpmd
phpmd: _phpmd ## Run PHP Mess Detector - $ make phpmd [ARG=<arguments>] - Example: $ make phpmd ARG="src ansi cleancode"
	$(PHPMD) $(ARG)

phpmd_lint: ## Run PHP Mess Detector with all rules
	@printf "\n$(Y)PHP Mess Detector [LINT]$(S)"
	@printf "\n$(Y)------------------------$(S)\n\n"
	$(PHPMD) $(SRC),$(TESTS) ansi cleancode,codesize,controversial,design,naming,unusedcode $(ARG)

##

_twigcsfixer:
ifeq ($(wildcard $(VENDOR_TWIGCSFIXER)),)
	@printf " $(R)⨯$(S) $(Y)QUALITY ✅ / Twig CS Fixer$(S): remove that block or install $(Y)Twig CS Fixer$(S) with $(G)make require_twigcsfixer$(S)\n"
	@exit 1
endif

.PHONY: twigcsfixer
twigcsfixer: _twigcsfixer ## Run Twig CS Fixer - $ make twigcsfixer [ARG=<arguments>] - Example: $ make twigcsfixer ARG="lint /path/to/code"
	$(TWIGCSFIXER) $(ARG)

twigcsfixer_lint: _twigcsfixer ## Check Twig style
	@printf "\n$(Y)Twig CS Fixer [LINT]$(S)"
	@printf "\n$(Y)--------------------$(S)\n\n"
	$(TWIGCSFIXER) lint $(TEMPLATES)

twigcsfixer_fix: _twigcsfixer ## Fix Twig style
	$(TWIGCSFIXER) lint --fix $(TEMPLATES)

##

.PHONY: lint
lint: phpcsfixer_lint phpstan_lint phpmd_lint twigcsfixer_lint ## Run all linters (stop on failure)

.PHONY: fix
fix: ## Fix with all linters
	-$(MAKE) phpcsfixer_fix
	-$(MAKE) twigcsfixer_fix

##

_phpmetrics:
ifeq ($(wildcard $(VENDOR_PHPMETRICS)),)
	@printf " $(R)⨯$(S) $(Y)QUALITY ✅ / PHPMetrics$(S): remove that block or install $(Y)PHPMetrics$(S) with $(G)make require_phpmetrics$(S)\n"
	@exit 1
endif

phpmetrics_report: _phpmetrics ## Run PHPMetrics and generate detailled report
	$(PHPMETRICS) --report-html=$(PHPMETRICS_DIR) $(SRC)
	@printf " $(G)✔$(S) Open in your favorite browser the file $(Y)$(PHPMETRICS_INDEX)$(S)\n"

## — ASSETS 🎨‍ ————————————————————————————————————————————————————————————————

_assets:
ifeq ($(wildcard $(VENDOR_ASSETS)),)
	@printf " $(R)⨯$(S) $(Y)ASSETS 🎨‍$(S): remove that block or install $(Y)AssetMapper$(S) with $(G)make require_asset_mapper$(S)\n"
	@exit 1
endif

.PHONY: assets
assets: _assets ## Generate all assets
ifeq ($(APP_ENV),prod)
	$(MAKE) importmap_install
else
	$(MAKE) asset_map_compile
endif

##

asset_map_clear: _assets ## Clear all assets in the public output directory
	$(COMPOSE) run --rm php rm -rf ./public/assets

asset_map_compile: _assets asset_map_clear ## Compile all mapped assets and writes them to the final public output directory
	$(CONSOLE) asset-map:compile

asset_map_debug: _assets ## See all of the mapped assets
	$(CONSOLE) debug:asset-map --full

##

importmap_audit: _assets ## Check for security vulnerability advisories for dependencies
	$(CONSOLE) importmap:audit

importmap_install: _assets ## Download all assets that should be downloaded
	$(CONSOLE) importmap:install

importmap_outdated: _assets ## List outdated JavaScript packages and their latest versions
	$(CONSOLE) importmap:outdated

importmap_remove: _assets ## Remove JavaScript packages
	$(CONSOLE) importmap:remove

importmap_require: _assets ## Require JavaScript packages
	$(CONSOLE) importmap:require $(ARG)

importmap_update: _assets ## Update JavaScript packages to their latest versions
	$(CONSOLE) importmap:update

## — TRANSLATION 🇬🇧 ———————————————————————————————————————————————————————————

_translation:
ifeq ($(wildcard $(VENDOR_TRANSLATION)),)
	@printf " $(R)⨯$(S) $(Y)TRANSLATION 🇬🇧$(S): remove that block or install $(Y)Translation$(S) with $(G)make require_translation$(S)\n"
	@exit 1
endif

.PHONY: extract
extract: _translation ## Extracts translation strings from templates (fr)
	$(CONSOLE) translation:extract --sort=asc --format=yaml --force fr

## — DOCKER 🐳 ————————————————————————————————————————————————————————————————

.PHONY: up
up: ## Start the containers - $ make up [ARG=<arguments>] - Example: $ make up ARG=-d
	$(UP_ENV) $(COMPOSE) up --remove-orphans $(ARG)
	$(MAKE) safe

up_detached: ARG=-d
up_detached: up ## Start the containers (wait for services to be running|healthy - detached mode)

.PHONY: down
down: ## Stop and remove the containers
	-$(COMPOSE) down --remove-orphans

.PHONY: build
build: ## Build or rebuild Docker services - $ make build [ARG=<arguments>] - Example: $ make build ARG=--no-cache
	$(COMPOSE) build $(ARG)

.PHONY: build_force
build_force: ARG=--no-cache
build_force: build ## Build or rebuild Docker services (no cache) - $ make build [ARG=<arguments>]

.PHONY: logs
logs: ## Display container logs
	$(COMPOSE) logs -f

.PHONY: images
images: ## List images used by the current containers
	@printf "\n$(Y)Images used by the current containers$(S)"
	@printf "\n$(Y)-------------------------------------$(S)\n\n"
	$(COMPOSE) images | grep -E "REPOSITORY|$(IMAGES_PREFIX)"

.PHONY: config
config: ## Parse, resolve, and render compose file in canonical format
	$(UP_ENV) $(COMPOSE) config

## — CERTIFICATES 🔐‍️ ——————————————————————————————————————————————————————————

.PHONY: certificates
certificates: ## Installs the Caddy TLS certificate to the trust store
	@printf "\n$(Y)Copying the Caddy certificate to trust store$(S)"
	@printf "\n$(Y)--------------------------------------------$(S)\n\n"
	@if [ ! -f /tmp/caddy_root.crt ]; then \
		$(CONTAINER_PHP) sh -c "cat /data/caddy/pki/authorities/local/root.crt" > /tmp/caddy_root.crt; \
	fi
ifeq ($(UNAME_S),Darwin)
	@printf " $(Y)› OS: macOS$(S)\n"
	@sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /tmp/caddy_root.crt
	@rm /tmp/caddy_root.crt
else ifeq ($(UNAME_S),Linux)
	@printf " $(Y)› OS: Linux$(S)\n"
	@sudo cp /tmp/caddy_root.crt /usr/local/share/ca-certificates/caddy_root.crt
	@sudo update-ca-certificates
	@rm /tmp/caddy_root.crt
endif
	@printf " $(G)✔$(S) The Caddy root certificate has been added to the trust store.\n"

certificates_export: ## Exports the Caddy root certificate from the container to the host
	@$(CONTAINER_PHP) sh -c "cat /data/caddy/pki/authorities/local/root.crt" > tls/root.crt
	@printf " $(G)✔$(S) The Caddy root certificate has been exported to $(Y)tls/root.crt$(S).\n"
	@printf " $(Y)›$(S) You may need to manually import this certificate into your browser's trust store:\n"
	@printf "    - $(Y)Chrome/Brave:$(S) Go to chrome://settings/certificates and import the file 'tls/root.crt' under 'Authorities'.\n"
	@printf "    - $(Y)Firefox:$(S) Go to about:preferences#privacy, click 'View Certificates...' and import 'tls/root.crt' under 'Authorities'.\n"
	@printf "\n"

.PHONY: hosts
hosts: ## Add the server name to /etc/hosts file
	@if ! grep -q "$(SERVER_NAME)" /etc/hosts; then \
		echo "127.0.0.1 $(SERVER_NAME)" | sudo tee -a /etc/hosts > /dev/null; \
		printf " $(G)✔$(S) \"$(SERVER_NAME)\" added to /etc/hosts.\n"; \
	else \
		printf " $(G)✔$(S) \"$(SERVER_NAME)\" already exists in /etc/hosts.\n"; \
	fi

## — GIT 🐙 ———————————————————————————————————————————————————————————————————

git_hooks_install: ## Install Git hooks if GIT_HOOKS_INSTALL=1 is set
ifeq ($(GIT_HOOKS_INSTALL),1)
	@printf " $(G)✔$(S) GIT_HOOKS_INSTALL=1 $(Y)›$(S) Enable Git hooks.\n"
	$(MAKE) git_hooks_on
else
	@printf " $(R)⨯$(S) GIT_HOOKS_INSTALL=0 $(Y)›$(S) Disable Git hooks.\n"
	$(MAKE) git_hooks_off
endif

git_hooks_on: ## Use the hooks directory of this project
	git config core.hooksPath hooks/

git_hooks_off: ## Use the default hooks directory of Git
	git config --unset core.hooksPath

git_pre_push: check@stop_on_failure ## Actions on Git pre-push

## — TROUBLESHOOTING 😵️ ———————————————————————————————————————————————————————

.PHONY: permissions
permissions p: ## Fix file permissions (primarily for Linux hosts)
ifeq ($(UNAME_S),Linux)
	$(COMPOSE) run --rm php chown -R $(USER) .
	@printf " $(G)✔$(S) You are now defined as the owner $(Y)$(USER)$(S) of the project files.\n"
else
	@printf " $(Y)›$(S) 'make permissions' is typically not needed on $(UNAME_S).\n"
endif

.PHONY: safe
safe: ## Add /app to Git's safe directories within the php container
	$(COMPOSE) exec php git config --global --add safe.directory /app

## — UTILITIES 🛠️ —————————————————————————————————————————————————————————————

env_files: ## Show env files loaded into this Makefile
	@printf "\n$(Y)Symfony env files$(S)"
	@printf "\n$(Y)-----------------$(S)\n\n"
	@printf "Files loaded into this Makefile (in order of decreasing priority) $(Y)[APP_ENV=$(APP_ENV)]$(S):\n\n"
ifneq ($(wildcard .env.$(APP_ENV).local),)
	@printf "* $(G)✔$(S) .env.$(APP_ENV).local\n"
else
	@printf "* $(R)⨯$(S) .env.$(APP_ENV).local\n"
endif
ifneq ($(wildcard .env.$(APP_ENV)),)
	@printf "* $(G)✔$(S) .env.$(APP_ENV)\n"
else
	@printf "* $(R)⨯$(S) .env.$(APP_ENV)\n"
endif
ifneq ($(wildcard .env.local),)
	@printf "* $(G)✔$(S) .env.local\n"
else
	@printf "* $(R)⨯$(S) .env.local\n"
endif
ifneq ($(wildcard .env),)
	@printf "* $(G)✔$(S) .env\n"
else
	@printf "* $(R)⨯$(S) .env\n"
endif

.PHONY: vars
vars: ## Show key Makefile variables
	@printf "\n$(Y)Vars$(S)"
	@printf "\n$(Y)----$(S)\n\n"
	@printf "USER         : $(USER)\n"
	@printf "UNAME_S      : $(UNAME_S)\n"
	@printf "APP_ENV      : $(APP_ENV)\n"
	@printf "UP_ENV       : $(UP_ENV)\n"
	@printf "COMPOSE_V2   : $(COMPOSE_V2)\n"
	@printf "COMPOSE      : $(COMPOSE)\n"
	@printf "CONTAINER_PHP: $(CONTAINER_PHP)\n"
	@printf "PHP          : $(PHP)\n"
	@printf "COMPOSER     : $(COMPOSER)\n"
	@printf "BASH_COMMAND : $(BASH_COMMAND)\n"
	@printf "CONSOLE      : $(CONSOLE)\n"
