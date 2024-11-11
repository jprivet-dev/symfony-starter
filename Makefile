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
# BASE
#

APP_DIR    = app
REPOSITORY = git@github.com:dunglas/symfony-docker.git

#
# OVERLOADING
#

-include .overload

PROJECT_NAME           ?= $(shell basename $(CURDIR))
COMPOSE_BUILD_OPTS     ?=
COMPOSE_UP_SERVER_NAME ?= $(PROJECT_NAME).localhost
COMPOSE_UP_ENV_VARS    ?=

#
# SYMFONY ENVIRONMENT VARIABLES
#

# Files in order of increasing priority.
# @see https://github.com/jprivet-dev/makefiles/tree/main/symfony-env-include
# @see https://www.gnu.org/software/make/manual/html_node/Environment.html
# @see https://github.com/symfony/recipes/issues/18
# @see https://symfony.com/doc/current/quick_tour/the_architecture.html#environment-variables
# @see https://symfony.com/doc/current/configuration.html#listing-environment-variables
# @see https://symfony.com/doc/current/configuration.html#overriding-environment-values-via-env-local
-include $(APP_DIR)/.env
-include $(APP_DIR)/.env.local

# get APP_ENV original value
FILE_ENV := $(APP_ENV)
-include $(APP_DIR)/.env.$(FILE_ENV)
-include $(APP_DIR)/.env.$(FILE_ENV).local

ifneq ($(FILE_ENV),$(APP_ENV))
$(info Warning: APP_ENV is overloaded outside .env and .env.local files)
endif

ifeq ($(FILE_ENV),prod)
$(info Warning: Your are in the prod environment)
else ifeq ($(FILE_ENV),test)
$(info Warning: Your are in the test environment)
endif

# @see https://symfony.com/doc/current/deployment.html#b-configure-your-environment-variables
ifneq ($(wildcard $(APP_DIR)/.env.local.php),)
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

COMPOSE_BASE     = $(APP_DIR)/compose.yaml
COMPOSE_OVERRIDE = $(APP_DIR)/compose.override.yaml
COMPOSE_PROD     = $(APP_DIR)/compose.prod.yaml
COMPOSE_PREFIX   = APP_PATH=$(APP_PATH) DOCKER_PATH=$(DOCKER_PATH) docker compose -p $(PROJECT_NAME) -f $(COMPOSE_BASE)

ifeq ($(FILE_ENV),prod)
COMPOSE = $(COMPOSE_PREFIX) -f $(COMPOSE_PROD)
else
COMPOSE = $(COMPOSE_PREFIX) -f $(COMPOSE_OVERRIDE)
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
	@grep -E '(^[.a-zA-Z_-]+[^:]+:.*##.*?$$)|(^#{2})' Makefile \
	| awk 'BEGIN {FS = "## "}; \
		{ \
			split($$1, line, ":"); \
			targets=line[1]; \
			description=$$2; \
			if (targets == "##") { \
				# --- space --- \
				printf "\033[33m%s\n", ""; \
			} else if (targets == "" && description != "") { \
				# --- title --- \
				printf "\033[33m\n%s\n", description; \
			} else if (targets != "" && description != "") { \
				# --- target, alias, description --- \
				split(targets, parts, " "); \
				target=parts[1]; \
				alias=parts[2]; \
				printf "\033[32m  %-26s \033[34m%-2s \033[0m%s\n", target, alias, description; \
			} \
		}'
	@echo

## — PROJECT 🚀 ———————————————————————————————————————————————————————————————

.PHONY: generate
generate: confirm_continue clone build up_d permissions info ## Generate a fresh Symfony application with the Docker configuration

.PHONY: start
start: up_d info ## Start the project (implies detached mode)

.PHONY: stop
stop: down ## Stop the project

.PHONY: restart
restart: stop start ## Restart the project

##

.PHONY: clean
clean: confirm_continue ## Remove app directory [y/N]
	rm -rf app

##

PHONY: info
info i: ## Show info
	@$(MAKE) -s overload_file env_files vars
	@printf "\n$(Y)Info$(S)"
	@printf "\n$(Y)----$(S)\n\n"
	@printf "* Go on $(G)https://$(COMPOSE_UP_SERVER_NAME)/$(S)\n"
	@printf "* Run $(Y)make$(S) to see all shorcuts for the most common tasks.\n"
	@printf "* Run $(Y). aliases$(S) to load all the project aliases.\n"

## — SYMFONY 🎵 ———————————————————————————————————————————————————————————————

.PHONY: symfony
symfony sf: ## Run Symfony - $ make symfony [p=<params>] - Example: $ make symfony p=cache:clear
	@$(eval p ?=)
	$(CONSOLE) $(p)

.PHONY: cc
cc: ## Clear the cache
	$(CONSOLE) cache:clear

.PHONY: cw
cw: ## Warm up an empty cache
	$(CONSOLE) cache:warmup --no-debug

