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
$(info Warning: You are in the PROD environment)
endif

# See https://symfony.com/doc/current/deployment.html#b-configure-your-environment-variables
ifneq ($(wildcard .env.local.php),)
$(info Warning: In this Makefile it is not possible to use variables from .env.local.php file)
endif

#
# GENERATION
# These variables and commands are for initial setup and can be removed after saving the project.
#

# End of bug fixes: November 2026 - See https://symfony.com/releases
SYMFONY_LTS_VERSION = 6.*
REPOSITORY          = git@github.com:dunglas/symfony-docker.git
CLONE_DIR           = clone

#
# FILES & DIRECTORIES
#

PWD            = $(shell pwd)
NOW           := $(shell date +%Y%m%d-%H%M%S-%3N)
COVERAGE_DIR   = build/coverage-$(NOW)
COVERAGE_INDEX = $(PWD)/$(COVERAGE_DIR)/index.html

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

PROJECT_NAME    ?= $(shell basename $(CURDIR))
SERVER_NAME      = $(PROJECT_NAME).localhost
IMAGES_PREFIX    = $(PROJECT_NAME)-

HTTP_PORT  ?= 8080
HTTPS_PORT ?= 8443
HTTP3_PORT ?= $(HTTPS_PORT)

$(eval $(call append,APP_ENV))
$(eval $(call append,XDEBUG_MODE))
$(eval $(call append,SERVER_NAME))
$(eval $(call append,IMAGES_PREFIX))
$(eval $(call append,SYMFONY_VERSION))
$(eval $(call append,STABILITY))
$(eval $(call append,HTTP_PORT))
$(eval $(call append,HTTPS_PORT))
$(eval $(call append,HTTP3_PORT))
$(eval $(call append,CADDY_MERCURE_JWT_SECRET))

# Will be ":PORT" if HTTP_PORT is defined, otherwise empty.
HTTP_PORT_SUFFIX = $(if $(HTTP_PORT),:$(HTTP_PORT))

# Will be ":PORT" if HTTPS_PORT is defined and not 443, otherwise empty.
HTTPS_PORT_SUFFIX = $(if $(HTTPS_PORT),$(if $(filter-out 443,$(HTTPS_PORT)),:$(HTTPS_PORT)))

#
# DOCKER COMMANDS
#

COMPOSE_V2 := $(shell docker compose version 2> /dev/null)

ifndef COMPOSE_V2
$(error Docker Compose CLI plugin is required but is not available on your system)
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

CONTAINER_PHP = $(COMPOSE) exec $(DOCKER_EXEC_ENV) php
PHP           = $(CONTAINER_PHP) php
COMPOSER      = $(CONTAINER_PHP) composer
BASH_COMMAND  = $(CONTAINER_PHP) bash -c
CONSOLE       = $(PHP) bin/console
PHPUNIT       = $(PHP) bin/phpunit

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

#
# This complete GENERATION block, with these following targets are for initial setup and can be removed after saving the project.
#

.PHONY: _base
_base: clone build up_detached permissions # Internal

.PHONY: minimalist
minimalist: _base ## Generate a minimalist Symfony application with Docker configuration (stable release)
	$(MAKE) restart

minimalist@lts: ## Generate a minimalist Symfony application with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION) $(MAKE) minimalist

##

.PHONY: webapp
webapp: _base ## Generate a webapp with Docker configuration (stable release)
	@printf "\n$(Y)Add extra packages to build a web application$(S)"
	@printf "\n$(Y)---------------------------------------------$(S)\n\n"
	$(COMPOSER) require webapp
	$(MAKE) restart

webapp@lts: ## Generate a webapp with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION) $(MAKE) webapp

##

.PHONY: api
api: _base ## Generate an Api Platform project with Docker configuration (stable release)
	@printf "\n$(Y)Install the API Platform’s server component$(S)"
	@printf "\n$(Y)-------------------------------------------$(S)\n\n"
	$(COMPOSER) require api
	$(MAKE) restart

.PHONY: api@lts
api@lts: ## Generate an Api Platform project with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION) $(MAKE) api

##

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
	@if [ -f LICENSE ]; then \
		git restore LICENSE; \
	fi
	@printf " $(G)✔$(S) 'dunglas/symfony-docker' cloned and extracted at the root.\n\n"
else
	@printf " $(R)⨯$(S) 'dunglas/symfony-docker' configuration already present at the root.\n\n"
endif

clear_all: down ## Remove all 'dunglas/symfony-docker' configuration files and all Symfony application files
	git reset --hard && git clean -f -d

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
	@printf " $(Y)›$(S) Go in your favourite browser and accept the auto-generated TLS certificate:\n"
	@printf "    - $(G)https://$(SERVER_NAME)$(HTTPS_PORT_SUFFIX)/$(S)\n"
	@if [ -d vendor/api-platform ]; then \
		printf "    - $(G)https://$(SERVER_NAME)$(HTTPS_PORT_SUFFIX)/api$(S)\n"; \
	fi
	@printf "\n"

