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

NOW                := $(shell date +%Y%m%d-%H%M%S-%3N)
PWD                 = $(shell pwd)
MAKE_LOCAL_MK       = .make/local.mk
MAKE_LOCAL_MK_DIST  = $(MAKE_LOCAL_MK).dist

BIN_CONSOLE         = bin/console
BIN_PHPUNIT         = bin/phpunit
COMPOSER_JSON       = composer.json
DOCKERFILE          = Dockerfile
VENDOR_API          = vendor/api-platform
VENDOR_ASSETS       = vendor/symfony/asset-mapper
VENDOR_DOCTRINE_ORM = vendor/doctrine/orm
VENDOR_EASYADMIN    = vendor/easycorp/easyadmin-bundle
VENDOR_MAILER       = vendor/symfony/mailer
VENDOR_MONOLOG      = vendor/symfony/monolog-bundle
VENDOR_PHPCSFIXER   = vendor/bin/php-cs-fixer
VENDOR_PHPMD        = vendor/bin/phpmd
VENDOR_PHPMETRICS   = vendor/bin/phpmetrics
VENDOR_PHPSTAN      = vendor/bin/phpstan
VENDOR_PROFILER     = vendor/symfony/web-profiler-bundle
VENDOR_TAILWIND     = vendor/symfonycasts/tailwind-bundle
VENDOR_TRANSLATION  = vendor/symfony/translation
VENDOR_TWIGCSFIXER  = vendor/bin/twig-cs-fixer
WEBPACK_CONFIG      = webpack.config.js

# --- COMPONENTS CONFIG ---

BUILD             = build
PHPCSFIXER_CONFIG = .php-cs-fixer.dist.php
PHPSTAN_BASELINE  = phpstan-baseline.php
PHPSTAN_CONFIG    = phpstan.dist.neon

# --- TESTS CONFIG ---

COVERAGE_DIR   = $(BUILD)/coverage-$(NOW)
COVERAGE_INDEX = $(PWD)/$(COVERAGE_DIR)/index.html

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

# Default ports for local development. Override in .env.local (e.g. HTTP_PORT=9090).
# Set HTTP_PORTS_AUTO=true in .env.local to derive ports from the project name (avoids conflicts between projects).
# See services.php.ports in compose.yaml
HTTP_PORT  ?= 8042
HTTPS_PORT ?= 8442

ifeq ($(HTTP_PORTS_AUTO),true)
HTTP_PORT  := $(shell echo $(PROJECT_NAME) | cksum | awk '{print 8000 + $$1 % 900}')
HTTPS_PORT := $(shell echo $(PROJECT_NAME) | cksum | awk '{print 8400 + $$1 % 99}')
endif

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

include .make/start.mk

include .make/docker.mk

include .make/symfony.mk

include .make/php.mk

include .make/composer.mk

ifneq ($(or $(ALL), $(wildcard $(WEBPACK_CONFIG))),)
include .make/webpack.mk
endif

ifneq ($(or $(ALL), $(wildcard $(VENDOR_DOCTRINE_ORM))),)
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

-include $(sort $(wildcard .make/_*.mk))

include .make/end.mk

-include .make/contrib.mk

-include .make/generate.mk