.PHONY: about
about: ## Display information about the current project
	$(CONSOLE) about

.PHONY: dotenv
dotenv: ## Lists all dotenv files with variables and values
	$(CONSOLE) debug:dotenv

.PHONY: dumpenv
dumpenv: ## Generate .env.local.php (PROD)
	$(COMPOSER) dump-env prod

## — PHP 🐘 ———————————————————————————————————————————————————————————————————

.PHONY: php
php: ## Run PHP - $ make php [p=<params>]- Example: $ make php p=--version
	@$(eval p ?=)
	$(PHP) $(p)

.PHONY: php_sh
php_sh: ## Connect to the PHP container
	$(CONTAINER_PHP) sh

.PHONY: php_version
php_version: ## PHP version number
	$(PHP) -v

.PHONY: php_modules
php_modules: ## Show compiled in modules
	$(PHP) -m

## — COMPOSER 🧙 ——————————————————————————————————————————————————————————————

.PHONY: composer
composer: ## Run composer - $ make composer [p=<params>] - Example: $ make composer p="require --dev phpunit/phpunit"
	@$(eval p ?=)
	$(COMPOSER) $(p)

.PHONY: composer_version
composer_version: ## Composer version
	$(COMPOSER) --version

.PHONY: composer_validate
composer_validate: ## Validate composer.json and composer.lock
	$(COMPOSER) validate --strict --lock

##

.PHONY: composer_install
composer_install: ## Install packages using composer
	$(COMPOSER) install

.PHONY: composer_install@prod
composer_install@prod: ## Install packages using composer (PROD)
	$(COMPOSER) install --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader

.PHONY: composer_update
composer_update: ## Update packages using composer
	$(COMPOSER) update

.PHONY: composer_update@prod
composer_update@prod: ## Update packages using composer (PROD)
	$(COMPOSER) update --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader

## — SYMFONY DOCKER 🎵 🐳 —————————————————————————————————————————————————————

PHONY: clone
clone: ## Clone Symfony Docker (forked version)
	@printf "\n$(Y)Clone Symfony Docker$(S)"
	@printf "\n$(Y)--------------------$(S)\n\n"
ifeq ($(wildcard $(APP_DIR)),)
	@printf "Repository: $(Y)$(REPOSITORY)$(S)\n"
	git clone $(REPOSITORY) $(APP_DIR)
	rm -rf $(APP_DIR)/.git
	@printf " $(G)✔$(S) Symfony Docker cloned in $(Y)$(APP_DIR)$(S).\n\n"
else
	@printf " $(G)✔$(S) Symfony Docker already cloned in $(Y)$(APP_DIR)$(S).\n\n"
endif

## — DOCKER 🐳 ————————————————————————————————————————————————————————————————

.PHONY: up
up: ## Start the container - $ make up [p=<params>] - Example: $ make up p=-d
	@$(eval p ?=)
	SERVER_NAME=$(COMPOSE_UP_SERVER_NAME) $(COMPOSE_UP_ENV_VARS) $(COMPOSE) up --pull always $(p)


.PHONY: up_d
up_d: ## Start the container (wait for services to be running|healthy - detached mode)
	$(MAKE) -s up p="--wait -d"

.PHONY: down
down: ## Stop the container
	$(COMPOSE) down --remove-orphans

.PHONY: build
build: ## Build or rebuild services - $ make build [p=<params>] - Example: $ make build p=--no-cache
	@$(eval p ?=)
	$(COMPOSE) build $(COMPOSE_BUILD_OPTS) $(p)

.PHONY: logs
logs: ## See the container’s logs
	$(COMPOSE) logs -f

##

.PHONY: docker_stop_all
docker_stop_all: confirm_continue ## Stop all running containers [y/N]
	docker stop $$(docker ps -a -q)

.PHONY: docker_remove_all
docker_remove_all: confirm_continue ## Remove all stopped containers [y/N]
	docker rm $$(docker ps -a -q)

## — TROUBLESHOOTING 😵‍️ ———————————————————————————————————————————————————————

.PHONY: permissions
permissions: ## Run it if you cannot edit some of the project files on Linux (https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md)
	@printf "\n$(Y)Permissions$(S)"
	@printf "\n$(Y)-----------$(S)\n\n"
	$(COMPOSE) run --rm php chown -R $(USER_ID):$(GROUP_ID) .
	@printf " $(G)✔$(S) You are now defined as the owner $(Y)$(USER_ID):$(GROUP_ID)$(S) of the project files.\n"

## — UTILS 🛠️  —————————————————————————————————————————————————————————————————

