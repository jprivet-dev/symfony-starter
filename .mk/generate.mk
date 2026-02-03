## — GENERATE 🔨 ——————————————————————————————————————————————————————————————

##   (to delete this section, delete .mk/generate.mk)
##

# This GENERATE block, with these following targets and variables,
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

C = $(COMPOSER)
M = $(MAKE)

START_TIME := $(shell date +%s)

define PRINT_EXECUTION_TIME
	@END_TIME=$$(date +%s); \
	DURATION=$$(( $$END_TIME - $(START_TIME) )); \
	MINUTES=$$(( $$DURATION / 60 )); \
	SECONDS=$$(( $$DURATION % 60 )); \
	printf " ⏱️ $(Y)Total execution time: %02dm %02ds$(S)\n" $$MINUTES $$SECONDS
endef

#

.PHONY: replace
replace rp: # INTERNAL - Replace a string in a file - $ make replace f=<file> o=<old_string> n=<new_string> - Example: $ make replace f=Dockerfile o=pdo_pgsql n=pdo_mysql
	$(if $(f),, $(error "Please specify a file with 'f=...'"))
	$(if $(o),, $(error "Please specify the old string with 'o=...'"))
	$(if $(n),, $(error "Please specify the new string with 'n=...'"))
	@sed "s|$(o)|$(n)|g" "$(f)" > "$(f).tmp" && mv "$(f).tmp" "$(f)"

replace_line rl: # INTERNAL - Replace an entire line beginning with a specific pattern - $ make replace f=<file> s=<start> n=<value> - Example: $ make replace_line f=.env s="DATABASE_URL=" n="DATABASE_URL=new value..."
	$(if $(f),, $(error "Please specify a file with 'f=...'"))
	$(if $(s),, $(error "Please specify the start of the line to match with 's=...'"))
	$(if $(n),, $(error "Please specify the new line content with 'n=...'"))
	@# Use $(subst) to automatically escape “&” with “\&” for sed
	@sed "s|^$(s).*|$(subst &,\&,$(value n))|" "$(f)" > "$(f).tmp" && mv "$(f).tmp" "$(f)"

replace_block rb: # INTERNAL - Replace a block in a target file with content from a source file, wrapping it with markers - $ make replace_block m=<marker> t=<target> s=<source>
	$(if $(m),, $(error "Please specify the marker with 'm=...'"))
	$(if $(t),, $(error "Please specify the target with 't=...'"))
	$(if $(s),, $(error "Please specify the source with 's=...'"))
	.sh/replace_block.sh -m "$(m)" -t "$(t)" -s "$(s)" -i "$(i)"

#

GIT_PREFIX = 🤖 [starter]

.PHONY: commit co
commit co: # INTERNAL
	$(if $(m),, $(error "Please specify a message with 'm=...'"))
	git add . && git commit -m "$(GIT_PREFIX) $(m)"

activate_bind_mount: compose.override.yaml # INTERNAL - Execute after $ make restart
	$(M) ya f=compose.override.yaml k=services.php.volumes v='./var:/app/var'
	$(M) ya f=compose.override.yaml k=services.php.volumes v='./var/log:/app/var/log'
	$(M) co m="activate the bind mount (var/, var/log)"

clean_docker_entrypoint: frankenphp/docker-entrypoint.sh # INTERNAL - Execute after $ make restart_build
	$(M) ga f=clean/docker-entrypoint.sh.composer.patch
	$(M) co m="clean docker-entrypoint.sh"

update_postgresql_configuration: .env compose.yaml compose.override.yaml # INTERNAL - Execute after $ make restart
	$(M) yu f=compose.yaml k=services.php.environment.DATABASE_URL v=\$${DATABASE_URL:-}
	$(M) rb m=doctrine/doctrine-bundle t=.env s=.block/postgresql/.env
	$(M) rb m=doctrine/doctrine-bundle t=compose.override.yaml s=.block/postgresql/compose.override.yaml
	$(M) co m="update PosgreSQL configuration"

