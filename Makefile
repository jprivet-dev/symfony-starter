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
$(eval $(call append,DATABASE_URL))
$(eval $(call append,SYMFONY_MONOREPO_PATH))

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

# -T: avoid "the input device is not a TTY" error - Example: $ FORCE_NO_TTY=true make my_command
FORCE_NO_TTY ?= false
ifeq ($(FORCE_NO_TTY), true)
EXEC = $(EXEC_NO_TTY)
endif

# Run commands as www-data user - Example: $ FORCE_WWW_DATA_USER=true make tests
FORCE_WWW_DATA_USER ?= false
ifeq ($(FORCE_WWW_DATA_USER), true)
EXEC += -u www-data php
endif

CONTAINER_DATABASE        = $(EXEC) database
CONTAINER_DATABASE_NO_TTY = $(EXEC_NO_TTY) database
CONTAINER_PHP             = $(EXEC) php
CONTAINER_PHP_COVERAGE    = $(EXEC) -e XDEBUG_MODE=coverage php

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

# --- EXTEND THE MAIN MAKEFILE ---

ifneq ($(APP_ENV),prod)
-include $(sort $(wildcard .mk/*.mk))
endif

## — 🐳 🎵 THE SYMFONY STARTER MAKEFILE 🎵 🐳 —————————————————————————————————

# Print self-documented Makefile:
# $ make
# $ make help

.DEFAULT_GOAL = help
.PHONY: help
help: ## Display this help message with available commands
	@grep -E '(^[.a-zA-Z_-]+[^:]+:.*##.*?$$)|(^#{2})' $(MAKEFILE_LIST) | awk 'BEGIN {FS = "## "}; { \
		split($$1, line, ":"); targets=line[2]; description=$$2; \
		if (targets == "##") { printf "\033[33m%s\n", ""; } \
		else if (targets == "" && description != "") { printf "\033[33m\n%s\n", description; } \
		else if (targets != "" && description != "") { split(targets, parts, " "); target=parts[1]; alias=parts[2]; printf "\033[32m  %-26s \033[34m%-2s \033[0m%s\n", target, alias, description; } \
	}'
	@echo

## — PROJECT 🚀 ———————————————————————————————————————————————————————————————

.PHONY: install
install: up_detached ## Start the project, install dependencies and show info
	$(MAKE) composer_install
	-$(MAKE) assets
	$(MAKE) images
	$(MAKE) git_hooks_init
	$(MAKE) info
	$(MAKE) permissions

.PHONY: info
info: ## Show project access info
	@printf "\n$(Y)--- Info ---$(S)\n"
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

.PHONY: restart
restart: stop start ## Stop & Start the project and show info (detached mode)

.PHONY: start
start: up_detached images info ## Start the project and show info (detached mode)

.PHONY: stop
stop: down ## Stop the project (down)

##

.PHONY: c1
check_level_1 c1: composer_validate validate lint ## Check everything before you deliver - Composer, Doctrine validation, linters (stop on failure)

.PHONY: c2
check_level_2 c2: composer_validate validate lint phpunit ## Check everything before you deliver - Composer, Doctrine validation, linters, PHPUnit (stop on failure)

.PHONY: tests t
tests t: db_init@test fixtures@test phpunit ## Run all tests

## — DOCKER 🐳 ————————————————————————————————————————————————————————————————

.PHONY: build
build: ## Build or rebuild Docker services - $ make build [a=<arguments>] - Example: $ make build a=--no-cache
	$(COMPOSE) build $(a)

.PHONY: build_force
build_force: a=--no-cache
build_force: build ## Build or rebuild Docker services (no cache) - $ make build [a=<arguments>]

.PHONY: down
down: ## Stop and remove the containers
	-$(COMPOSE) down --remove-orphans

.PHONY: up
up: ## Start the containers - $ make up [a=<arguments>] - Example: $ make up a=-d
	$(UP_ENV) $(COMPOSE) up --remove-orphans $(a)
	$(MAKE) runtime
	$(MAKE) safe

up_detached: a=-d
up_detached: up ## Start the containers (wait for services to be running|healthy - detached mode)

##

.PHONY: clean
clean: confirm ## Clean everything (containers, networks, images) [y/N]
	$(COMPOSE) down --rmi all -v

.PHONY: volumes
volumes: confirm # Stops and removes all containers and any unnamed volumes [y/N]
	$(COMPOSE) down --volumes --rmi all

##

.PHONY: config
config: ## Parse, resolve, and render compose file in canonical format
	$(UP_ENV) $(COMPOSE) config

.PHONY: images
images: ## List images used by the current containers
	@printf "\n$(Y)--- Images used by the current containers ---$(S)\n"
	$(COMPOSE) images | grep -E "REPOSITORY|$(IMAGES_PREFIX)"

.PHONY: logs
logs: ## View logs (follow mode)
	$(COMPOSE) logs -f

## — SYMFONY 🎵 ———————————————————————————————————————————————————————————————

.PHONY: symfony sf
symfony sf: ## Run Symfony console command - $ make symfony [a=<arguments>]- Example: $ make symfony a=cache:clear
	$(CONSOLE) $(a)

##

.PHONY: about
about: ## Display information about the current Symfony project
	$(CONSOLE) about

.PHONY: cc
cache_clear cc: ## Clear the Symfony cache
	$(CONSOLE) cache:clear

.PHONY: dotenv
dotenv: ## Lists all .env files with variables and values
	$(CONSOLE) debug:dotenv

.PHONY: dumpenv
dumpenv: ## Generate .env.local.php for production
	$(COMPOSER) dump-env prod

.PHONY: routes
routes: ## Display current routes with assigned controllers and aliases
	$(CONSOLE) debug:route --show-controllers --show-aliases

## — PHP 🐘 ———————————————————————————————————————————————————————————————————

.PHONY: php
php: ## Run PHP command - $ make php [a=<arguments>]- Example: $ make php a=--version
	$(PHP) $(a)

##

.PHONY: c
php_command c: ## Run a command inside the PHP container - $ make php_command [a=<arguments>]- Example: $ make php_command a="ls -al"
	$(BASH_COMMAND) "$(a)"

php_env: ## Display all environment variables set within the PHP container
	$(CONTAINER_PHP) env

.PHONY: sh
php_sh sh: ## Connect to the PHP container shell
	$(CONTAINER_PHP) sh

## — COMPOSER 🧙 ——————————————————————————————————————————————————————————————

.PHONY: composer
composer: ## Run composer command - $ make composer [a=<arguments>] - Example: $ make composer a="require --dev phpunit/phpunit"
	$(COMPOSER) $(a)

.PHONY: i
composer_install i: ## Install Composer packages
	@printf "\n$(Y)--- Composer Install (env: $(APP_ENV)) ---$(S)\n"
ifeq ($(APP_ENV),prod)
	$(COMPOSER) install --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader
else
	$(COMPOSER) install
endif

composer_validate: ## Check if lock file is up to date (even when config.lock is false)
	@printf "\n$(Y)--- Composer Validate ---$(S)\n"
	$(COMPOSER) validate --strict

##

.PHONY: outdated
outdated: ## Show a list of installed packages that have updates available, including their latest version
	$(COMPOSER) outdated

.PHONY: remove
remove: ## Remove a package from the require or require-dev - $ make remove [a=<arguments>] - Example: $ make remove a="phpunit/phpunit"
	$(COMPOSER) remove $(a)

.PHONY: require
require: ## Add required packages to your composer.json and installs them - $ make require [a=<arguments>] - Example: $ make require a="--dev phpunit/phpunit"
	$(COMPOSER) require $(a)

.PHONY: update
update: ## Update Composer packages - $ make update [a=<arguments>] - Example: $ make update a="phpunit/phpunit"
	@printf "\n$(Y)--- Composer Update (env: $(APP_ENV)) ---$(S)\n"
ifeq ($(APP_ENV),prod)
	$(COMPOSER) update --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader
else
	$(COMPOSER) update
endif

.PHONY: update_lock
update_lock: ## Update only the content hash of composer.lock without updating dependencies
	$(COMPOSER) update --lock

## — DOCTRINE / SQL 💽 ————————————————————————————————————————————————————————

_doctrine:
ifeq ($(wildcard $(VENDOR_DOCTRINE)),)
	@printf " $(R)⨯$(S) Remove the $(Y)DOCTRINE / SQL 💽$(S) section or install $(Y)Doctrine$(S) with $(G)make require_doctrine$(S)\n"
	@exit 1
endif

db_init: _doctrine db_drop db_create migrate ## Drop and create the database and migrate

db_init@test: a="--env=test"
db_init@test: _doctrine db_drop db_create migrate ## Drop and create the database and migrate (env=test)

##

db_drop: _doctrine confirm ## Drop the database [y/N] - $ make db_drop [a=<arguments>] - Example: $ make db_drop a="--env=test"
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

##

.PHONY: execute
execute: _doctrine ## Execute one or more migration versions up or down manually - $ make execute a=<arguments> - Example: $ make execute a="DoctrineMigrations\Version20240205143239"
	$(CONSOLE) doctrine:migrations:execute $(a)

.PHONY: generate
generate: _doctrine ## Generate a blank migration class
	$(CONSOLE) doctrine:migrations:generate

.PHONY: list
list: _doctrine ## Display a list of all available migrations and their status
	$(CONSOLE) doctrine:migrations:list

.PHONY: migrate
migrate: _doctrine ## Execute a migration to the latest available version (in a transaction) - $ make migrate [a=<param>] - Example: $ make migrate a="current+3"
	$(CONSOLE) doctrine:migrations:migrate --no-interaction --all-or-nothing $(a)

.PHONY: migration
migration: ## Create a new migration based on database changes (format the generated SQL)
	$(CONSOLE) make:migration --formatted -v $(a)

##

.PHONY: fixtures
fixtures: _doctrine ## Load fixtures (CAUTION! The load command purges the database) - $ make fixtures [a=<param>] - Example: $ make fixtures a="--append"
	$(CONSOLE) doctrine:fixtures:load -n $(a)

fixtures@test: a="--env=test"
fixtures@test: _doctrine fixtures ## Load fixtures (env=test)

.PHONY: sql
sql: _doctrine ## Execute the given SQL query and output the results - $ make sql [q=<query>] - Example: $ make sql q="SELECT * FROM user"
	$(CONSOLE) doctrine:query:sql "$(q)"

update_dump: _doctrine ## Generate and output the SQL needed to synchronize the database schema with the current mapping metadata
	$(CONSOLE) doctrine:schema:update --dump-sql

update_force: _doctrine ## Execute the generated SQL needed to synchronize the database schema with the current mapping metadata
	$(CONSOLE) doctrine:schema:update --force

.PHONY: validate
validate: _doctrine ## Validate the mapping files - $ make validate [a=<arguments>] - Example: $ make validate a="--env=test"
	@printf "\n$(Y)--- Doctrine Schema Validate ---$(S)\n"
	$(CONSOLE) doctrine:schema:validate -v $(a)

## — POSTGRESQL 🛢️ ————————————————————————————————————————————————————————————

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
restore: confirm db_drop db_create ## Restore a dump (CAUTION! The command purges the database) [y/N] - $ make restore f=<file> - Example: $ make restore f="build/dumps/dump.sql"
	$(if $(f),, $(error "Please specify a file with 'f=...'"))
	$(CONTAINER_DATABASE_NO_TTY) psql -U $(POSTGRES_USER) $(POSTGRES_DB) <$(f)

## — TESTS ✅ —————————————————————————————————————————————————————————————————

_phpunit:
ifeq ($(wildcard $(BIN_PHPUNIT)),)
	@printf " $(R)⨯$(S) Remove the $(Y)TESTS ✅$(S) section or install $(Y)PHPUnit$(S) with $(G)make require_test_pack$(S)\n"
	@exit 1
endif

.PHONY: phpunit p
phpunit p: _phpunit ## Run PHPUnit - $ make phpunit [a=<arguments>] - Example: $ make phpunit a="tests/myTest.php"
	@printf "\n$(Y)--- PHPUnit ---$(S)\n"
	$(PHPUNIT) $(a)

phpunit_log: FILE = $(BUILD)/phpunit/phpunit-$(NOW).log
phpunit_log: _phpunit ## Exporting PHPUnit terminal output to a log file
	mkdir -p $(BUILD)/phpunit
	-$(MAKE) phpunit >$(FILE)
	@printf " $(G)✔$(S) PHPUnit terminal output is ready at $(Y)$(PWD)/$(FILE)$(S)\n"

##

.PHONY: coverage
coverage: DIR = $(BUILD)/coverage/coverage-$(NOW)
coverage: _phpunit ## Generate code coverage report in HTML format - $ make coverage [a=<arguments>] - Example: $ make coverage a="tests/myTest.php"
	@printf "\n$(Y)--- PHPUnit Coverage ---$(S)\n"
	mkdir -p $(BUILD)/coverage
	-$(PHPUNIT_COVERAGE) --coverage-html $(DIR) $(a)
	@printf " $(G)✔$(S) Coverage is ready at $(Y)$(PWD)/$(DIR)/index.html$(S)\n"

.PHONY: dox
dox: _phpunit ## Report test execution progress in TestDox format - $ make dox [a=<arguments>] - Example: $ make dox a="tests/myTest.php"
	@printf "\n$(Y)--- PHPUnit TestDox ---$(S)\n"
	$(PHPUNIT) --testdox $(a)

dox_html: FILE = $(BUILD)/dox/testdox-$(NOW).html
dox_html: _phpunit ## Report test execution progress in TestDox format and export it to an HTML file
	mkdir -p $(BUILD)/dox
	-$(PHPUNIT) --testdox-html $(FILE) $(a)
	@printf " $(G)✔$(S) TestDox report is ready at $(Y)$(PWD)/$(FILE)$(S)\n"

dox_text: FILE = $(BUILD)/dox/testdox-$(NOW).txt
dox_text: _phpunit ## Report test execution progress in TestDox format and export it to a text file
	mkdir -p $(BUILD)/dox
	-$(PHPUNIT) --testdox-text $(FILE) $(a)
	@printf " $(G)✔$(S) TestDox report is ready at $(Y)$(PWD)/$(FILE)$(S)\n"

xdebug_version: ## Xdebug version number
	$(PHP) -r "var_dump(phpversion('xdebug'));"

## — QUALITY ✅ ———————————————————————————————————————————————————————————————

.PHONY: fix
fix: ## Fix with all linters
	-$(MAKE) phpcsfixer_fix
	-$(MAKE) twigcsfixer_fix

.PHONY: lint
lint: phpcsfixer_lint phpstan_lint phpmd_lint twigcsfixer_lint ## Run all linters (stop on failure)

##

_phpcsfixer:
ifeq ($(wildcard $(VENDOR_PHPCSFIXER)),)
	@printf " $(R)⨯$(S) Remove the $(Y)QUALITY ✅ / PHP CS Fixer$(S) section or install $(Y)PHP CS Fixer$(S) with $(G)make require_phpcsfixer$(S)\n"
	@exit 1
endif

.PHONY: phpcsfixer
phpcsfixer: _phpcsfixer ## Run PHP CS Fixer - $ make phpcsfixer [a=<arguments>] - Example: $ make phpcsfixer a=list
	$(PHPCSFIXER) $(a)

phpcsfixer_fix: _phpcsfixer ## Fix code style
	$(PHPCSFIXER) --config=$(PHPCSFIXER_CONFIG) fix

phpcsfixer_lint: _phpcsfixer ## Check code style
	@printf "\n$(Y)--- PHP CS Fixer [LINT] ---$(S)\n"
	$(PHPCSFIXER) --config=$(PHPCSFIXER_CONFIG) check

##

_phpmd:
ifeq ($(wildcard $(VENDOR_PHPMD)),)
	@printf " $(R)⨯$(S) Remove the $(Y)QUALITY ✅ / PHP Mess Detector$(S) section or install $(Y)PHP Mess Detector$(S) with $(G)make require_phpmd$(S)\n"
	@exit 1
endif

.PHONY: phpmd
phpmd: _phpmd ## Run PHP Mess Detector - $ make phpmd [a=<arguments>] - Example: $ make phpmd a="src ansi cleancode"
	$(PHPMD) $(a)

phpmd_lint: _phpmd ## Run PHP Mess Detector with all rules
	@printf "\n$(Y)--- PHP Mess Detector [LINT] ---$(S)\n"
	$(PHPMD) $(SRC),$(TESTS) ansi cleancode,codesize,controversial,design,naming,unusedcode $(a)

##

_phpmetrics:
ifeq ($(wildcard $(VENDOR_PHPMETRICS)),)
	@printf " $(R)⨯$(S) Remove the $(Y)QUALITY ✅ / PHPMetrics$(S) section or install $(Y)PHPMetrics$(S) with $(G)make require_phpmetrics$(S)\n"
	@exit 1
endif

phpmetrics_report: DIR = $(BUILD)/phpmetrics/phpmetrics-$(NOW)
phpmetrics_report: _phpmetrics ## Run PHPMetrics and generate detailed report
	@printf "\n$(Y)--- PHPMetrics Report ---$(S)\n"
	mkdir -p $(BUILD)/phpmetrics
	$(PHPMETRICS) --report-html=$(DIR) $(SRC)
	@printf " $(G)✔$(S) PHPMetrics report is ready at $(Y)$(PWD)/$(DIR)/index.html$(S)\n"

##

_phpstan:
ifeq ($(wildcard $(VENDOR_PHPSTAN)),)
	@printf " $(R)⨯$(S) Remove the $(Y)QUALITY ✅ / PHPStan$(S) section or install $(Y)PHPStan$(S) with $(G)make require_phpstan$(S)\n"
	@exit 1
endif

.PHONY: phpstan
phpstan: _phpstan ## Run PHPStan - $ make phpstan [a=<arguments>] - Example: $ make phpstan a="src tests"
	$(PHPSTAN) $(a)

phpstan_baseline: _phpstan ## Generate PHPStan baseline - $ make phpstan_baseline [a=<arguments>] - Example: $ make phpstan_baseline a="src tests"
	$(PHPSTAN) analyse -c $(PHPSTAN_CONFIG) $(a) --generate-baseline $(PHPSTAN_BASELINE)

phpstan_lint: _phpstan ## Run PHPStan analyse - $ make phpstan_analyse [a=<arguments>] - Example: $ make phpstan_analyse a="src tests"
	@printf "\n$(Y)--- PHPStan [LINT] ---$(S)\n"
	$(PHPSTAN) analyse -c $(PHPSTAN_CONFIG) $(a)

##

_twigcsfixer:
ifeq ($(wildcard $(VENDOR_TWIGCSFIXER)),)
	@printf " $(R)⨯$(S) Remove the $(Y)QUALITY ✅ / Twig CS Fixer$(S) section or install $(Y)Twig CS Fixer$(S) with $(G)make require_twigcsfixer$(S)\n"
	@exit 1
endif

.PHONY: twigcsfixer
twigcsfixer: _twigcsfixer ## Run Twig CS Fixer - $ make twigcsfixer [a=<arguments>] - Example: $ make twigcsfixer a="lint /path/to/code"
	$(TWIGCSFIXER) $(a)

twigcsfixer_fix: _twigcsfixer ## Fix Twig style
	$(TWIGCSFIXER) lint --fix $(TEMPLATES)

twigcsfixer_lint: _twigcsfixer ## Check Twig style
	@printf "\n$(Y)--- Twig CS Fixer [LINT] ---$(S)\n"
	$(TWIGCSFIXER) lint $(TEMPLATES)

## — ASSETS 🎨‍ ————————————————————————————————————————————————————————————————

_assets:
ifeq ($(wildcard $(VENDOR_ASSETS)),)
	@printf " $(R)⨯$(S) Remove the $(Y)ASSETS 🎨‍$(S) section or install $(Y)AssetMapper$(S) with $(G)make require_asset_mapper$(S)\n"
	@exit 1
endif

.PHONY: assets
assets: _assets ## Generate all assets
	@printf "\n$(Y)--- Assets (env: $(APP_ENV)) ---$(S)\n"
ifeq ($(APP_ENV),prod)
	$(MAKE) importmap_install
else
	$(MAKE) asset_map_compile
endif

##

asset_map_clear: _assets ## Clear all assets in the public output directory
	$(COMPOSE) run --rm php rm -rf ./public/assets

asset_map_compile: _assets asset_map_clear ## Compile all mapped assets and write them to the final public output directory
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
	@printf " $(R)⨯$(S) Remove the $(Y)TRANSLATION 🇬🇧$(S) section or install $(Y)Translation$(S) with $(G)make require_translation$(S)\n"
	@exit 1
endif

.PHONY: extract
extract: _translation ## Extract translation strings from templates
	$(CONSOLE) translation:extract --sort=asc --format=yaml --force fr

## — CERTIFICATES 🔐‍️ ——————————————————————————————————————————————————————————

.PHONY: certificates
certificates: ## Install the Caddy TLS certificate to the trust store
	@printf "\n$(Y)--- Copying the Caddy certificate to trust store ---$(S)\n"
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
certificates_export: ## Export the Caddy root certificate from the container to the host
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

git_hooks_init: ## Initialize the project's hooks directory (set GIT_HOOKS var)
ifeq ($(GIT_HOOKS),on)
	$(MAKE) git_hooks_enable
else
	$(MAKE) git_hooks_disable
endif

##

git_hooks_disable: ## Disable the project's hooks directory
	-git config --unset core.hooksPath
	@printf " $(R)⨯$(S) Git hooks disabled.\n"

git_hooks_enable: ## Enable the project's hooks directory
	-git config core.hooksPath hooks/
	@printf " $(G)✔$(S) Git hooks enabled.\n"

git_pre_push: c1 ## Actions on Git pre-push

##

git_apply: ## Apply a patch to files and/or to the index - $ make git_apply f=<file> - Example: $ make git_apply f=file.patch
	$(if $(f),, $(error "Please specify a file with 'f=...'"))
	git apply --verbose $(GIT_PATCH)/$(f)
	@printf " $(G)✔$(S) Patch $(Y)$(GIT_PATCH)/$(f)$(S) applied.\n"

git_patch: FILE=$(GIT_PATCH)/$(NOW).patch
git_patch: ## Generate a patch from current diff or from hashes - $ make git_patch [h=<hashes>] - Example: $ make git_patch h="abcd123 efgh456"
	git diff $(h) >$(FILE)
	@printf " $(G)✔$(S) The patch is ready at $(Y)$(PWD)/$(FILE)$(S)\n"

## — TROUBLESHOOTING 😵️ ———————————————————————————————————————————————————————

.PHONY: permissions
permissions: ## Fix file permissions (primarily for Linux hosts)
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

.PHONY: aliases
aliases: ## Show aliases info and loading instructions
	@printf "To load aliases, run:\n  $(Y). aliases$(S)\nor:\n  $(Y)console aliases$(S)\n";

env_files: ## Show env files loaded into this Makefile
	@printf "\n$(Y)--- Symfony Env Files ---$(S)\n"
	@printf "Files loaded into this Makefile (in order of decreasing priority) $(Y)[APP_ENV=$(APP_ENV)]$(S):\n\n"
	@for file in .env.$(APP_ENV).local .env.$(APP_ENV) .env.local .env; do \
		if [ -f "$${file}" ]; then printf "$(G)✔$(S) $${file}\n"; else printf "$(R)⨯$(S) $${file}\n"; fi; \
	done

.PHONY: tree
tree: l ?= 2
tree: ## Visualize your structure (requires `tree` command) - $ make tree [l=<level>] - Example: $ make tree l=1
	tree -A -L $(l) -F --dirsfirst

.PHONY: vars
vars: ## Show key Makefile variables
	@printf "\n$(Y)--- Vars ---$(S)\n"
	@$(foreach var, \
		USER UNAME_S APP_ENV UP_ENV COMPOSE_V2 COMPOSE FORCE_NO_TTY \
		CONTAINER_PHP PHP COMPOSER BASH_COMMAND CONSOLE \
		IS_SQLITE IS_MYSQL IS_POSTGRESQL, \
		printf "%-15s : %s\n" "${var}" "${${var}}"; \
	)

# —— INTERNAL (HIDDEN) 🚧‍️ ——————————————————————————————————————————————————————————————

PHONY: confirm
confirm: # INTERNAL - Display a confirmation before continuing [y/N]
	@if [ "$${NO_INTERACTION}" = "true" ]; then exit 0; fi; \
	printf "$(G)Do you want to continue?$(S) [$(Y)y/N$(S)]: " && read answer && [ $${answer:-N} = y ]

PHONY: runtime
runtime: # INTERNAL - Check if vendor/autoload_runtime.php is ready yet
	@printf "Waiting for Symfony Runtime...\n"
	@until $(CONTAINER_PHP) ls vendor/autoload_runtime.php >/dev/null 2>&1; do \
		printf " $(R)⨯$(S) The vendor file is not ready yet. Pause 3 seconds...\n"; \
		sleep 3; \
	done
	@printf " $(G)✔$(S) Symfony Runtime is ready!\n"
	@sleep 1
