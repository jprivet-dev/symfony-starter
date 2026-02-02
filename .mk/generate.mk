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

activate_bind_mount: # INTERNAL - Execute after $ make restart
	$(M) ya f=compose.override.yaml k=services.php.volumes v='./var:/app/var'
	$(M) ya f=compose.override.yaml k=services.php.volumes v='./var/log:/app/var/log'
	$(M) co m="activate the bind mount (var/, var/log)"

update_postgresql_configuration: # INTERNAL - Execute after $ make restart
	$(M) yu f=compose.yaml k=services.php.environment.DATABASE_URL v=\$${DATABASE_URL:-}
	$(M) rb m=doctrine/doctrine-bundle t=.env s=.block/postgresql/.env
	$(M) rb m=doctrine/doctrine-bundle t=compose.override.yaml s=.block/postgresql/compose.override.yaml
	$(M) co m="update PosgreSQL configuration"

#

.PHONY: minimalist
minimalist: deep_clean ## Generate a minimalist Symfony application with Docker configuration (stable release)
	$(M) clone_symfony_docker
	$(M) images info
	@printf " $(G)✔$(S) Minimalist Symfony application generated!\n\n"

minimalist@lts: deep_clean ## Generate a minimalist Symfony application with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION).* $(M) minimalist

##

.PHONY: api
api: deep_clean ## Generate an ApiPlatform application (with PostgreSQL) with Docker configuration
	$(M) minimalist
	$(M) require_orm
	$(M) require_api
	$(M) images info
	@printf " $(G)✔$(S) ApiPlatform application (with PostgreSQL) generated!\n\n"

api@lts: deep_clean ## Generate an ApiPlatform application (with PostgreSQL) with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION).* $(M) api

.PHONY: demo
demo: deep_clean ## Generate a Symfony Demo application (with SQLite) with Docker configuration
	$(M) clone_symfony_demo
	$(M) clone_symfony_docker
	$(M) rb m=recipes t=Dockerfile s=.block/sqlite/Dockerfile
	$(M) rb m=symfony/framework-bundle t=.env.dev s=.block/demo/.env.dev
	$(M) ga f=clean/docker-entrypoint.sh.database.patch
	$(M) co m="switch to SQLite"
	$(M) deep_clean
	$(M) restart_force
	$(M) images info
	@printf " $(G)✔$(S) Symfony Demo application (with SQLite) generated!\n\n"

easy_admin: deep_clean ## Generate an EasyAdmin application (with PostgreSQL) with Docker configuration
	$(M) minimalist
	$(M) require_orm
	$(M) require_easy_admin
	# Quickly generate a dashboard controller - See https://symfony.com/bundles/EasyAdminBundle/current/dashboards.html
	$(CONSOLE) make:admin:dashboard --no-interaction
	$(M) co m="bin/console make:admin:dashboard --no-interaction"
	# Need to repeat cache_clear to avoid "Clear the application cache to run the EasyAdmin cache warmer, which generates the needed data to find this route.". Find why!
	$(M) cache_clear
	$(M) cache_clear
	$(M) cache_clear
	$(M) images info
	@printf " $(G)✔$(S) EasyAdmin application (with PostgreSQL) generated!\n\n"

easy_admin@lts: deep_clean ## Generate an EasyAdmin application (with PostgreSQL) with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION).* $(MAKE) easy_admin

.PHONY: webapp
webapp: kill_current_app minimalist ## Generate a webapp Symfony application with Docker configuration (stable release)
	$(M) require_webapp
	$(M) images info
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
else
	@printf " $(G)✔$(S) https://github.com/dunglas/symfony-docker files already present at the root.\n\n"
endif
	$(M) co m="make clone_symfony_docker"
	$(M) activate_bind_mount
	$(M) restart_force
	$(M) ga f=clean/docker-entrypoint.sh.composer.patch
	$(M) co m="clean docker-entrypoint.sh"
	$(M) restart_build

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

kill_current_app: ## Remove all fresh Symfony application files
	-$(M) permissions
	$(M) deep_clean
	git reset --hard
	git clean -f -d
	rm -rf var/ vendor/

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
	$(M) deep_clean
	$(M) restart_force

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
	$(M) deep_clean
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
	$(M) rb m=doctrine/doctrine-bundle t=.env s=.block/mariadb/.env
	$(M) rb m=doctrine/doctrine-bundle t=Dockerfile s=.block/mariadb/Dockerfile
	$(M) rb m=doctrine/doctrine-bundle t=compose.override.yaml s=.block/mariadb/compose.override.yaml
	$(M) rb m=doctrine/doctrine-bundle t=compose.yaml s=.block/mariadb/compose.yaml
	$(M) co m="stack updated to MariaDB"
	$(M) permissions down deep_clean up_detached
	@printf " $(G)✔$(S) Stack updated to MariaDB!\n"