#
##   MINIMALIST VERSION
#

.PHONY: install
install: up_detached composer_install images info ## Start the project, install dependencies and show info

.PHONY: check
check: composer_validate ## Check everything before you deliver

#
##   WEBAPP VERSION
#

.PHONY: install
install: up_detached composer_install assets images info ## Start the project, install dependencies and show info

.PHONY: check
check: composer_validate tests validate ## Check everything before you deliver

.PHONY: tests
tests t: phpunit ## Run all tests

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

php_env: ## Display all environment variables set within the PHP container
	$(CONTAINER_PHP) env

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

composer_validate: ## Validate composer.json and composer.lock
	$(COMPOSER) validate --strict --check-lock

## — DOCTRINE & SQL 💽 ————————————————————————————————————————————————————————

db_drop: ## Drop the database - $ make db_drop [ARG=<arguments>] - Example: $ make db_drop ARG="--env=test"
	$(CONSOLE) doctrine:database:drop --if-exists --force $(ARG)

db_create: ## Create the database - $ make db_create [ARG=<arguments>] - Example: $ make db_create ARG="--env=test"
	$(CONSOLE) doctrine:database:create --if-not-exists $(ARG)

db_clear: db_drop db_create ## Drop and create the database

db_init: db_drop db_create fixtures ## Drop and create the database and add fixtures

##

.PHONY: validate
validate: ## Validate the mapping files - $ make validate [ARG=<arguments>] - Example: $ make validate ARG="--env=test"
	-$(CONSOLE) doctrine:schema:validate -v $(ARG)

.PHONY: update
update: ## Generate and output the SQL needed to synchronize the database schema with the current mapping metadata
	$(CONSOLE) doctrine:schema:update --dump-sql

update_force: ## Execute the generated SQL needed to synchronize the database schema with the current mapping metadata
	$(CONSOLE) doctrine:schema:update --force

##

.PHONY: migration
migration: ## Create a new migration based on database changes (format the generated SQL)
	$(CONSOLE) make:migration --formatted -v $(ARG)

.PHONY: migrate
migrate: ## Execute a migration to the latest available version (in a transaction) - $ make migrate [ARG=<param>] - Example: $ make migrate ARG="current+3"
	$(CONSOLE) doctrine:migrations:migrate --no-interaction --all-or-nothing $(ARG)

.PHONY: list
list: ## Display a list of all available migrations and their status
	$(CONSOLE) doctrine:migrations:list

.PHONY: execute
execute: ## Execute one or more migration versions up or down manually - $ make execute ARG=<arguments> - Example: $ make execute ARG="DoctrineMigrations\Version20240205143239"
	$(CONSOLE) doctrine:migrations:execute $(ARG)

.PHONY: generate
generate: ## Generate a blank migration class
	$(CONSOLE) doctrine:migrations:generate

##

.PHONY: sql
sql: ## Execute the given SQL query and output the results - $ make sql [QUERY=<query>] - Example: $ make sql QUERY="SELECT * FROM user"
	$(CONSOLE) doctrine:query:sql "$(QUERY)"

# See https://stackoverflow.com/questions/769683/how-to-show-tables-in-postgresql
sql_tables: QUERY=SELECT * FROM pg_catalog.pg_tables;
sql_tables: sql ## Show all tables

##

.PHONY: fixtures
fixtures: ## Load fixtures (CAUTION! by default the load command purges the database) - $ make fixtures [ARG=<param>] - Example: $ make fixtures ARG="--append"
	$(CONSOLE) doctrine:fixtures:load -n $(ARG)

## — POSTGRESQL 💽 ————————————————————————————————————————————————————————————

.PHONY: psql
psql: ## Execute psql - $ make psql [ARG=<arguments>] - Example: $ make psql ARG="-V"
	$(PSQL) $(ARG)

## — TESTS ✅ —————————————————————————————————————————————————————————————————

.PHONY: phpunit
phpunit: ## Run PHPUnit - $ make phpunit [ARG=<arguments>] - Example: $ make phpunit ARG="tests/myTest.php"
	$(PHPUNIT) $(ARG)

.PHONY: coverage
coverage: DOCKER_EXEC_ENV=-e XDEBUG_MODE=coverage
coverage: ARG=--coverage-html $(COVERAGE_DIR)
coverage: phpunit ## Generate code coverage report in HTML format for all tests
	@printf " $(G)✔$(S) Open in your favorite browser the file $(Y)$(COVERAGE_INDEX)$(S)\n"

