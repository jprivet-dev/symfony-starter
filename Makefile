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
# SYMFONY
#

# End of bug fixes: November 2026 - See https://symfony.com/releases
SYMFONY_LTS_VERSION=6.*

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
$(info Warning: You are in the PROD environment)
endif

# See https://symfony.com/doc/current/deployment.html#b-configure-your-environment-variables
ifneq ($(wildcard .env.local.php),)
$(info Warning: It is not possible to use variables from .env.local.php file)
endif

#
# INSTALLATION
# These variables and commands are for initial setup and can be removed after saving the project.
#

REPOSITORY = git@github.com:dunglas/symfony-docker.git
CLONE_DIR  = clone

#
# DOCKER OPTIONS
# See https://github.com/dunglas/symfony-docker/blob/main/docs/options.md
#

UP_ENV ?=

define append
  ifneq ($($1),)
    UP_ENV += $1=$($1)
  endif
endef

$(eval $(call append,XDEBUG_MODE))
$(eval $(call append,SERVER_NAME))
$(eval $(call append,SYMFONY_VERSION))
$(eval $(call append,STABILITY))
$(eval $(call append,HTTP_PORT))
$(eval $(call append,HTTPS_PORT))
$(eval $(call append,HTTP3_PORT))

# Will be ":PORT" if HTTPS_PORT is defined and not 443, otherwise empty.
HTTPS_PORT_SUFFIX = $(if $(HTTPS_PORT),$(if $(filter-out 443,$(HTTPS_PORT)),:$(HTTPS_PORT)))

# Will be ":PORT" if HTTP_PORT is defined, otherwise empty.
HTTP_PORT_SUFFIX = $(if $(HTTP_PORT),:$(HTTP_PORT))

#
# DOCKER COMMANDS
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
help: ## Display this help message with available commands
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

.PHONY: info
info: ## Show project access info
	@printf "\n$(Y)Info$(S)"
	@printf "\n$(Y)----$(S)\n\n"
	@printf "* Your application is available at:\n"
	@printf "  - $(G)https://localhost$(HTTPS_PORT_SUFFIX)/$(S)\n"
	@printf "  - $(G)http://localhost$(HTTP_PORT_SUFFIX)/$(S)\n"
	@printf "\n"

##

# These targets are for initial setup and can be removed after saving the project.
.PHONY: generate
generate: clone build up_detached permissions info ## Generate a fresh Symfony application with Docker configuration (stable release)

# These targets are for initial setup and can be removed after saving the project.
.PHONY: generate@lts
generate@lts: ## Generate a fresh Symfony application with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION) $(MAKE) generate

# These targets are for initial setup and can be removed after saving the project.
.PHONY: clone
clone: ## Clone and extract 'dunglas/symfony-docker' configuration files at the root
	@printf "\n$(Y)Clone 'dunglas/symfony-docker'$(S)"
	@printf "\n$(Y)------------------------------$(S)\n\n"
ifeq ($(wildcard Dockerfile),)
	@printf "Repository: $(Y)$(REPOSITORY)$(S)\n"
	git clone $(REPOSITORY) $(CLONE_DIR) --depth 1
	@printf "\n$(Y)Extract 'dunglas/symfony-docker' at the root$(S)"
	@printf "\n$(Y)--------------------------------------------$(S)\n\n"
	rsync -av --exclude=".editorconfig" --exclude=".git" --exclude=".gitattributes" --exclude=".github" --exclude="docs" --exclude="LICENSE" --exclude="README.md" $(CLONE_DIR)/ .
	rm -rf $(CLONE_DIR)
	@printf " $(G)✔$(S) 'dunglas/symfony-docker' cloned and extracted at the root.\n\n"
else
	@printf " $(R)⨯$(S) 'dunglas/symfony-docker' configuration already present at the root.\n\n"
endif

clear_all: clear_skeleton clear_docker ## Execute clear_skeleton & clear_docker commands

clear_skeleton: down ## Remove all Symfony application files (symfony/skeleton)
	@printf "\n$(Y)Remove all symfony/skeleton files$(S)"
	@printf "\n$(Y)---------------------------------$(S)\n\n"
	rm -rf bin config public src var vendor
	rm  -f .env .env.dev .gitignore composer.json composer.lock symfony.lock
	git restore LICENSE

clear_docker: down ## Remove all 'dunglas/symfony-docker' configuration files
	@printf "\n$(Y)Remove all 'dunglas/symfony-docker' files$(S)"
	@printf "\n$(Y)-----------------------------------------$(S)\n\n"
	rm -rf frankenphp
	rm  -f .dockerignore compose.override.yaml compose.prod.yaml compose.yaml Dockerfile

## — SYMFONY 🎵 ———————————————————————————————————————————————————————————————

.PHONY: symfony
symfony sf: ## Run Symfony console command - Usage: make symfony ARG="cache:clear"
	$(CONSOLE) $(ARG)

.PHONY: cc
cc: ## Clear the Symfony cache
	$(CONSOLE) cache:clear

.PHONY: about
about: ## Display information about the current Symfony project
	$(CONSOLE) about

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

php_sh: ## Connect to the PHP container shell
	$(CONTAINER_PHP) sh

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

## — DOCKER 🐳 ————————————————————————————————————————————————————————————————

.PHONY: up
up: ## Start the containers - $ make up [ARG=<arguments>] - Example: $ make up ARG=-d
	$(UP_ENV) $(COMPOSE) up --remove-orphans --pull always $(ARG)

up_detached: ARG=--wait -d
up_detached: up ## Start the containers (wait for services to be running|healthy - detached mode)

.PHONY: down
down: ## Stop and remove the containers
	-$(COMPOSE) down --remove-orphans

.PHONY: build
build: ## Build or rebuild Docker services - $ make build [ARG=<arguments>] - Example: $ make build ARG=--no-cache
	$(COMPOSE) build $(ARG)

.PHONY: logs
logs: ## Display container logs
	$(COMPOSE) logs -f

.PHONY: config
config: ## Parse, resolve, and render compose file in canonical format
	$(COMPOSE) config

## — TROUBLESHOOTING 😵️ ———————————————————————————————————————————————————————

.PHONY: permissions
permissions p: ## Fix file permissions (primarily for Linux hosts)
ifeq ($(UNAME_S),Linux)
	$(COMPOSE) run --rm php chown -R $(USER) .
	@printf " $(G)✔$(S) You are now defined as the owner $(Y)$(USER)$(S) of the project files.\n"
else
	@printf " $(Y)Info:$(S) 'make permissions' is typically not needed on $(UNAME_S).\n"
endif

## — UTILITIES 🛠️ ——————————————————————————————————————————————————————————————

.PHONY: vars
vars: ## Show key Makefile variables
	@printf "\n$(Y)Vars$(S)"
	@printf "\n$(Y)----$(S)\n\n"
	@printf "USER      : $(USER)\n"
	@printf "UNAME_S   : $(UNAME_S)\n"
	@printf "APP_ENV   : $(APP_ENV)\n"
	@printf "REPOSITORY: $(REPOSITORY)\n"
	@printf "CLONE_DIR : $(CLONE_DIR)\n"
	@printf "UP_ENV    : $(UP_ENV)\n"
	@printf "COMPOSE_V2: $(COMPOSE_V2)\n"
	@printf "COMPOSE   : $(COMPOSE)\n"
