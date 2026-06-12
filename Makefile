MAKEFLAGS += --no-print-directory

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

GIT_HOOKS ?= off

# --- YQ ---

# See https://github.com/mikefarah/yq
YQ = docker run --rm --user "$(USER)" -v "$(PWD)":/workdir -w /workdir mikefarah/yq

# --- GIT SAFE DIRECTORIES ---

# Directories to trust in Git within the PHP container.
# Add your local contribution volumes here (e.g., /symfony, /monolog-bundle).
SAFE_DIRECTORIES = /app

# --- FILES & DIRECTORIES ---

SRC       = src
TEMPLATES = templates
TESTS     = tests

NOW               := $(shell date +%Y%m%d-%H%M%S-%3N)
PWD                = $(shell pwd)
MAKE_LOCAL_MK      = .make/local.mk
MAKE_LOCAL_MK_DIST = $(MAKE_LOCAL_MK).dist
BIN_CONSOLE        = bin/console
BIN_PHPUNIT        = bin/phpunit
COMPOSER_JSON      = composer.json
DOCKERFILE         = Dockerfile
VENDOR_API         = vendor/api-platform
VENDOR_ASSETS      = vendor/symfony/asset-mapper
VENDOR_DOCTRINE    = vendor/doctrine
VENDOR_EASYADMIN   = vendor/easycorp/easyadmin-bundle
VENDOR_MAILER      = vendor/symfony/mailer
VENDOR_MONOLOG     = vendor/symfony/monolog-bundle
VENDOR_PHPCSFIXER  = vendor/bin/php-cs-fixer
VENDOR_PHPMD       = vendor/bin/phpmd
VENDOR_PHPMETRICS  = vendor/bin/phpmetrics
VENDOR_PHPSTAN     = vendor/bin/phpstan
VENDOR_PROFILER    = vendor/symfony/web-profiler-bundle
VENDOR_TAILWIND    = vendor/symfonycasts/tailwind-bundle
VENDOR_TRANSLATION = vendor/symfony/translation
VENDOR_TWIGCSFIXER = vendor/bin/twig-cs-fixer

# --- COMPONENTS CONFIG ---

BUILD             = build
PHPCSFIXER_CONFIG = .php-cs-fixer.dist.php
PHPSTAN_BASELINE  = phpstan-baseline.php
PHPSTAN_CONFIG    = phpstan.dist.neon

# --- DATABASE ---

DB_URL_CLEAN   = $(shell echo '$(DATABASE_URL)' | tr -d '"')
IS_MYSQL       = $(findstring mysql,$(DB_URL_CLEAN))
IS_POSTGRESQL  = $(findstring postgresql,$(DB_URL_CLEAN))
IS_SQLITE      = $(findstring sqlite,$(DB_URL_CLEAN))