.PHONY: dox
dox: ARG=--testdox
dox: phpunit ## Report test execution progress in TestDox format for all tests

##

xdebug_version: ## Xdebug version number
	$(PHP) -r "var_dump(phpversion('xdebug'));"

## — ASSETS 🎨‍ ————————————————————————————————————————————————————————————————

.PHONY: assets
assets: ## Generate all assets.
ifeq ($(APP_ENV),prod)
	make importmap_install
else
	make asset_map_compile
endif

##

asset_map_clear: ## Clear all assets in the public output directory.
	$(COMPOSE) run --rm php rm -rf ./public/assets

asset_map_compile: asset_map_clear ## Compile all mapped assets and writes them to the final public output directory.
	$(CONSOLE) asset-map:compile

asset_map_debug: ## See all of the mapped assets .
	$(CONSOLE) debug:asset-map --full

##

importmap_audit: ## Check for security vulnerability advisories for dependencies
	$(CONSOLE) importmap:audit

importmap_install: ## Download all assets that should be downloaded
	$(CONSOLE) importmap:install

importmap_outdated: ## List outdated JavaScript packages and their latest versions
	$(CONSOLE) importmap:outdated

importmap_remove: ## Remove JavaScript packages
	$(CONSOLE) importmap:remove

importmap_require: ## Require JavaScript packages
	$(CONSOLE) importmap:require $(ARG)

importmap_update: ## Update JavaScript packages to their latest versions
	$(CONSOLE) importmap:update

## — TRANSLATION 🇬🇧 ————————————————————————————————————————————————————————————

.PHONY: extract
extract: ## Extracts translation strings from templates (fr)
	$(CONSOLE) translation:extract --sort=asc --format=yaml --force fr

## — BASH 💻 ——————————————————————————————————————————————————————————————————

.PHONY: command
command: ## Run a command inside the PHP container - $ make command [ARG=<arguments>]- Example: $ make command ARG="ls -al"
	$(BASH_COMMAND) "$(ARG)"

## — DOCKER 🐳 ————————————————————————————————————————————————————————————————

.PHONY: up
up: ## Start the containers - $ make up [ARG=<arguments>] - Example: $ make up ARG=-d
	$(UP_ENV) $(COMPOSE) up --remove-orphans $(ARG)
	$(MAKE) git_safe_dir

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

## — TROUBLESHOOTING 😵️ ———————————————————————————————————————————————————————

.PHONY: permissions
permissions p: ## Fix file permissions (primarily for Linux hosts)
ifeq ($(UNAME_S),Linux)
	$(COMPOSE) run --rm php chown -R $(USER) .
	@printf " $(G)✔$(S) You are now defined as the owner $(Y)$(USER)$(S) of the project files.\n"
else
	@printf " $(Y)›$(S) 'make permissions' is typically not needed on $(UNAME_S).\n"
endif

git_safe_dir: ## Add /app to Git's safe directories within the php container
	$(COMPOSE) exec php git config --global --add safe.directory /app

## — UTILITIES 🛠️ ——————————————————————————————————————————————————————————————

env_files: ## Show env files loaded into this Makefile
	@printf "\n$(Y)Symfony env files$(S)"
	@printf "\n$(Y)-----------------$(S)\n\n"
	@printf "Files loaded into this Makefile (in order of decreasing priority) $(Y)[APP_ENV=$(APP_ENV)]$(S):\n\n"
ifneq ("$(wildcard .env.$(APP_ENV).local)","")
	@printf "* $(G)✔$(S) .env.$(APP_ENV).local\n"
else
	@printf "* $(R)⨯$(S) .env.$(APP_ENV).local\n"
endif
ifneq ("$(wildcard .env.$(APP_ENV))","")
	@printf "* $(G)✔$(S) .env.$(APP_ENV)\n"
else
	@printf "* $(R)⨯$(S) .env.$(APP_ENV)\n"
endif
ifneq ("$(wildcard .env.local)","")
	@printf "* $(G)✔$(S) .env.local\n"
else
	@printf "* $(R)⨯$(S) .env.local\n"
endif
ifneq ("$(wildcard .env)","")
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
	@printf "REPOSITORY   : $(REPOSITORY)\n"
	@printf "UP_ENV       : $(UP_ENV)\n"
	@printf "COMPOSE_V2   : $(COMPOSE_V2)\n"
	@printf "COMPOSE      : $(COMPOSE)\n"
	@printf "CONTAINER_PHP: $(CONTAINER_PHP)\n"
	@printf "PHP          : $(PHP)\n"
	@printf "COMPOSER     : $(COMPOSER)\n"
	@printf "CONSOLE      : $(CONSOLE)\n"
	@printf "PHPUNIT      : $(PHPUNIT)\n"
