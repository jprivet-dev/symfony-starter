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
# SYMFONY ENVIRONMENT VARIABLES
#

# Files in order of increasing priority.
# See https://github.com/jprivet-dev/makefiles/tree/main/symfony-env-include
# See https://www.gnu.org/software/make/manual/html_node/Environment.html
# See https://github.com/symfony/recipes/issues/18
# See https://symfony.com/doc/current/quick_tour/the_architecture.html#environment-variables
# See https://symfony.com/doc/current/configuration.html#listing-environment-variables
# See https://symfony.com/doc/current/configuration.html#overriding-environment-values-via-env-local
-include .env
-include .env.local
-include .env.$(APP_ENV)
-include .env.$(APP_ENV).local

ifeq ($(APP_ENV),prod)
$(info Warning: Your are in the PROD environment)
endif

# See https://symfony.com/doc/current/deployment.html#b-configure-your-environment-variables
ifneq ($(wildcard .env.local.php),)
$(info Warning: It is not possible to use variables from .env.local.php file)
endif

#
# BASE
#

REPOSITORY = git@github.com:dunglas/symfony-docker.git
CLONE_DIR  = clone

#
# OPTIONS
# See https://github.com/dunglas/symfony-docker/blob/main/docs/options.md
#

UP_ENV ?=

ifneq ($(XDEBUG_MODE),)
UP_ENV += XDEBUG_MODE=$(XDEBUG_MODE)
endif

ifneq ($(SERVER_NAME),)
UP_ENV += SERVER_NAME=$(SERVER_NAME)
endif

ifneq ($(SYMFONY_VERSION),)
UP_ENV += SYMFONY_VERSION=$(SYMFONY_VERSION)
endif

ifneq ($(STABILITY),)
UP_ENV += STABILITY=$(STABILITY)
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

#
# DOCKER
#

COMPOSE_V2 := $(shell docker compose version 2> /dev/null)

ifndef COMPOSE_V2
$(error Docker Compose CLI plugin is required but is not available on your system)
endif

COMPOSE = docker compose

ifeq ($(APP_ENV),prod)
COMPOSE = $(COMPOSE) -f compose.yaml -f compose.prod.yaml
endif

CONTAINER_PHP = $(COMPOSE) exec php
PHP           = $(CONTAINER_PHP) php
COMPOSER      = $(CONTAINER_PHP) composer
CONSOLE       = $(PHP) bin/console

## — 🐳 🎵 THE SYMFONY STARTER MAKEFILE 🎵 🐳 —————————————————————————————————

# Print self-documented Makefile:
# $ make
# $ make help

.DEFAULT_GOAL = help
.PHONY: help
help: ## Print self-documented Makefile
	@grep -E '(^[.a-zA-Z_-]+[^:]+:.*##.*?$$)|(^#{2})' Makefile | awk 'BEGIN {FS = "## "}; { \
		split($$1, line, ":"); targets=line[1]; description=$$2; \
		if (targets == "##") { printf "\033[33m%s\n", ""; } \
		else if (targets == "" && description != "") { printf "\033[33m\n%s\n", description; } \
		else if (targets != "" && description != "") { split(targets, parts, " "); target=parts[1]; alias=parts[2]; printf "\033[32m  %-26s \033[34m%-2s \033[0m%s\n", target, alias, description; } \
	}'
	@echo

## — PROJECT 🚀 ———————————————————————————————————————————————————————————————

.PHONY: start
start: up_detached info ## Start the project and show info (up_detached & info alias)

.PHONY: stop
stop: down ## Stop the project (down alias)

PHONY: info
info: ## Show info
	@printf "\n$(Y)Info$(S)"
	@printf "\n$(Y)----$(S)\n\n"
	@printf "* Go on $(G)https://localhost/$(S)\n"
	@printf "\n"

##

.PHONY: generate
generate: clone build up_detached info ## Generate a fresh Symfony application with the dunglas/symfony-docker configuration

PHONY: clone
clone: ## Clone and extract dunglas/symfony-docker at the root
	@printf "\n$(Y)Clone dunglas/symfony-docker$(S)"
	@printf "\n$(Y)----------------------------$(S)\n\n"
ifeq ($(wildcard Dockerfile),)
	@printf "Repository: $(Y)$(REPOSITORY)$(S)\n"
	git clone $(REPOSITORY) $(CLONE_DIR) --depth 1
	@printf "\n$(Y)Extract dunglas/symfony-docker at the root$(S)"
	@printf "\n$(Y)------------------------------------------$(S)\n\n"
	mv -vf $(CLONE_DIR)/frankenphp .
	mv -vf $(CLONE_DIR)/.dockerignore .
	mv -vf $(CLONE_DIR)/compose.override.yaml .
	mv -vf $(CLONE_DIR)/compose.prod.yaml .
	mv -vf $(CLONE_DIR)/compose.yaml .
	mv -vf $(CLONE_DIR)/Dockerfile .
	rm -rf $(CLONE_DIR)
	@printf " $(G)✔$(S) dunglas/symfony-docker cloned and extracted at the root.\n\n"