demo_switch_to_sqlite: .env.dev Dockerfile frankenphp/docker-entrypoint.sh # INTERNAL - Execute after $ make restart_force
	$(M) ga f=clean/docker-entrypoint.sh.database.patch
	$(M) rb m=recipes t=Dockerfile s=.block/sqlite/Dockerfile
	$(M) co m="switch to SQLite"

#

kill_current_app: confirm ## Remove all fresh Symfony application files (var/, vendor/, ...)
	-$(M) permissions
	$(M) deep_clean NO_INTERACTION=true
	git reset --hard
	git clean -f -d
	rm -rf var/ vendor/

#

.PHONY: minimalist
minimalist: ## Generate a minimalist Symfony application with Docker configuration (stable release)
	$(M) clone_symfony_docker
	$(M) permissions images info
	$(PRINT_EXECUTION_TIME)
	@printf " $(G)✔$(S) Minimalist Symfony application generated!\n\n"

minimalist@lts: ## Generate a minimalist Symfony application with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION).* $(M) minimalist

##

.PHONY: api
api: ## Generate an ApiPlatform application (with PostgreSQL) with Docker configuration
	$(M) clone_symfony_docker
	$(M) require_orm
	$(M) require_api
	$(M) permissions images info
	$(PRINT_EXECUTION_TIME)
	@printf " $(G)✔$(S) ApiPlatform application (with PostgreSQL) generated!\n\n"

api@lts: ## Generate an ApiPlatform application (with PostgreSQL) with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION).* $(M) api

.PHONY: demo
demo: ## Generate a Symfony Demo application (with SQLite) with Docker configuration
	$(M) clone_symfony_demo
	$(M) clone_symfony_docker
	cp .env.local.demo .env.local
	$(M) demo_switch_to_sqlite
	$(M) deep_clean NO_INTERACTION=true
	$(M) restart_force
	$(M) permissions images info
	$(PRINT_EXECUTION_TIME)
	@printf " $(G)✔$(S) Symfony Demo application (with SQLite) generated!\n\n"

easy_admin: ## Generate an EasyAdmin application (with PostgreSQL) with Docker configuration
	$(M) clone_symfony_docker
	$(M) require_orm
	$(M) require_easy_admin
	# Quickly generate a dashboard controller - See https://symfony.com/bundles/EasyAdminBundle/current/dashboards.html
	$(CONSOLE) make:admin:dashboard --no-interaction
	$(M) co m="bin/console make:admin:dashboard --no-interaction"
	# Need to repeat cache_clear to avoid "Clear the application cache to run the EasyAdmin cache warmer, which generates the needed data to find this route.". Find why!
	$(M) cache_clear
	$(M) cache_clear
	$(M) cache_clear
	$(M) permissions images info
	$(PRINT_EXECUTION_TIME)
	@printf " $(G)✔$(S) EasyAdmin application (with PostgreSQL) generated!\n\n"

easy_admin@lts: ## Generate an EasyAdmin application (with PostgreSQL) with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION).* $(MAKE) easy_admin

.PHONY: webapp
webapp: ## Generate a webapp Symfony application with Docker configuration (stable release)
	$(M) clone_symfony_docker
	$(M) require_webapp
	$(M) permissions images info
	$(PRINT_EXECUTION_TIME)
	@printf " $(G)✔$(S) Webapp Symfony application generated!\n\n"

webapp@lts: ## Generate a webapp Symfony application with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION).* $(MAKE) webapp

##

clone_symfony_docker: ## Clone and extract https://github.com/dunglas/symfony-docker files at the root
	@printf "\n$(Y)--- Clone https://github.com/dunglas/symfony-docker$(S) ---\n"