SQLITE_DB_ENV  = $(subst %kernel.environment%,$(APP_ENV),$(DB_URL_CLEAN))
SQLITE_DB_FILE = $(subst sqlite:///%kernel.project_dir%/,,$(SQLITE_DB_ENV))

# --- DOCKER OPTIONS ---

# See https://github.com/dunglas/symfony-docker/blob/main/docs/options.md
PROJECT_NAME ?= $(shell basename $(CURDIR) | tr '[:upper:]' '[:lower:]')
SERVER_NAME   = $(PROJECT_NAME).localhost
IMAGES_PREFIX = $(PROJECT_NAME)-

# Port is derived from the project name to avoid conflicts when running multiple instances.
# Can be overridden in .env.local (e.g. HTTP_PORT=8080)
# See services.php.ports in compose.yaml
HTTP_PORT  ?= $(shell echo $(PROJECT_NAME) | cksum | awk '{print 8000 + $$1 % 900}')
HTTPS_PORT ?= $(shell echo $(PROJECT_NAME) | cksum | awk '{print 8400 + $$1 % 99}')
HTTP3_PORT ?= $(HTTPS_PORT)

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

$(eval $(call append,SERVER_NAME))
$(eval $(call append,IMAGES_PREFIX))
$(eval $(call append,SYMFONY_VERSION))
$(eval $(call append,STABILITY))
$(eval $(call append,HTTP_PORT))
$(eval $(call append,HTTPS_PORT))
$(eval $(call append,HTTP3_PORT))
#$(eval $(call append,XDEBUG_MODE))

# --- LOCALHOST ---

LOCALHOST          = https://$(SERVER_NAME)$(HTTPS_PORT_SUFFIX)
LOCALHOST_API      = $(LOCALHOST)/api
LOCALHOST_ADMIN    = $(LOCALHOST)/admin
LOCALHOST_PROFILER = $(LOCALHOST)/_profiler
LOCALHOST_MAILER   = http://$(SERVER_NAME):8025/

LOCALHOST_MAIN = $(LOCALHOST)
ifneq ($(wildcard $(VENDOR_API)),)
	LOCALHOST_MAIN = $(LOCALHOST_API)
endif
ifneq ($(wildcard $(VENDOR_EASYADMIN)),)
	LOCALHOST_MAIN = $(LOCALHOST_ADMIN)
endif

# --- DOCKER ENVIRONMENT FILES ---

# Docker Compose automatically reads the '.env' file by default.
# However, it does NOT natively support Symfony's hierarchical override system
# (e.g., .env.local) for variable interpolation in compose.yaml.
#
# To enable local overrides for infrastructure variables (like ports, versions),
# we explicitly build the --env-file chain.

define add_env_file
$(if $(wildcard $(1)),$(if $(shell cat $(1)),--env-file $(1)))
endef

ENV_FILES += $(call add_env_file,.env.local)
ENV_FILES += $(call add_env_file,.env.$(APP_ENV))
ENV_FILES += $(call add_env_file,.env.$(APP_ENV).local)
ENV_FILES := $(strip $(ENV_FILES))

# .env is loaded by Docker by default, only add it explicitly if overrides are active
ifneq ($(ENV_FILES),)
ENV_FILES := $(if $(wildcard .env),--env-file .env) $(ENV_FILES)
endif

# --- DOCKER COMMANDS ---

COMPOSE_V2 := $(shell docker compose version 2> /dev/null)

ifndef COMPOSE_V2
$(warning [WARNING] Docker Compose CLI plugin is required but is not available on your system)
endif

COMPOSE = $(strip docker compose $(ENV_FILES))

# In a first step, you can test the application's production behavior in a development environment by setting APP_ENV=prod.
# To test the full Docker production setup (e.g., optimized images, production-specific configurations), you can also add USE_COMPOSE_PROD_YAML=true.
# This allows for a smooth transition from testing the code's behavior to testing the full Docker infrastructure.
ifeq ($(USE_COMPOSE_PROD_YAML),prod)
ifeq ($(APP_ENV),prod)
COMPOSE = docker compose -f compose.yaml -f compose.prod.yaml $(ENV_FILES)
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
CONTAINER_PHP_NO_TTY      = $(EXEC_NO_TTY) php
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

# --- REQUIRES ---

include .make/requires.mk

# --- EXTEND THE MAIN MAKEFILE ---

ifneq ($(APP_ENV),prod)
-include $(sort $(wildcard $(MAKE_LOCAL_MK)))
endif

## — 🐳 🎵 THE SYMFONY STARTER MAKEFILE 🎵 🐳 —————————————————————————————————

.DEFAULT_GOAL = help
.PHONY: help
help: f ?=
help: ## Display this help message with available commands
	@printf "Usage: make $(G)<target>$(S)\n"
	@printf "       make $(G)f=<find>$(S)\n"
	@grep -E '(^[.a-zA-Z_-]+[^:]+:.*##.*?$$)|(^#{2})' $(MAKEFILE_LIST) | awk -v find="$(f)" 'BEGIN {FS = "## "}\
	function show(targets, description) {\
		split(targets, parts, " "); target = parts[1]; alias = parts[2];\
		n = split(description, fields, / \| /); params = (n >= 2) ? " " fields[2] : ""; example = (n >= 3) ? " (e.g. make " target " " fields[3] ")" : "";\
		printf "\033[32m  %-36s \033[35m%-2s \033[0m%s\033[36m%s\033[0m\n", target params, alias, fields[1], example;\
	} {\
		split($$1, line, ":"); targets=line[2]; description=$$2;\
		if      (find == "" && targets == "##")                    printf "\033[33m%s\n", "";\
		else if (find == "" && targets == "" && description != "") printf "\033[33m\n%s\n", description;\
		else if (find == "" && targets != "" && description != "") show(targets, description);\
		else if (targets != "" && description != "" && (index(tolower(targets), tolower(find)) || index(tolower(description), tolower(find)))) show(targets, description);\
	}'
	@echo

##

.PHONY: install
install: up_detached ## Start the project, install dependencies and show info
	$(MAKE) composer_install
	-$(MAKE) assets
	$(MAKE) images permissions git_hooks_init info

.PHONY: info
info: ## Show project access info
	@printf "\n$(Y)--- Info ---$(S)\n"
	@printf " $(Y)›$(S) Copy $(Y)$(MAKE_LOCAL_MK_DIST)$(S) to $(G)$(MAKE_LOCAL_MK)$(S) (ignored by Git) to extend the Makefile with your own local commands.\n"
	@printf " $(Y)›$(S) Run $(Y). aliases$(S) or $(Y)source aliases$(S) to create bash aliases for main make commands ($(G)symfony$(S), $(G)php$(S), $(G)composer$(S), ...)\n"
	@printf " $(Y)›$(S) Access to the application (accept the auto-generated TLS certificate):\n"
	@printf "    - Homepage ....... $(G)$(LOCALHOST)/$(S)\n"
ifneq ($(wildcard $(VENDOR_API)),)
	@printf "    - API ............ $(G)$(LOCALHOST_API)$(S)\n"
endif
ifneq ($(wildcard $(VENDOR_EASYADMIN)),)
	@printf "    - EasyAdmin ...... $(G)$(LOCALHOST_ADMIN)$(S)\n"
endif
ifneq ($(wildcard $(VENDOR_PROFILER)),)
	@printf "    - Profiler ....... $(G)$(LOCALHOST_PROFILER)$(S)\n"
endif
ifneq ($(wildcard $(VENDOR_MAILER)),)
	@printf "    - Mail Catcher ... $(G)$(LOCALHOST_MAILER)$(S)\n"
endif

##

.PHONY: start
start: up_detached images info ## Start the project and show info (detached mode)

.PHONY: stop
stop: down ## Stop the project (down)

##

.PHONY: restart
restart: ## [Level 1] Standard restart - Reloading containers (triggers: .env, compose.yaml, code changes)
	@printf " $(G)🔄 [Level 1] Standard restart - Reloading containers...$(S)\n"
	$(MAKE) stop start

build_start: ## [Level 2] Build & Start - Updating image with cache (triggers: composer.lock, CaddyFile, *.ini, entrypoint.sh)
	@printf " $(Y)🏗️ [Level 2] Build & Start - Updating image with cache...$(S)\n"
	$(MAKE) build start

build_force_start: ## [Level 3] Force build & Start - Rebuilding from scratch (triggers: Dockerfile, system packages, cache issues)
	@printf " $(R)🏗️ [Level 3] Force build & Start - Rebuilding from scratch...$(S)\n"
	$(MAKE) build_force start

##

check:  ## Check everything before you deliver - Composer, Doctrine validation, linters, ... (no stop on failure)
	@printf " $(Y)›$(S) 💡 Tip: enrich $(G)check$(S) in Makefile as your project matures\n"
	-$(MAKE) composer_validate
	@#-$(MAKE) validate         # Doctrine mapping validation
	@#-$(MAKE) lint             # Twig, YAML, container linters (phpcsfixer, twigcsfixer, phpstan)
	@#-$(MAKE) phpstan_lint     # Static analysis only

check_all: check ## Check everything before you deliver - check + tests (no stop on failure)
	@#-$(MAKE) tests            # Full test suite (better left to CI)

check_push: ## Check on git push (stop on failure)
	@printf " $(Y)›$(S) 💡 Tip: enrich $(G)check_push$(S) in Makefile as your project matures\n"
	$(MAKE) composer_validate
	@#$(MAKE) validate         # Doctrine mapping validation
	@#$(MAKE) lint             # Twig, YAML, container linters (phpcsfixer, twigcsfixer, phpstan)
	@#$(MAKE) phpstan_lint     # Static analysis only
	@#$(MAKE) tests            # Full test suite (better left to CI)

.PHONY: tests t
tests t: db_init@test fixtures@test phpunit ## Run all tests

## — DOCKER 🐳 ————————————————————————————————————————————————————————————————

.PHONY: build
build: ## Build or rebuild Docker services using cache | [a=<args>] | a=--no-cache
	$(COMPOSE) build $(a)

.PHONY: build_force
build_force: a=--no-cache
build_force: build ## Build or rebuild Docker services without cache (force fresh install)

##

.PHONY: up
up: ## Start the containers | [a=<args>] | a=-d
	$(UP_ENV) $(COMPOSE) up --remove-orphans $(a)
	$(MAKE) runtime
	$(MAKE) permissions
	$(MAKE) safe

up_detached: a=-d
up_detached: up ## Start the containers (wait for services to be running|healthy - detached mode)

##

.PHONY: down
down: ## Stop the containers
	-$(COMPOSE) down

.PHONY: kill
kill: ## Remove containers and networks (keep database data)
	$(COMPOSE) down --remove-orphans

.PHONY: kill_all
kill_all: confirm ## Remove containers, networks AND VOLUMES (database destroyed)
	$(COMPOSE) down --remove-orphans --volumes

deep_clean: confirm ## [Danger] Remove containers, volumes, networks and images, including orphans (triggers: webapp-pack, database, branch switch) [y/N]
	@printf "🔥 $(Y)Cleaning Docker environment for $(PROJECT_NAME) (if file exists)...$(S)\n"
	-$(COMPOSE) down --volumes --rmi local --remove-orphans 2>/dev/null || true

	@printf "🔥 $(Y)Force clean everything else using Docker labels (works even if compose.yaml is missing)...$(S)\n"
	-docker ps -a --filter "label=com.docker.compose.project=$(PROJECT_NAME)" -q | xargs -r docker rm -f
	-docker network ls --filter "label=com.docker.compose.project=$(PROJECT_NAME)" -q | xargs -r docker network rm
	-docker volume ls --filter "label=com.docker.compose.project=$(PROJECT_NAME)" -q | xargs -r docker volume rm

	@printf "🔥 $(Y)Cleaning project images...$(S)\n"
	-docker images --filter "reference=$(IMAGES_PREFIX)*" -q | xargs -r docker rmi -f

##

.PHONY: canonical
canonical: ## Parse, resolve, and render compose file in canonical format
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
symfony sf: ## Run any Symfony console command | [c=<command>] | c=cache:clear
	$(CONSOLE) $(c)

.PHONY: console
console: ## Symfony console alias | [c=<command>] | c=cache:clear
	$(CONSOLE) $(c)

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
php: ## Run PHP command | [a=<args>] | a=--version
	$(PHP) $(a)

##

php_command: ## Run a command inside the PHP container | [a=<args>] | a="ls -al"
	$(BASH_COMMAND) "$(a)"

php_env: ## Display all environment variables set within the PHP container
	$(CONTAINER_PHP) env

.PHONY: sh
php_sh sh: ## Connect to the PHP container shell
	$(CONTAINER_PHP) sh

## — COMPOSER 🧙 ——————————————————————————————————————————————————————————————

.PHONY: composer
composer: ## Run composer command | [a=<args>] | a="require --dev phpunit/phpunit"
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

.PHONY: config
config: ## Run composer config | k=<key> [v=<value>] | k=repositories.monolog-bundle v='{"type": "path", "url": "/monolog-bundle"}'
	$(if $(k),, $(error "Please specify a key with 'k=...'"))
	$(COMPOSER) config $(if $(v),$(k) '$(v)',--unset $(k))

.PHONY: hash
hash: ## Update only the content hash of composer.lock without updating dependencies
	$(COMPOSER) update --lock

.PHONY: outdated
outdated: ## Show a list of installed packages that have updates available, including their latest version
	$(COMPOSER) outdated

.PHONY: remove
remove: ## Remove a package from the require or require-dev | [a=<args>] | a="phpunit/phpunit"
	$(COMPOSER) remove $(a)

.PHONY: require
require: ## Add required packages to your composer.json and installs them | [a=<args>] | a="--dev phpunit/phpunit"
	$(COMPOSER) require $(a)

.PHONY: update
update: ## Update Composer packages | [a=<args>] | a="symfony/monolog-bundle"
	@printf "\n$(Y)--- Composer Update (env: $(APP_ENV)) ---$(S)\n"
ifeq ($(APP_ENV),prod)
	$(COMPOSER) update --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader $(a)
else
	$(COMPOSER) update $(a)
endif

ifneq ($(or $(ALL), $(wildcard $(VENDOR_DOCTRINE))),)
include .make/doctrine.mk
endif

ifneq ($(or $(ALL), $(wildcard $(VENDOR_MONOLOG))),)
include .make/monolog.mk
endif

ifneq ($(or $(ALL), $(wildcard $(BIN_PHPUNIT))),)
include .make/phpunit.mk
endif

ifneq ($(or $(ALL), $(wildcard $(VENDOR_PHPCSFIXER)), $(wildcard $(VENDOR_PHPMD)), $(wildcard $(VENDOR_PHPMETRICS)), $(wildcard $(VENDOR_PHPSTAN)), $(wildcard $(VENDOR_TWIGCSFIXER))),)
include .make/quality.mk
endif

ifneq ($(or $(ALL), $(wildcard $(VENDOR_ASSETS))),)
include .make/assets.mk
endif

ifneq ($(or $(ALL), $(wildcard $(VENDOR_TRANSLATION))),)
include .make/translation.mk
endif

include .make/end.mk

-include .make/contrib.mk

-include .make/generate.mk
