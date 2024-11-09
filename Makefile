#
# COLORS
#

# (G)REEN, (R)ED, (Y)ELLOW & RE(S)ET
G = "\\033[32m"
R = "\\033[31m"
Y = "\\033[33m"
S = "\\033[0m"

#
# ENVIRONMENT VARIABLES
#

-include .env

#
# EXECUTABLES (LOCAL)
#

USER_ID  = $(shell id -u)
GROUP_ID = $(shell id -g)

COMPOSE_V2 := $(shell docker compose version 2> /dev/null)

ifndef COMPOSE_V2
$(error Docker Compose CLI plugin is required but is not available on your system)
endif

APP_DIR            = app
APP_PATH           = $(PWD)/$(APP_DIR)
REPOSITORY         = git@github.com:dunglas/symfony-docker.git
DOCKER_PATH        = $(PWD)/$(DOCKER_DIR)
DOCKER_BUILD_OPTS ?=
PROJECT_NAME       = $(shell basename $(CURDIR))
SERVER_NAME       ?= $(PROJECT_NAME).localhost

COMPOSE_BASE     = $(APP_DIR)/compose.yaml
COMPOSE_OVERRIDE = $(APP_DIR)/compose.override.yaml
COMPOSE          =\
	SERVER_NAME=$(SERVER_NAME) $(DOCKER_BUILD_OPTS)\
	docker compose \
	-p $(PROJECT_NAME) -f $(COMPOSE_BASE) -f $(COMPOSE_OVERRIDE)

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
generate: confirm_continue clone build up_d permissions info ## Generate a fresh Symfony application, with the Docker configuration in a parallel directory

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
info i: $(call title Info) ## Show info
	@printf "\n$(Y)Info$(S)"
	@printf "\n$(Y)----$(S)\n\n"
	@printf "Go on $(G)https://$(SERVER_NAME)/$(S)\n"
	@printf "Run $(Y)make$(S) to see all shorcuts for the most common tasks.\n"
	@printf "Run $(Y). aliases$(S) to load all the project aliases.\n"
	@printf "\n"

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
php: ## Run PHP - $ make php [p=<params>]
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
composer: ## Run composer - $ make composer [p=<param>] - Example: $ make composer p="require --dev phpunit/phpunit"
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
up: ## Start the container
	$(COMPOSE) up --pull always

.PHONY: up_d
up_d: ## Start the container (wait for services to be running|healthy - detached mode)
	$(COMPOSE) up --pull always -d --wait

.PHONY: down
down: ## Stop the container
	$(COMPOSE) down --remove-orphans

.PHONY: build
build: ## Build or rebuild services
	$(COMPOSE) build

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
	@printf " $(G)✔$(S) You are now defined as the owner $(Y)$(USER_ID):$(GROUP_ID)$(S) of the project files.\n\n"

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