ifeq ($(wildcard $(DOCKERFILE)),)
	@printf "Repository: $(Y)$(REPOSITORY_SYMFONY_DOCKER)$(S)\n"
	git clone $(REPOSITORY_SYMFONY_DOCKER) $(CLONE_DIR) --depth 1
	@printf "\n$(Y)--- Extract https://github.com/dunglas/symfony-docker at the root$(S) ---\n"
	rsync -av --exclude=".editorconfig" --exclude=".git" --exclude=".gitattributes" --exclude=".github" --exclude="docs" --exclude="LICENSE" --exclude="README.md" $(CLONE_DIR)/ .
	rm -rf $(CLONE_DIR)
	@if [ -f LICENSE ]; then \
		git restore LICENSE; \
	fi
	@printf " $(G)✔$(S) https://github.com/dunglas/symfony-docker cloned and extracted at the root.\n\n"
	$(M) co m="https://github.com/dunglas/symfony-docker cloned and extracted at the root"
#	$(M) activate_bind_mount
#	$(M) restart_force
#	$(M) clean_docker_entrypoint
#	$(M) restart_build
else
	@printf " $(G)✔$(S) https://github.com/dunglas/symfony-docker files already present at the root.\n\n"
endif

clone_symfony_demo: ## Clone and extract https://github.com/symfony/demo files at the root
	@printf "\n$(Y)--- Clone https://github.com/symfony/demo$(S) ---\n"
ifeq ($(wildcard .env.local.demo),)
	@printf "Repository: $(Y)$(REPOSITORY_SYMFONY_DEMO)$(S)\n"
	git clone $(REPOSITORY_SYMFONY_DEMO) $(CLONE_DIR) --depth 1
	@printf "\n$(Y)--- Extract https://github.com/symfony/demo at the root$(S) ---\n"
	rsync -av --exclude=".editorconfig" --exclude=".git" --exclude=".gitattributes" --exclude=".github" --exclude="docs" --exclude="LICENSE" --exclude="README.md" $(CLONE_DIR)/ .
	rm -rf $(CLONE_DIR)
	@if [ -f LICENSE ]; then \
		git restore LICENSE; \
	fi
	@printf " $(G)✔$(S) https://github.com/symfony/demo cloned and extracted at the root.\n\n"
else
	@printf " $(G)✔$(S) https://github.com/symfony/demo files already present at the root.\n\n"
endif
	$(M) co m="make clone_symfony_demo"

##   COMPLETE INSTALLATION

require_api: ## Install API Platform - https://api-platform.com/docs/symfony/
	$(C) require api
	$(M) co m="composer require api"

require_easy_admin: ## Install EasyAdmin Bundle - https://symfony.com/bundles/EasyAdminBundle/current/index.html
	$(C) require easycorp/easyadmin-bundle
	$(M) co m="composer require easycorp/easyadmin-bundle"

require_stimulus: ## Install StimulusBundle - https://ux.symfony.com/
	$(C) require symfony/asset-mapper symfony/stimulus-bundle
	$(M) co m="composer require symfony/asset-mapper symfony/stimulus-bundle"

require_webapp: ## Install a web application - https://symfony.com/doc/current/setup.html
	# FIX: Ban version 6 for the moment to prevent Symfony PropertyInfo crash
	# symfony/property-info v6 does not support phpdocumentor/reflection-docblock
    # Please stick to ^5.2 in your composer.json file.
	$(C) require "phpdocumentor/reflection-docblock:^5.2"
	# Use "symfony/webapp-pack" instead of "webapp" to avoid "Could not find package webapp."
	$(C) require symfony/webapp-pack
	$(M) co m="composer require symfony/webapp-pack"
	$(M) update_postgresql_configuration
	# Running deep_clean is essential to properly take into account the ORM installed by symfony/webapp-pack
	$(M) deep_clean restart_force

##

require_asset_mapper: ## Install AssetMapper - https://symfony.com/doc/current/frontend/asset_mapper.html
	$(C) require symfony/asset-mapper symfony/asset symfony/twig-pack
	$(M) co m="composer require symfony/asset-mapper symfony/asset symfony/twig-pack"