.PHONY: vars
vars: ## Show variables
	@printf "\n$(Y)Vars$(S)"
	@printf "\n$(Y)----$(S)\n"
	@printf "\n$(G)USER$(S)\n"
	@printf "  USER_ID : $(USER_ID)\n"
	@printf "  GROUP_ID: $(GROUP_ID)\n"
	@printf "\n$(G)BASE$(S)\n"
	@printf "  APP_DIR   : $(APP_DIR)\n"
	@printf "  REPOSITORY: $(REPOSITORY)\n"
	@printf "\n$(G)OVERLOADING$(S)\n"
	@printf "  PROJECT_NAME          : $(PROJECT_NAME)\n"
	@printf "  COMPOSE_BUILD_OPTS    : $(COMPOSE_BUILD_OPTS)\n"
	@printf "  COMPOSE_UP_SERVER_NAME: $(COMPOSE_UP_SERVER_NAME)\n"
	@printf "  COMPOSE_UP_ENV_VARS   : $(COMPOSE_UP_ENV_VARS)\n"
	@printf "\n$(G)SYMFONY ENVIRONMENT VARIABLES$(S)\n"
	@printf "  APP_ENV   : $(APP_ENV)\n"
	@printf "  APP_SECRET: $(APP_SECRET)\n"
	@printf "\n$(G)DOCKER$(S)\n"
	@printf "  COMPOSE_V2: $(COMPOSE_V2)\n"
	@printf "  COMPOSE   : $(COMPOSE)\n"
	@printf "  PHP       : $(PHP)\n"
	@printf "  COMPOSER  : $(COMPOSER)\n"
	@printf "  CONSOLE   : $(CONSOLE)\n"

.PHONY: overload_file
overload_file: ## Show overload file loaded into that Makefile
	@printf "\n$(Y)Overload file$(S)"
	@printf "\n$(Y)-------------$(S)\n\n"
	@printf "Overload file loaded into that Makefile:\n\n"
ifneq ("$(wildcard .overload)","")
	@printf "* $(G)✔$(S) .overload\n"
else
	@printf "* $(R)⨯$(S) .overload\n"
endif

.PHONY: env_files
env_files: ## Show env files loaded into that Makefile
	@printf "\n$(Y)Env files$(S)"
	@printf "\n$(Y)---------$(S)\n\n"
	@printf "Env files loaded into that Makefile (in order of decreasing priority) $(Y)[FILE_ENV=$(FILE_ENV)]$(S):\n\n"
ifneq ("$(wildcard $(APP_DIR)/.env.$(FILE_ENV).local)","")
	@printf "* $(G)✔$(S) $(APP_DIR)/.env.$(FILE_ENV).local\n"
else
	@printf "* $(R)⨯$(S) $(APP_DIR)/.env.$(FILE_ENV).local\n"
endif
ifneq ("$(wildcard $(APP_DIR)/.env.$(FILE_ENV))","")
	@printf "* $(G)✔$(S) $(APP_DIR)/.env.$(FILE_ENV)\n"
else
	@printf "* $(R)⨯$(S) $(APP_DIR)/.env.$(FILE_ENV)\n"
endif
ifneq ("$(wildcard $(APP_DIR)/.env.local)","")
	@printf "* $(G)✔$(S) $(APP_DIR)/.env.local\n"
else
	@printf "* $(R)⨯$(S) $(APP_DIR)/.env.local\n"
endif
ifneq ("$(wildcard $(APP_DIR)/.env)","")
	@printf "* $(G)✔$(S) $(APP_DIR)/.env\n"
else
	@printf "* $(R)⨯$(S) $(APP_DIR)/.env\n"
endif

## — INTERNAL 🚧‍️ ——————————————————————————————————————————————————————————————

.PHONY: confirm
confirm: ## Display a confirmation before executing a makefile command - @$(MAKE) -s confirm question=<question> [make_yes=<command>] [make_no=<command>] [yes_by_default=<bool>]
	@$(if $(question),, $(error question argument is required))   # Question to display
	@$(eval make_yes ?=)                                          # Makefile commands to execute on yes
	@$(eval make_no ?=)                                           # Makefile commands to execute on no
	@$(eval yes_by_default ?=)                                    # Default ‘yes’ answer
	@\
	question=$${question:-"Confirm?"}; \
	if [ "$${yes_by_default}" != "true" ]; then \
		printf "$(G)$${question}$(S) [$(Y)y/N$(S)]: " && read answer; \
	fi; \
	answer=$${answer:-N}; \
	if [ "$${answer}" = y ] || [ "$${answer}" = Y ] || [ "$${yes_by_default}" = "true" ]; then \
		[ -z "$$make_yes" ] && printf "$(Y)(YES) no action!$(S)\n" || $(MAKE) -s $$make_yes yes_by_default=true; \
	else \
		[ -z "$$make_no" ] && printf "$(Y)(NO) no action!$(S)\n" || $(MAKE) -s $$make_no; \
	fi

PHONY: confirm_continue
confirm_continue: ## Display a confirmation before continuing [y/N]
	@$(eval yes_by_default ?=) # Default ‘yes’ answer
	@if [ "$${yes_by_default}" = "true" ]; then exit 0; fi; \
	printf "$(G)Do you want to continue?$(S) [$(Y)y/N$(S)]: " && read answer && [ $${answer:-N} = y ]