else
	@printf " $(R)⨯$(S) dunglas/symfony-docker already cloned and extracted at the root.\n\n"
endif

clear_docker: down ## Remove all dunglas/symfony-docker files
	@printf "\n$(Y)Remove all dunglas/symfony-docker files$(S)"
	@printf "\n$(Y)---------------------------------------$(S)\n\n"
	rm -rf frankenphp
	rm  -f .dockerignore compose.override.yaml compose.prod.yaml compose.yaml Dockerfile

clear_skeleton: down ## Remove all symfony/skeleton files
	@printf "\n$(Y)Remove all symfony/skeleton files$(S)"
	@printf "\n$(Y)---------------------------------$(S)\n\n"
	rm -rf bin config public src var vendor
	rm  -f .env .env.dev .gitignore composer.json composer.lock symfony.lock
	git restore LICENSE

## — SYMFONY 🎵 ———————————————————————————————————————————————————————————————

.PHONY: symfony
symfony sf: ## Run Symfony - $ make symfony [ARG=<arguments>] - Example: $ make symfony ARG=cache:clear
	$(CONSOLE) $(ARG)

.PHONY: cc
cc: ## Clear the cache
	$(CONSOLE) cache:clear

.PHONY: about
about: ## Display information about the current project
	$(CONSOLE) about

.PHONY: dotenv
dotenv: ## Lists all dotenv files with variables and values
	$(CONSOLE) debug:dotenv

.PHONY: dumpenv
dumpenv: ## Generate .env.local.php
	$(COMPOSER) dump-env prod

## — PHP 🐘 ———————————————————————————————————————————————————————————————————

.PHONY: php
php: ## Run PHP - $ make php [ARG=<arguments>]- Example: $ make php ARG=--version
	$(PHP) $(ARG)

php_sh: ## Connect to the PHP container
	$(CONTAINER_PHP) sh

## — COMPOSER 🧙 ——————————————————————————————————————————————————————————————

.PHONY: composer
composer: ## Run composer - $ make composer [ARG=<arguments>] - Example: $ make composer ARG="require --dev phpunit/phpunit"
	$(COMPOSER) $(ARG)

composer_install: ## Install packages using composer
ifeq ($(APP_ENV),prod)
	$(COMPOSER) install --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader
else
	$(COMPOSER) install
endif

composer_update: ## Update packages using composer
ifeq ($(APP_ENV),prod)
	$(COMPOSER) update --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader
else
	$(COMPOSER) update
endif

## — DOCKER 🐳 ————————————————————————————————————————————————————————————————

.PHONY: up
up: ## Start the containers - $ make up [ARG=<arguments>] - Example: $ make up ARG=-d
	$(UP_ENV) $(COMPOSE) up --remove-orphans --pull always $(ARG)

up_detached: ARG=--wait -d
up_detached: up ## Start the containers (wait for services to be running|healthy - detached mode)

.PHONY: down
down: ## Stop the containers
	$(COMPOSE) down --remove-orphans

.PHONY: build
build: ## Build or rebuild services - $ make build [ARG=<arguments>] - Example: $ make build ARG=--no-cache
	$(COMPOSE) build $(ARG)

.PHONY: logs
logs: ## the container’s logs
	$(COMPOSE) logs -f

.PHONY: config
config: ## Parse, resolve and render compose file in canonical format
	$(COMPOSE) config

## — TROUBLESHOOTING 😵‍️ ———————————————————————————————————————————————————————

.PHONY: permissions
permissions p: ## Run it if you cannot edit some of the project files on Linux
	$(COMPOSE) run --rm php chown -R $(USER) .
	@printf " $(G)✔$(S) You are now defined as the owner $(Y)$(USER)$(S) of the project files.\n"

## — UTILS 🛠️  —————————————————————————————————————————————————————————————————

.PHONY: vars
vars: ## Show some Makefile variables
	@printf "\n$(Y)Vars$(S)"
	@printf "\n$(Y)----$(S)\n\n"
	@printf "USER      : $(USER)\n"
	@printf "APP_ENV   : $(APP_ENV)\n"
	@printf "REPOSITORY: $(REPOSITORY)\n"
	@printf "CLONE_DIR : $(CLONE_DIR)\n"
	@printf "UP_ENV    : $(UP_ENV)\n"
	@printf "COMPOSE_V2: $(COMPOSE_V2)\n"
	@printf "COMPOSE   : $(COMPOSE)\n"
