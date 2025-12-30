# --- COLORS ---

# (G)REEN, (R)ED, (Y)ELLOW & RE(S)ET
G = "\\033[32m"
R = "\\033[31m"
Y = "\\033[33m"
S = "\\033[0m"

# --- USER ---

USER_ID  = $(shell id -u)
GROUP_ID = $(shell id -g)
USER     = $(USER_ID):$(GROUP_ID)

# --- OS DETECTION ---

UNAME_S := $(shell uname -s)

# --- SYMFONY ENVIRONMENT VARIABLES ---

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

# --- GIT ---

GIT_HOOKS = off

# --- FILES & DIRECTORIES ---

SRC       = src
TEMPLATES = templates
TESTS     = tests

NOW               := $(shell date +%Y%m%d-%H%M%S-%3N)
PWD                = $(shell pwd)
GIT_PATCH          = .patch
LOCAL_MK           = .mk/local.mk
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

# --- COMPONENTS CONFIG ---

BUILD             = build
PHPCSFIXER_CONFIG = .php-cs-fixer.dist.php
PHPSTAN_BASELINE  = phpstan-baseline.php
PHPSTAN_CONFIG    = phpstan.dist.neon

# --- DATABASE ---

DB_URL_CLEAN   = $(shell echo '$(DATABASE_URL)' | tr -d '"')
IS_SQLITE      = $(findstring sqlite,$(DB_URL_CLEAN))
IS_MYSQL       = $(findstring mysql,$(DB_URL_CLEAN))
IS_POSTGRESQL  = $(findstring postgresql,$(DB_URL_CLEAN))