require_bootstrap: _assets ## Install Bootstrap - https://getbootstrap.com/
	$(CONSOLE) importmap:require bootstrap
	$(M) co m="bin/console importmap:require bootstrap"

require_maker_bundle: ## Install MakerBundle - https://symfony.com/bundles/SymfonyMakerBundle/current/index.html
	$(C) require --dev symfony/maker-bundle
	$(M) co m="composer require --dev symfony/maker-bundle"

require_orm: ## Install Doctrine (with PostgreSQL by default) - https://symfony.com/doc/current/doctrine.html
	$(C) require symfony/orm-pack
	$(M) co m="composer require symfony/orm-pack"
	$(M) update_postgresql_configuration
	# Running deep_clean is essential to properly take into account the ORM installed by symfony/orm-pack
	$(M) deep_clean NO_INTERACTION=true
	$(M) restart_force

require_profiler: ## Install Profiler - https://symfony.com/doc/current/profiler.html
	$(C) require --dev symfony/profiler-pack
	$(M) co m="composer require --dev symfony/profiler-pack"

require_test_pack: ## Install PHPUnit - https://symfony.com/doc/current/testing.html
	$(C) require --dev symfony/test-pack
	$(M) co m="composer require --dev symfony/test-pack"

require_translation: ## Install Translation - https://symfony.com/doc/current/translation.html
	$(C) require symfony/translation
	$(M) co m="composer require symfony/translation"

##

require_phpcsfixer: ## Install PHP CS Fixer - https://github.com/PHP-CS-Fixer/PHP-CS-Fixer
	$(C) require --dev friendsofphp/php-cs-fixer
	$(M) co m="composer require --dev friendsofphp/php-cs-fixer"

require_phpmd: ## Install PHP Mess Detector - https://phpmd.org/
	$(C) require --dev phpmd/phpmd
	$(M) co m="composer require --dev phpmd/phpmd"

require_phpmetrics: ## Install PHPMetrics - https://phpmetrics.github.io/website/
	$(C) require --dev phpmetrics/phpmetrics
	$(M) co m="composer require --dev phpmetrics/phpmetrics"

require_phpstan: ## Install PHPStan - https://phpstan.org/
	$(C) require --dev \
		phpstan/phpstan \
		phpstan/phpstan-symfony \
		phpstan/phpstan-doctrine \
		phpstan/phpstan-phpunit
	$(M) co m="composer require --dev phpstan/phpstan (+ symfony, doctrine & phpunit)"

require_twigcsfixer: ## Install Twig CS Fixer - https://github.com/VincentLanglet/Twig-CS-Fixer
	$(C) require --dev vincentlanglet/twig-cs-fixer
	$(M) co m="composer require --dev vincentlanglet/twig-cs-fixer"

##

switch_to_mariadb: .env Dockerfile compose.override.yaml compose.yaml ## Switch the stack from PostgreSQL to MySQL/MariaDB
ifeq ($(IS_POSTGRESQL),)
	@printf "\n $(R)⨯$(S) Please install $(Y)Doctrine (with PostgreSQL by default)$(S) with $(G)make require_orm$(S)\n"
	@exit 1
endif
	$(M) permissions
	$(M) rb m=doctrine/doctrine-bundle t=.env s=.block/mariadb/.env
	$(M) rb m=doctrine/doctrine-bundle t=Dockerfile s=.block/mariadb/Dockerfile
	$(M) rb m=doctrine/doctrine-bundle t=compose.override.yaml s=.block/mariadb/compose.override.yaml
	$(M) rb m=doctrine/doctrine-bundle t=compose.yaml s=.block/mariadb/compose.yaml
	$(M) co m="stack updated to MariaDB"
	$(M) deep_clean NO_INTERACTION=true
	$(M) restart_force
	@printf " $(G)✔$(S) Stack updated to MariaDB!\n"
