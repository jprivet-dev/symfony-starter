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

#
# SYMFONY ENVIRONMENT VARIABLES
#

# Files in order of increasing priority.
# https://github.com/jprivet-dev/makefiles/tree/main/symfony-env-include
# https://www.gnu.org/software/make/manual/html_node/Environment.html
# https://github.com/symfony/recipes/issues/18
# https://symfony.com/doc/current/quick_tour/the_architecture.html#environment-variables
# https://symfony.com/doc/current/configuration.html#listing-environment-variables
# https://symfony.com/doc/current/configuration.html#overriding-environment-values-via-env-local
-include .env
-include .env.local

# get APP_ENV original value
FILE_ENV := $(APP_ENV)
-include .env.$(FILE_ENV)
-include .env.$(FILE_ENV).local

ifneq ($(FILE_ENV),$(APP_ENV))
$(info Warning: APP_ENV is overloaded outside .env and .env.local files)
endif

ifeq ($(FILE_ENV),prod)
$(info Warning: Your are in the PROD environment)
else ifeq ($(FILE_ENV),test)
$(info Warning: Your are in the TEST environment)
endif

# https://symfony.com/doc/current/deployment.html#b-configure-your-environment-variables
ifneq ($(wildcard .env.local.php),)
$(info Warning: It is not possible to use variables from .env.local.php file)
$(info Warning: The final APP_ENV of that Makefile may be different from the APP_ENV of .env.local.php)
endif

#
# DOCKER
#

COMPOSE_V2 := $(shell docker compose version 2> /dev/null)

ifndef COMPOSE_V2
$(error Docker Compose CLI plugin is required but is not available on your system)
endif

COMPOSE = docker compose -p $(PROJECT_NAME)

ifeq ($(FILE_ENV),prod)
COMPOSE = $(COMPOSE) -f compose.yaml -f compose.prod.yaml
endif

CONTAINER_PHP = $(COMPOSE) exec php
PHP           = $(CONTAINER_PHP) php
COMPOSER      = $(CONTAINER_PHP) composer
CONSOLE       = $(PHP) bin/console

#
# BASE
#

CLONE_DIR  = clone
REPOSITORY = git@github.com:dunglas/symfony-docker.git

#
# OPTIONS
# https://github.com/dunglas/symfony-docker/blob/main/docs/options.md
#

PROJECT_NAME    ?= $(shell basename $(CURDIR))
SERVER_NAME     ?= $(PROJECT_NAME).localhost
UP_ENV          ?=

ifneq ($(SERVER_NAME),)
UP_ENV += SERVER_NAME=$(SERVER_NAME)
endif

ifneq ($(SYMFONY_VERSION),)
UP_ENV += SYMFONY_VERSION=$(SYMFONY_VERSION)
endif

ifneq ($(HTTP_PORT),)
UP_ENV += HTTP_PORT=$(HTTP_PORT)
endif

ifneq ($(HTTPS_PORT),)
UP_ENV += HTTPS_PORT=$(HTTPS_PORT)
endif

ifneq ($(HTTP3_PORT),)
UP_ENV += HTTP3_PORT=$(HTTP3_PORT)
endif

## — 🐳 🎵 THE SYMFONY STARTER MAKEFILE 🎵 🐳 —————————————————————————————————

# Print self-documented Makefile:
# $ make
# $ make help

.DEFAULT_GOAL = help
.PHONY: help
help: ## Print self-documented Makefile
	@grep -E '(^[.a-zA-Z_-]+[^:]+:.*##.*?$$)|(^#{2})' Makefile | awk 'BEGIN {FS = "## "}; { \
		split($$1, line, ":"); targets=line[1]; description=$$2; \
		if (targets == "##") { \
			printf "\033[33m%s\n", ""; # space \
		} else if (targets == "" && description != "") { \
			printf "\033[33m\n%s\n", description; # title \
		} else if (targets != "" && description != "") { \
			split(targets, parts, " "); target=parts[1]; alias=parts[2]; \
			printf "\033[32m  %-26s \033[34m%-2s \033[0m%s\n", target, alias, description; # target alias: description \
		} \
	}'
	@echo

## — PROJECT 🚀 ———————————————————————————————————————————————————————————————

.PHONY: generate
generate: clone build upd permissions info ## Generate a fresh Symfony application with the Docker configuration

.PHONY: start
start: upd info ## Start the project (implies detached mode)

.PHONY: stop
stop: down ## Stop the project

.PHONY: clean
clean: stop ## Stop the project, remove all generated files and restore original files
	@printf "\n$(Y)Clean$(S)"
	@printf "\n$(Y)-----$(S)\n\n"
	rm -rf $(CLONE_DIR).github bin config docs frankenphp public src var vendor
	rm  -f \
      .dockerignore .editorconfig .env .env.dev .gitattributes \
      compose.override.yaml compose.prod.yaml compose.yaml \
      composer.json composer.lock Dockerfile symfony.lock
	git restore LICENSE
	-git restore .gitignore

PHONY: info
info: ## Show info
	@printf "\n$(Y)Info$(S)"
	@printf "\n$(Y)----$(S)\n\n"
	@printf "* Run $(Y)make$(S) to see all shorcuts for the most common tasks.\n"
	@printf "* Go on $(G)https://$(SERVER_NAME)/$(S)\n"

## — SYMFONY 🎵 ———————————————————————————————————————————————————————————————

.PHONY: symfony
symfony sf: ## Run Symfony - $ make symfony [p=<params>] - Example: $ make symfony p=cache:clear
	$(CONSOLE) $(p)

.PHONY: cc
cc: ## Clear the cache
	$(CONSOLE) cache:clear