SQLITE_DB_ENV  = $(subst %kernel.environment%,$(APP_ENV),$(DB_URL_CLEAN))
SQLITE_DB_FILE = $(subst sqlite:///%kernel.project_dir%/,,$(SQLITE_DB_ENV))

# --- DOCKER OPTIONS ---

# See https://github.com/dunglas/symfony-docker/blob/main/docs/options.md
PROJECT_NAME  ?= $(shell basename $(CURDIR) | tr '[:upper:]' '[:lower:]')
SERVER_NAME    = $(PROJECT_NAME).localhost
IMAGES_PREFIX  = $(PROJECT_NAME)-

# See services.php.ports in compose.yaml
HTTP_PORT     ?= 8080
HTTPS_PORT    ?= 8443
HTTP3_PORT    ?= $(HTTPS_PORT)

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

# --- DOCKER COMMANDS ---

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

EXEC        = $(COMPOSE) exec
EXEC_NO_TTY = $(COMPOSE) exec -T

# -T : avoid "the input device is not a TTY" error - Example: $ FORCE_NO_TTY=true make my_command
FORCE_NO_TTY ?= false
ifeq ($(FORCE_NO_TTY), true)
EXEC = $(EXEC_NO_TTY)
endif

CONTAINER_DATABASE        = $(EXEC) database
CONTAINER_DATABASE_NO_TTY = $(EXEC_NO_TTY) database

CONTAINER_PHP          = $(EXEC) php
CONTAINER_PHP_NO_TTY   = $(EXEC_NO_TTY) php
CONTAINER_PHP_COVERAGE = $(EXEC) -e XDEBUG_MODE=coverage php

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

# --- EXTENDS THE MAIN MAKEFILE WITH YOUR OWN LOCAL MAKEFILE ---

ifneq ($(APP_ENV),prod)
-include $(LOCAL_MK)
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

## — GENERATION 🔨 (CAN BE REMOVED AFTER SAVING THE PROJECT) ——————————————————

# This GENERATION block, with these following targets and variables,
# is only used for the initial setup and can be removed after saving the project.

# Symfony 7.* is the current long-term support version.
# Released on          : November 2025
# End of bug fixes     : November 2028
# End of security fixes: November 2029
# See https://symfony.com/releases
SYMFONY_LTS_VERSION       = 7
SYMFONY_STABLE_VERSION    = 8
REPOSITORY_SYMFONY_DOCKER = git@github.com:dunglas/symfony-docker.git
REPOSITORY_SYMFONY_DEMO   = git@github.com:symfony/demo.git
CLONE_DIR                 = clone

_patch_var_log_mapping: f=var-log-mapping.patch
_patch_var_log_mapping: git_apply # INTERNAL

_patch_postgresql: f=postgresql.patch
_patch_postgresql: git_apply # INTERNAL

_patch_sqlite_base: f=sqlite-00-base.patch
_patch_sqlite_base: git_apply # INTERNAL

_patch_sqlite_env: f=sqlite-01-env.patch
_patch_sqlite_env: git_apply # INTERNAL

_symfony_runtime: # INTERNAL
	@printf "Waiting for Symfony Runtime...\n"
	@until docker compose exec php ls vendor/autoload_runtime.php >/dev/null 2>&1; do \
		printf " $(R)⨯$(S) The vendor file is not ready yet. Pause 3 seconds...\n"; \
		sleep 3; \
	done
	@printf " $(G)✔$(S) Symfony Runtime is ready!\n"
	@sleep 3

.PHONY: minimalist
minimalist: clone_symfony_docker _patch_var_log_mapping build up_detached _symfony_runtime permissions ## Generate a minimalist Symfony application with Docker configuration (stable release)
	$(MAKE) restart

minimalist_lts: ## Generate a minimalist Symfony application with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION).* $(MAKE) minimalist

demo: ## Extract Symfony Demo application with Docker configuration --- 🧪 EXPERIMENTAL 🧪 ---
	$(MAKE) clone_symfony_demo clone_symfony_docker
	$(MAKE) _patch_var_log_mapping _patch_sqlite_base _patch_sqlite_env
	$(MAKE) build up_detached
	$(MAKE) _symfony_runtime migration assets
	$(MAKE) permissions images info

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

remove_all: ## Remove all fresh Symfony application files
	-$(MAKE) permissions down
	git reset --hard
	git clean -f -d

## COMPLETE INSTALLATION

require_doctrine_postgresql: ## Install Doctrine (PostgreSQL) - https://symfony.com/doc/current/doctrine.html
	$(COMPOSER) require symfony/orm-pack
	$(MAKE) _patch_postgresql
	$(MAKE) restart

require_doctrine_sqlite: ## Install Doctrine (SQLite) - https://symfony.com/doc/current/doctrine.html
	$(MAKE) _patch_sqlite_base
	$(COMPOSER) require symfony/orm-pack
	$(MAKE) _patch_sqlite_env
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

.PHONY: install
install: up_detached composer_install assets images git_hooks_init info ## Start the project, install dependencies and show info

##

.PHONY: start
start: up_detached images info ## Start the project and show info (up_detached & info alias command)

.PHONY: stop
stop: down ## Stop the project (down alias command)

.PHONY: restart
restart: stop start ## Stop & Start the project and show info (up_detached & info alias command)

.PHONY: info
info: ## Show project access info
	@printf "\n$(Y)Info$(S)"
	@printf "\n$(Y)----$(S)\n\n"
	@printf " $(Y)›$(S) Copy $(Y)$(LOCAL_MK).dist$(S) to $(G)$(LOCAL_MK)$(S) to extend the Makefile with your own commands.\n"
	@printf " $(Y)›$(S) Run $(Y). aliases$(S) or $(Y)source aliases$(S) to create bash aliases for main make commands ($(G)symfony$(S), $(G)php$(S), $(G)composer$(S), ...)\n"
	@printf " $(Y)›$(S) Access to the application (accept the auto-generated TLS certificate):\n"
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

check_level_1 c1: composer_validate validate lint ## Check everything before you deliver - Composer, Doctrine validation, linters (stop on failure)

check_level_2 c2: composer_validate validate lint phpunit ## Check everything before you deliver - Composer, Doctrine validation, linters, PHPUnit (stop on failure)

##

.PHONY: tests
tests: db_init@test fixtures@test phpunit ## Run all tests

## — DOCKER 🐳 ————————————————————————————————————————————————————————————————

.PHONY: up
up: ## Start the containers - $ make up [a=<arguments>] - Example: $ make up a=-d
	$(UP_ENV) $(COMPOSE) up --remove-orphans $(a)
	$(MAKE) safe

up_detached: a=-d
up_detached: up ## Start the containers (wait for services to be running|healthy - detached mode)

.PHONY: down
down: ## Stop and remove the containers
	-$(COMPOSE) down --remove-orphans

.PHONY: build
build: ## Build or rebuild Docker services - $ make build [a=<arguments>] - Example: $ make build a=--no-cache
	$(COMPOSE) build $(a)

.PHONY: build_force
build_force: a=--no-cache
build_force: build ## Build or rebuild Docker services (no cache) - $ make build [a=<arguments>]

.PHONY: logs
logs: ## View logs (follow mode)
	$(COMPOSE) logs -f

.PHONY: clean
clean: ## Clean everything (containers, networks, images)
	$(COMPOSE) down --rmi all -v

.PHONY: config
config: ## Parse, resolve, and render compose file in canonical format
	$(UP_ENV) $(COMPOSE) config

.PHONY: images
images: ## List images used by the current containers
	@printf "\n$(Y)Images used by the current containers$(S)"
	@printf "\n$(Y)-------------------------------------$(S)\n\n"
	$(COMPOSE) images | grep -E "REPOSITORY|$(IMAGES_PREFIX)"

## — SYMFONY 🎵 ———————————————————————————————————————————————————————————————

.PHONY: symfony
symfony sf: ## Run Symfony console command - $ make symfony [a=<arguments>]- Example: $ make symfony a=cache:clear
	$(CONSOLE) $(a)

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
php: ## Run PHP command - $ make php [a=<arguments>]- Example: $ make php a=--version
	$(PHP) $(a)

##

php_sh sh: ## Connect to the PHP container shell
	$(CONTAINER_PHP) sh

php_env: ## Display all environment variables set within the PHP container
	$(CONTAINER_PHP) env

.PHONY: php_command
php_command: ## Run a command inside the PHP container - $ make php_command [a=<arguments>]- Example: $ make php_command a="ls -al"
	$(BASH_COMMAND) "$(a)"

## — COMPOSER 🧙 ——————————————————————————————————————————————————————————————

.PHONY: composer
composer: ## Run composer command - $ make composer [a=<arguments>] - Example: $ make composer a="require --dev phpunit/phpunit"
	$(COMPOSER) $(a)

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

db_drop: _doctrine confirm ## Drop the database - $ make db_drop [a=<arguments>] - Example: $ make db_drop a="--env=test"
ifneq ($(IS_SQLITE),)
	@printf "$(G)SQLite$(S) detected via environment. Removing $(Y)$(SQLITE_DB_FILE)$(S).\n"
	rm -rf $(SQLITE_DB_FILE)
else
	@printf "$(G)Standard SQL$(S) engine detected. Dropping database...\n"
	$(CONSOLE) doctrine:database:drop --if-exists --force $(a)
endif

db_create: _doctrine ## Create the database - $ make db_create [a=<arguments>] - Example: $ make db_create a="--env=test"
ifneq ($(IS_SQLITE),)
	@printf "$(G)SQLite$(S) detected via environment. Ensuring directory exists for $(Y)$(SQLITE_DB_FILE)$(S).\n"
	$(CONSOLE) doctrine:schema:create $(a)
else
	@printf "$(G)Standard SQL$(S) engine detected. Creating database $(Y)$(SQLITE_DB_FILE)$(S)...\n"
	$(CONSOLE) doctrine:database:create --if-not-exists $(a)
endif

db_init: _doctrine db_drop db_create migrate ## Drop and create the database and migrate

db_init@test: a="--env=test"
db_init@test: _doctrine db_drop db_create migrate ## Drop and create the database and migrate (env=test)

##

.PHONY: validate
validate: _doctrine ## Validate the mapping files - $ make validate [a=<arguments>] - Example: $ make validate a="--env=test"
	$(CONSOLE) doctrine:schema:validate -v $(a)

update_dump: _doctrine ## Generate and output the SQL needed to synchronize the database schema with the current mapping metadata
	$(CONSOLE) doctrine:schema:update --dump-sql

update_force: _doctrine ## Execute the generated SQL needed to synchronize the database schema with the current mapping metadata
	$(CONSOLE) doctrine:schema:update --force

##

.PHONY: migration
migration: ## Create a new migration based on database changes (format the generated SQL)
	$(CONSOLE) make:migration --formatted -v $(a)

.PHONY: migrate
migrate: _doctrine ## Execute a migration to the latest available version (in a transaction) - $ make migrate [a=<param>] - Example: $ make migrate a="current+3"
	$(CONSOLE) doctrine:migrations:migrate --no-interaction --all-or-nothing $(a)

.PHONY: list
list: _doctrine ## Display a list of all available migrations and their status
	$(CONSOLE) doctrine:migrations:list

.PHONY: execute
execute: _doctrine ## Execute one or more migration versions up or down manually - $ make execute a=<arguments> - Example: $ make execute a="DoctrineMigrations\Version20240205143239"
	$(CONSOLE) doctrine:migrations:execute $(a)

.PHONY: generate
generate: _doctrine ## Generate a blank migration class
	$(CONSOLE) doctrine:migrations:generate

##

.PHONY: sql
sql: _doctrine ## Execute the given SQL query and output the results - $ make sql [q=<query>] - Example: $ make sql q="SELECT * FROM user"
	$(CONSOLE) doctrine:query:sql "$(q)"

.PHONY: fixtures
fixtures: _doctrine ## Load fixtures (CAUTION! The load command purges the database) - $ make fixtures [a=<param>] - Example: $ make fixtures a="--append"
	$(CONSOLE) doctrine:fixtures:load -n $(a)

fixtures@test: a="--env=test"
fixtures@test: _doctrine fixtures ## Load fixtures (env=test)

## — POSTGRESQL 💽 ————————————————————————————————————————————————————————————

.PHONY: psql
psql: ## Execute psql - $ make psql [a=<arguments>] - Example: $ make psql a="-V"
	$(CONTAINER_DATABASE) psql -U $(POSTGRES_USER) $(POSTGRES_DB) $(a)

psql_sh: ## Open a shell on the PostgreSQL container
	$(CONTAINER_DATABASE) psql -U $(POSTGRES_USER) $(POSTGRES_DB)

.PHONY: tables
tables: ## Show all tables
	$(CONTAINER_DATABASE) psql -U $(POSTGRES_USER) $(POSTGRES_DB) -c "\dt"

##

.PHONY: dump
dump: FILE=$(BUILD)/dumps/dump-$(NOW).sql
dump: ## Create a SQL dump
	mkdir -p $(BUILD)/dumps
	$(CONTAINER_DATABASE) pg_dump -U $(POSTGRES_USER) $(POSTGRES_DB) >$(FILE)
	@printf " $(G)✔$(S) Database successfully dumped to $(Y)$(FILE)$(S)\n"

dump_gz: FILE=$(BUILD)/dumps/dump-$(NOW).gz
dump_gz: ## Create a compressed SQL dump (gzip)
	mkdir -p $(BUILD)/dumps
	$(CONTAINER_DATABASE) pg_dump -U $(POSTGRES_USER) $(POSTGRES_DB) | gzip >$(FILE)
	@printf " $(G)✔$(S) Database successfully dumped to $(Y)$(FILE)$(S)\n"

.PHONY: restore
restore: db_drop db_create ## Restore a dump (CAUTION! The command purges the database) - $ make restore f=<file> - Example: $ make restore f="build/dumps/dump.sql"
	$(if $(f),, $(error f argument is required))
	$(CONTAINER_DATABASE_NO_TTY) psql -U $(POSTGRES_USER) $(POSTGRES_DB) <$(f)

## — TESTS ✅ —————————————————————————————————————————————————————————————————

_phpunit:
ifeq ($(wildcard $(BIN_PHPUNIT)),)
	@printf " $(R)⨯$(S) $(Y)TESTS ✅$(S): remove that block or install $(Y)PHPUnit$(S) with $(G)make require_phpunit$(S)\n"
	@exit 1
endif

.PHONY: phpunit
phpunit: _phpunit ## Run PHPUnit - $ make phpunit [a=<arguments>] - Example: $ make phpunit a="tests/myTest.php"
	$(PHPUNIT) $(a)

phpunit_log: FILE = $(BUILD)/phpunit/phpunit-$(NOW).log
phpunit_log: _phpunit ## Exporting PHPUnit terminal output to a log file
	mkdir -p $(BUILD)/phpunit
	-$(MAKE) phpunit >$(FILE)
	@printf " $(G)✔$(S) PHPUnit terminal output is ready at $(Y)$(PWD)/$(FILE)$(S)\n"

.PHONY: coverage
coverage: DIR = $(BUILD)/coverage/coverage-$(NOW)
coverage: _phpunit ## Generate code coverage report in HTML format - $ make coverage [a=<arguments>] - Example: $ make coverage a="tests/myTest.php"
	mkdir -p $(BUILD)/coverage
	-$(PHPUNIT_COVERAGE) --coverage-html $(DIR) $(a)
	@printf " $(G)✔$(S) Coverage is ready at $(Y)$(PWD)/$(DIR)/index.html$(S)\n"

.PHONY: dox
dox: _phpunit ## Report test execution progress in TestDox format - $ make dox [a=<arguments>] - Example: $ make dox a="tests/myTest.php"
	$(PHPUNIT) --testdox $(a)

dox_text: FILE = $(BUILD)/dox/testdox-$(NOW).txt
dox_text: _phpunit ## Report test execution progress in TestDox format and export it in text file
	mkdir -p $(BUILD)/dox
	-$(PHPUNIT) --testdox-text $(FILE) $(a)
	@printf " $(G)✔$(S) TestDox report is ready at $(Y)$(PWD)/$(FILE)$(S)\n"

dox_html: FILE = $(BUILD)/dox/testdox-$(NOW).html
dox_html: _phpunit ## Report test execution progress in TestDox format and export it in HTML file
	mkdir -p $(BUILD)/dox
	-$(PHPUNIT) --testdox-html $(FILE) $(a)
	@printf " $(G)✔$(S) TestDox report is ready at $(Y)$(PWD)/$(FILE)$(S)\n"

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
phpcsfixer: _phpcsfixer ## Run PHP CS Fixer - $ make phpcsfixer [a=<arguments>] - Example: $ make phpcsfixer a=list
	$(PHPCSFIXER) $(a)

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
phpstan: _phpstan ## Run PHPStan - $ make phpstan [a=<arguments>] - Example: $ make phpstan a="src tests"
	$(PHPSTAN) $(a)

phpstan_lint: _phpstan ## Run PHPStan analyse - $ make phpstan_analyse [a=<arguments>] - Example: $ make phpstan_analyse a="src tests"
	@printf "\n$(Y)PHPStan [LINT]$(S)"
	@printf "\n$(Y)--------------$(S)\n\n"
	$(PHPSTAN) analyse -c $(PHPSTAN_CONFIG) $(a)

phpstan_baseline: _phpstan ## Generate PHPStan baseline - $ make phpstan_baseline [a=<arguments>] - Example: $ make phpstan_baseline a="src tests"
	$(PHPSTAN) analyse -c $(PHPSTAN_CONFIG) $(a) --generate-baseline $(PHPSTAN_BASELINE)

##

_phpmd:
ifeq ($(wildcard $(VENDOR_PHPMD)),)
	@printf " $(R)⨯$(S) $(Y)QUALITY ✅ / PHP Mess Detector$(S): remove that block or install $(Y)PHP Mess Detector$(S) with $(G)make require_phpmd$(S)\n"
	@exit 1
endif

.PHONY: phpmd
phpmd: _phpmd ## Run PHP Mess Detector - $ make phpmd [a=<arguments>] - Example: $ make phpmd a="src ansi cleancode"
	$(PHPMD) $(a)

phpmd_lint: _phpmd ## Run PHP Mess Detector with all rules
	@printf "\n$(Y)PHP Mess Detector [LINT]$(S)"
	@printf "\n$(Y)------------------------$(S)\n\n"
	$(PHPMD) $(SRC),$(TESTS) ansi cleancode,codesize,controversial,design,naming,unusedcode $(a)

##

_twigcsfixer:
ifeq ($(wildcard $(VENDOR_TWIGCSFIXER)),)
	@printf " $(R)⨯$(S) $(Y)QUALITY ✅ / Twig CS Fixer$(S): remove that block or install $(Y)Twig CS Fixer$(S) with $(G)make require_twigcsfixer$(S)\n"
	@exit 1
endif

.PHONY: twigcsfixer
twigcsfixer: _twigcsfixer ## Run Twig CS Fixer - $ make twigcsfixer [a=<arguments>] - Example: $ make twigcsfixer a="lint /path/to/code"
	$(TWIGCSFIXER) $(a)

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

phpmetrics_report: DIR = $(BUILD)/phpmetrics/phpmetrics-$(NOW)
phpmetrics_report: _phpmetrics ## Run PHPMetrics and generate detailed report
	mkdir -p $(BUILD)/phpmetrics
	$(PHPMETRICS) --report-html=$(DIR) $(SRC)
	@printf " $(G)✔$(S) PHPMetrics report is ready at $(Y)$(PWD)/$(DIR)/index.html$(S)\n"

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
	$(CONSOLE) importmap:require $(a)

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

## — CERTIFICATES 🔐‍️ ——————————————————————————————————————————————————————————

.PHONY: certificates
certificates: ## Installs the Caddy TLS certificate to the trust store
	@printf "\n$(Y)Copying the Caddy certificate to trust store$(S)"
	@printf "\n$(Y)--------------------------------------------$(S)\n\n"
	@if [ ! -f /tmp/caddy_root.crt ]; then \
		$(CONTAINER_PHP) sh -c "cat /data/caddy/pki/authorities/local/root.crt" >/tmp/caddy_root.crt; \
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

certificates_export: FILE=$(BUILD)/tls/root.crt
certificates_export: ## Exports the Caddy root certificate from the container to the host
	mkdir -p $(BUILD)/tls
	@$(CONTAINER_PHP) sh -c "cat /data/caddy/pki/authorities/local/root.crt" >$(FILE)
	@printf " $(G)✔$(S) The Caddy root certificate has been exported to $(Y)$(FILE)$(S).\n"
	@printf " $(Y)›$(S) You may need to manually import this certificate into your browser's trust store:\n"
	@printf "    - $(Y)Chrome/Brave:$(S) Go to chrome://settings/certificates and import the file '$(FILE)' under 'Authorities'.\n"
	@printf "    - $(Y)Firefox:$(S) Go to about:preferences#privacy, click 'View Certificates...' and import '$(FILE)' under 'Authorities'.\n"
	@printf "\n"

.PHONY: hosts
hosts: ## Add the server name to /etc/hosts file
	@if ! grep -q "$(SERVER_NAME)" /etc/hosts; then \
		echo "127.0.0.1 $(SERVER_NAME)" | sudo tee -a /etc/hosts >/dev/null; \
		printf " $(G)✔$(S) \"$(SERVER_NAME)\" added to /etc/hosts.\n"; \
	else \
		printf " $(G)✔$(S) \"$(SERVER_NAME)\" already exists in /etc/hosts.\n"; \
	fi

## — GIT 🐙 ———————————————————————————————————————————————————————————————————

git_hooks_init: ## Init the project's hooks directory (set GIT_HOOKS var)
ifeq ($(GIT_HOOKS),on)
	$(MAKE) git_hooks_enable
else
	$(MAKE) git_hooks_disable
endif

git_hooks_enable: ## Enable the project's hooks directory
	git config core.hooksPath hooks/
	@printf " $(G)✔$(S) Git hooks enabled.\n"

git_hooks_disable: ## Disable the project's hooks directory
	git config --unset core.hooksPath
	@printf " $(R)⨯$(S) Git hooks disabled.\n"

git_pre_push: c1 ## Actions on Git pre-push

##

git_apply: ## Apply a patch to files and/or to the index - $ make git_apply f=<file> - Example: $ make git_apply f=file.patch
	$(if $(f),, $(error f argument is required))
	git apply --verbose $(GIT_PATCH)/$(f)
	@printf " $(G)✔$(S) Patch $(Y)$(GIT_PATCH)/$(f)$(S) applied.\n"

git_patch: FILE=$(GIT_PATCH)/$(NOW).patch
git_patch: ## Generate a patch from current diff or from hashes - $ make git_patch [h=<hashes>] - Example: $ make git_patch h="abcd123 efgh456"
	git diff $(h) >$(FILE)
	@printf " $(G)✔$(S) The patch is ready at $(Y)$(PWD)/$(FILE)$(S)\n"

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
	@for file in .env.$(APP_ENV).local .env.$(APP_ENV) .env.local .env; do \
		if [ -f "$${file}" ]; then printf "$(G)✔$(S) $${file}\n"; else printf "$(R)⨯$(S) $${file}\n"; fi; \
	done

.PHONY: vars
vars: ## Show key Makefile variables
	@printf "\n$(Y)Vars$(S)"
	@printf "\n$(Y)----$(S)\n\n"
	@$(foreach var, \
		USER UNAME_S APP_ENV UP_ENV COMPOSE_V2 COMPOSE FORCE_NO_TTY \
		CONTAINER_PHP PHP COMPOSER BASH_COMMAND CONSOLE \
		IS_SQLITE IS_MYSQL IS_POSTGRESQL, \
		printf "%-15s : %s\n" "${var}" "${${var}}"; \
	)

.PHONY: aliases
aliases: ## Show aliases info (how to load it?)
	@printf "To load aliases, run:\n  $(Y). aliases$(S)\nor:\n  $(Y)console aliases$(S)\n";

.PHONY: tree
tree: l ?= 2
tree: ## Visualize your structure (requires `tree` command) - $ make tree [l=<level>] - Example: $ make tree l=1
	tree -A -L $(l) -F --dirsfirst

## — INTERNAL 🚧‍️ ——————————————————————————————————————————————————————————————

PHONY: confirm
confirm: ## Display a confirmation before continuing [y/N]
	@if [ "$${NO_INTERACTION}" = "true" ]; then exit 0; fi; \
	printf "$(G)Do you want to continue?$(S) [$(Y)y/N$(S)]: " && read answer && [ $${answer:-N} = y ]