.PHONY: cw
cw: ## Warm up an empty cache
	$(CONSOLE) cache:warmup --no-debug

.PHONY: about
about: ## Display information about the current project
	@printf "\n$(Y)About$(S)"
	@printf "\n$(Y)-----$(S)\n\n"
	-$(CONSOLE) about

.PHONY: dumpenv
dumpenv: ## Generate .env.local.php (PROD)
	$(COMPOSER) dump-env prod

## — PHP 🐘 ———————————————————————————————————————————————————————————————————

.PHONY: php
php: ## Run PHP - $ make php [p=<params>]- Example: $ make php p=--version
	$(PHP) $(p)

php_sh: ## Connect to the PHP container
	$(CONTAINER_PHP) sh

## — COMPOSER 🧙 ——————————————————————————————————————————————————————————————

.PHONY: composer
composer: ## Run composer - $ make composer [p=<params>] - Example: $ make composer p="require --dev phpunit/phpunit"
	$(COMPOSER) $(p)

composer_install: ## Install packages using composer
ifeq ($(FILE_ENV),prod)
	$(COMPOSER) install --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader
else
	$(COMPOSER) install
endif

composer_update: ## Update packages using composer
ifeq ($(FILE_ENV),prod)
	$(COMPOSER) update --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader
else
	$(COMPOSER) update
endif

## — SYMFONY DOCKER 🎵 🐳 —————————————————————————————————————————————————————

PHONY: clone
clone: ## Clone Symfony Docker
	@printf "\n$(Y)Clone Symfony Docker$(S)"
	@printf "\n$(Y)--------------------$(S)\n\n"
ifeq ($(wildcard Dockerfile),)
	@printf "Repository: $(Y)$(REPOSITORY)$(S)\n"
	git clone $(REPOSITORY) $(CLONE_DIR)
	@printf "\n$(Y)Extract Symfony Docker at the root$(S)"
	@printf "\n$(Y)----------------------------------$(S)\n\n"
	rm -rf $(CLONE_DIR)/.git
	rm  -f $(CLONE_DIR)/README.md
	-mv -vf $(CLONE_DIR)/.*
	-mv -vf $(CLONE_DIR)/* .
	rm -rf $(CLONE_DIR)
	@printf " $(G)✔$(S) Symfony Docker cloned and extracted at the root.\n\n"
else
	@printf " $(R)⨯$(S) Symfony Docker already cloned and extracted at the root.\n\n"
endif

## — DOCKER 🐳 ————————————————————————————————————————————————————————————————

.PHONY: up
up: ## Start the container - $ make up [p=<params>] - Example: $ make up p=-d (wait for services to be running|healthy)
	@printf "\n$(Y)Up$(S)"
	@printf "\n$(Y)--$(S)\n\n"
	$(UP_ENV) $(COMPOSE) up --remove-orphans --pull always --wait $(p)

.PHONY: upd
upd: p=-d
upd: up ## Start the container (detached mode by default)

.PHONY: down
down: ## Stop the container
	@printf "\n$(Y)Down$(S)"
	@printf "\n$(Y)----$(S)\n\n"
	$(COMPOSE) down --remove-orphans

.PHONY: build
build: ## Build or rebuild services - $ make build [p=<params>] - Example: $ make build p=--no-cache
	@printf "\n$(Y)Build$(S)"
	@printf "\n$(Y)-----$(S)\n\n"
	$(COMPOSE) build $(p)

.PHONY: logs
logs: ## the container’s logs
	$(COMPOSE) logs -f

## — TROUBLESHOOTING 😵‍️ ———————————————————————————————————————————————————————

.PHONY: permissions
permissions p: ## Run it if you cannot edit some of the project files on Linux (https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md)
	@printf "\n$(Y)Permissions (Linux)$(S)"
	@printf "\n$(Y)-------------------$(S)\n\n"
ifeq ($(PERMISSIONS),on)
	$(COMPOSE) run --rm php chown -R $(USER_ID):$(GROUP_ID) .
	@printf " $(G)✔$(S) You are now defined as the owner $(Y)$(USER_ID):$(GROUP_ID)$(S) of the project files.\n"
else
	@printf " $(R)⨯$(S) Nothing to do (add PERMISSIONS=on to .env.local to activate permissions command).\n"
endif

## — UTILS 🛠️  —————————————————————————————————————————————————————————————————

.PHONY: vars
vars: ## Show variables
	@printf "\n$(Y)Vars$(S)"
	@printf "\n$(Y)----$(S)\n\n"
	@printf "$(G)USER$(S)\n"
	@printf "  USER_ID : $(USER_ID)\n"
	@printf "  GROUP_ID: $(GROUP_ID)\n"
	@printf "$(G)BASE$(S)\n"
	@printf "  CLONE_DIR : $(CLONE_DIR)\n"
	@printf "  REPOSITORY: $(REPOSITORY)\n"
	@printf "$(G)OPTIONS$(S)\n"
	@printf "  PERMISSIONS : $(PERMISSIONS)\n"
	@printf "  PROJECT_NAME: $(PROJECT_NAME)\n"
	@printf "  UP_ENV      : $(UP_ENV)\n"
	@printf "$(G)SYMFONY ENVIRONMENT VARIABLES$(S)\n"
	@printf "  APP_ENV   : $(APP_ENV)\n"
	@printf "  APP_SECRET: $(APP_SECRET)\n"
	@printf "$(G)DOCKER$(S)\n"
	@printf "  COMPOSE_V2: $(COMPOSE_V2)\n"
	@printf "  COMPOSE   : $(COMPOSE)\n"
