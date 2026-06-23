## — GENERATE 🔨 ——————————————————————————————————————————————————————————————

##   (to delete this section, delete .make/generate.mk)
##

# This GENERATE block, with these following targets and variables,
# is only used for the initial setup and can be removed after saving the project.

# Symfony 7.* is the current long-term support version.
# Released on          : November 2025
# End of bug fixes     : November 2028
# End of security fixes: November 2029
# See https://symfony.com/releases
SYMFONY_LTS_VERSION     = 7
SYMFONY_STABLE_VERSION  = 8
REPOSITORY_SYMFONY_DEMO = git@github.com:symfony/demo.git
CLONE_DIR               = clone

C = $(COMPOSER)
M = $(MAKE)

START_TIME := $(shell date +%s)

define PRINT_EXECUTION_TIME
	@END_TIME=$$(date +%s); \
	DURATION=$$(( $$END_TIME - $(START_TIME) )); \
	MINUTES=$$(( $$DURATION / 60 )); \
	SECONDS=$$(( $$DURATION % 60 )); \
	printf "\n ⏱️ Total execution time: $(Y)%02dm %02ds$(S)\n" $$MINUTES $$SECONDS
endef

#

.PHONY: replace
replace rp: # INTERNAL - Replace a string in a file | f=<file> o=<old_string> n=<new_string> | f=Dockerfile o=pdo_pgsql n=pdo_mysql
	$(if $(f),, $(error "Please specify a file with 'f=...'"))
	$(if $(o),, $(error "Please specify the old string with 'o=...'"))
	$(if $(n),, $(error "Please specify the new string with 'n=...'"))
	@sed "s|$(o)|$(n)|g" "$(f)" > "$(f).tmp" && mv "$(f).tmp" "$(f)"

replace_line rl: # INTERNAL - Replace an entire line beginning with a specific pattern | f=<file> s=<start> n=<value> | f=.env s="DATABASE_URL=" n="DATABASE_URL=new value..."
	$(if $(f),, $(error "Please specify a file with 'f=...'"))
	$(if $(s),, $(error "Please specify the start of the line to match with 's=...'"))
	$(if $(n),, $(error "Please specify the new line content with 'n=...'"))
	@# Use $(subst) to automatically escape "&" with "\&" for sed
	@sed "s|^$(s).*|$(subst &,\&,$(value n))|" "$(f)" > "$(f).tmp" && mv "$(f).tmp" "$(f)"

replace_block rb: # INTERNAL - Replace a block in a target file | m=<marker> t=<target> s=<source> | m=doctrine/doctrine-bundle t=.env s=.starter/block/postgresql/.env
	$(if $(m),, $(error "Please specify the marker with 'm=...'"))
	$(if $(t),, $(error "Please specify the target with 't=...'"))
	$(if $(s),, $(error "Please specify the source with 's=...'"))
	.starter/scripts/replace_block.sh -m "$(m)" -t "$(t)" -s "$(s)" -i "$(i)"

clear_block cb: # INTERNAL - Clear a block in a target file | m=<marker> t=<target> | m=doctrine/doctrine-bundle t=compose.yaml
	$(if $(m),, $(error "Please specify the marker with 'm=...'"))
	$(if $(t),, $(error "Please specify the target with 't=...'"))
	.starter/scripts/replace_block.sh -m "$(m)" -t "$(t)" -i "$(i)"

#

GIT_PREFIX = 🤖 [starter]

.PHONY: commit co
commit co: # INTERNAL
	$(if $(m),, $(error "Please specify a message with 'm=...'"))
	git add . && git commit -m "$(GIT_PREFIX) $(m)"

compose_activate_bind_mount: compose.override.yaml # INTERNAL - Execute after $ make restart
	$(M) ya f=compose.override.yaml k=services.php.volumes v='./var:/app/var'
	$(M) ya f=compose.override.yaml k=services.php.volumes v='./var/log:/app/var/log'
	$(M) co m="activate the bind mount (var/, var/log)"

update_postgresql_configuration: .env compose.override.yaml # INTERNAL - Execute after $ make restart
	$(M) rb m=doctrine/doctrine-bundle t=.env s=.starter/block/postgresql/.env
	$(M) rb m=doctrine/doctrine-bundle t=compose.override.yaml s=.starter/block/postgresql/compose.override.yaml
	$(M) co m="update PosgreSQL configuration"

demo_add_sqlite_configuration_before_orm_pack: Dockerfile frankenphp/docker-entrypoint.sh # INTERNAL - Execute after $ make build_force_start
	$(M) cb m=dunglas/symfony-docker t=frankenphp/docker-entrypoint.sh
	$(M) rb m=recipes t=Dockerfile s=.starter/block/sqlite/Dockerfile
	$(M) co m="add SQLite configuration before ORM pack installation"

compose_use_database_url_var: compose.yaml # INTERNAL - Execute after $ make build_force_start
	$(M) yu f=compose.yaml k=services.php.environment.DATABASE_URL v=\$${DATABASE_URL:-}
	$(M) co m="use DATABASE_URL var in compose.yaml"

orphan_branch: # INTERNAL - Create a new orphan branch before generation | FLAVOR=<flavor>
	@printf "\n$(Y)--- Branch ---$(S)\n"
	@printf " $(Y)›$(S) Current branch: $(G)$$(git rev-parse --abbrev-ref HEAD)$(S)\n"
	@if [ -n "$(BRANCH)" ]; then \
		BRANCH_NAME="$(BRANCH)"; \
		printf " $(Y)›$(S) Using specified orphan branch name: $(G)$$BRANCH_NAME$(S)\n"; \
	elif [ "$${NO_INTERACTION}" != "true" ]; then \
		printf " $(Y)›$(S) New orphan branch name [$(G)$(FLAVOR)$(S)]: "; \
		read INPUT; \
		BRANCH_NAME=$${INPUT:-$(FLAVOR)}; \
	else \
		BRANCH_NAME="$(FLAVOR)"; \
	fi; \
	git branch -D "$$BRANCH_NAME" 2>/dev/null || true; \
	git checkout --orphan "$$BRANCH_NAME"; \
	$(M) co m="Initial commit"; \
	printf " $(G)✔$(S) Orphan branch $(G)$$BRANCH_NAME$(S) created with a fresh history\n"

#

clean_app: confirm ## Remove all fresh Symfony application files (var/, vendor/, ...)
	-$(M) permissions
	$(M) deep_clean NO_INTERACTION=true
	git reset --hard
	git clean -f -d
	rm -rf var/ vendor/

##

.PHONY: minimalist
minimalist: ## Generate a minimalist Symfony application with Docker configuration (stable release)
	$(M) orphan_branch FLAVOR=$(or $(FLAVOR),minimalist) BRANCH=$(BRANCH)
	$(M) skeleton
	$(PRINT_EXECUTION_TIME)
	@printf " $(G)🎉 Success!$(S) Minimalist Symfony application generated!\n\n"

minimalist@dev: ## Generate a minimalist Symfony application with Docker configuration (next dev release)
	STABILITY=dev $(M) minimalist FLAVOR=minimalist@dev BRANCH=$(BRANCH)

minimalist@lts: ## Generate a minimalist Symfony application with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION).* $(M) minimalist FLAVOR=minimalist@lts BRANCH=$(BRANCH)

.PHONY: webapp
webapp: ## Generate a webapp Symfony application (with PostgreSQL) with Docker configuration (stable release)
	$(M) orphan_branch FLAVOR=$(or $(FLAVOR),webapp) BRANCH=$(BRANCH)
	$(M) skeleton
	$(M) require_webapp
	$(M) permissions images info
	$(M) health_welcome_to_symfony
	$(PRINT_EXECUTION_TIME)
	@printf " $(G)🎉 Success!$(S) Webapp Symfony application generated!\n\n"

webapp@dev: ## Generate a webapp Symfony application (with PostgreSQL) with Docker configuration (next dev release)
	STABILITY=dev $(M) webapp FLAVOR=webapp@dev BRANCH=$(BRANCH)

webapp@lts: ## Generate a webapp Symfony application (with PostgreSQL) with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION).* $(M) webapp FLAVOR=webapp@lts BRANCH=$(BRANCH)

##

.PHONY: api
api: ## Generate an ApiPlatform application (with PostgreSQL) with Docker configuration
	$(M) orphan_branch FLAVOR=$(or $(FLAVOR),api) BRANCH=$(BRANCH)
	$(M) skeleton
	$(M) require_orm
	$(M) require_api
	$(M) permissions images info
	$(M) health_entrypoint
	$(PRINT_EXECUTION_TIME)
	@printf " $(G)🎉 Success!$(S) ApiPlatform application (with PostgreSQL) generated!\n\n"

api@lts: ## Generate an ApiPlatform application (with PostgreSQL) with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION).* $(M) api FLAVOR=api@lts BRANCH=$(BRANCH)

.PHONY: demo
demo: ## Generate a Symfony Demo application (with SQLite) with Docker configuration
	$(M) orphan_branch FLAVOR=demo BRANCH=$(BRANCH)
	$(M) clone_symfony_demo
	$(M) build_force_start
	git restore .env.local.demo
	$(M) compose_use_database_url_var
	$(M) compose_activate_bind_mount
	$(M) demo_add_sqlite_configuration_before_orm_pack
	$(M) build_start
	$(C) require symfony/orm-pack
	git restore .env.local.demo
	$(M) co m="composer require symfony/orm-pack"
	$(M) deep_clean NO_INTERACTION=true
	$(M) build_force_start
	$(M) health_symfony_demo
	$(PRINT_EXECUTION_TIME)
	@printf " $(G)🎉 Success!$(S) Symfony Demo application (with SQLite) generated!\n\n"

easy_admin: ## Generate an EasyAdmin application (with PostgreSQL) with Docker configuration
	$(M) orphan_branch FLAVOR=$(or $(FLAVOR),easy_admin) BRANCH=$(BRANCH)
	$(M) skeleton
	$(M) require_orm
	$(M) require_easy_admin
	$(CONSOLE) make:admin:dashboard --no-interaction
	$(M) co m="Quickly generate a dashboard controller - See https://symfony.com/bundles/EasyAdminBundle/current/dashboards.html"
	# Need to repeat cache_clear to avoid "Clear the application cache to run the EasyAdmin cache warmer, which generates the needed data to find this route.". Find why!
	$(M) cache_clear
	$(M) cache_clear
	$(M) cache_clear
	$(M) permissions images info
	$(M) health_welcome_to_easy_admin
	$(PRINT_EXECUTION_TIME)
	@printf " $(G)🎉 Success!$(S) EasyAdmin application (with PostgreSQL) generated!\n\n"

easy_admin@lts: ## Generate an EasyAdmin application (with PostgreSQL) with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION).* $(M) easy_admin FLAVOR=easy_admin@lts BRANCH=$(BRANCH)

##

.PHONY: reproducer
reproducer: ## Generate a minimalist Symfony application with Docker configuration as a reproducer (stable release)
	$(M) orphan_branch FLAVOR=$(or $(FLAVOR),reproducer) BRANCH=$(BRANCH)
ifneq ($(filter 6.%,$(SYMFONY_VERSION)),)
	git apply .starter/patch/symfony6-frankenphp.patch
	git commit -am "🤖 [starter] fix: restore Symfony 6 compatibility with FrankenPHP worker mode"
endif
	$(M) skeleton
	$(M) require_maker_bundle
	$(M) reproducer_dockerfile
	$(M) permissions images info
	$(M) health_welcome_to_symfony
	$(PRINT_EXECUTION_TIME)
	@printf " $(G)🎉 Success!$(S) Minimalist Symfony application (as a reproducer) generated!\n\n"

reproducer@lts: ## Generate a minimalist Symfony application with Docker configuration as a reproducer (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION).* $(M) reproducer FLAVOR=reproducer@lts BRANCH=$(BRANCH)

reproducer@dev: ## Generate a minimalist Symfony application with Docker configuration as a reproducer (next dev release)
	STABILITY=dev $(M) reproducer FLAVOR=reproducer@dev BRANCH=$(BRANCH)

reproducer@6x: ## Generate a minimalist Symfony 6.x application with Docker configuration as a reproducer
	SYMFONY_VERSION=6.* $(M) reproducer FLAVOR=reproducer@6x BRANCH=$(BRANCH)

##

update_symfony_docker: ## Update the vendored dunglas/symfony-docker snapshot at the root
	.starter/scripts/update_symfony_docker.sh

skeleton: ## Install symfony/skeleton from the versioned dunglas/symfony-docker files at the root
	@printf "\n$(Y)--- Install symfony/skeleton ---$(S)\n"
	@printf " $(Y)›$(S) dunglas/symfony-docker upstream commit: $(G)$$(cat UPSTREAM)$(S)\n"
	@if [ "$$(cat composer.json)" = "{}" ]; then \
		$(M) build_force_start; \
		$(M) co m="symfony/skeleton installed"; \
		$(M) compose_use_database_url_var; \
		$(M) compose_activate_bind_mount; \
		$(M) build_start; \
		$(M) health_welcome_to_symfony; \
	else \
		printf " $(G)✔$(S) symfony/skeleton already installed, skipping.\n"; \
	fi

clone_symfony_demo: ## Clone and extract https://github.com/symfony/demo files at the root
	@printf "\n$(Y)--- Clone https://github.com/symfony/demo ---$(S)\n"
ifeq ($(wildcard .env.local.demo),)
	@printf "Repository: $(Y)$(REPOSITORY_SYMFONY_DEMO)$(S)\n"
	git clone $(REPOSITORY_SYMFONY_DEMO) $(CLONE_DIR) --depth 1
	@printf "\n$(Y)--- Extract https://github.com/symfony/demo at the root ---$(S)\n"
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

## ▸ COMPLETE INSTALLATION

require_co: ## Add required packages, then commit | [a=<args>] | a="symfony/http-client"
	$(M) require a="$(a)"
	$(M) co m="composer require $(a)"

##

require_api: ## Install API Platform - https://api-platform.com/docs/symfony/
	$(C) require api
	$(M) co m="composer require api"

require_easy_admin: ## Install EasyAdmin Bundle - https://symfony.com/bundles/EasyAdminBundle/current/index.html
	$(C) require easycorp/easyadmin-bundle
	$(M) co m="composer require easycorp/easyadmin-bundle"

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
	$(M) deep_clean NO_INTERACTION=true
	$(M) build_force_start

##

require_asset_mapper: ## Install AssetMapper - https://symfony.com/doc/current/frontend/asset_mapper.html
	$(C) require symfony/asset-mapper symfony/asset symfony/twig-pack
	$(M) co m="Install AssetMapper"

require_maker_bundle: ## Install MakerBundle - https://symfony.com/bundles/SymfonyMakerBundle/current/index.html
	$(C) require --dev symfony/maker-bundle
	$(M) co m="Install MakerBundle"

require_orm: ## Install Doctrine (with PostgreSQL by default) - https://symfony.com/doc/current/doctrine.html
	$(C) require symfony/orm-pack
	$(M) co m="Install Doctrine"
	$(M) update_postgresql_configuration
	# Running deep_clean is essential to properly take into account the ORM installed by symfony/orm-pack
	$(M) deep_clean NO_INTERACTION=true
	$(M) build_force_start

require_profiler: ## Install Profiler - https://symfony.com/doc/current/profiler.html
	$(C) require --dev symfony/profiler-pack
	$(M) co m="Install Profiler"

require_test_pack: ## Install PHPUnit - https://symfony.com/doc/current/testing.html
	$(C) require --dev symfony/test-pack
	$(M) co m="Install PHPUnit"

require_translation: ## Install Translation - https://symfony.com/doc/current/translation.html
	$(C) require symfony/translation
	$(M) co m="Install Translation"

require_ux_live_component: ## Install Live Component - https://ux.symfony.com/
	$(C) symfony/ux-live-component
	$(M) co m="Install Live Component"

require_ux_stimulus: ## Install StimulusBundle - https://ux.symfony.com/
	$(C) require symfony/asset-mapper symfony/stimulus-bundle
	$(M) co m="Install StimulusBundle"

require_ux_twig_component: ## Install Twig Component - https://ux.symfony.com/
	$(C) symfony/ux-twig-component
	$(M) co m="Install Twig Component"

##

require_phpcsfixer: ## Install PHP CS Fixer - https://github.com/PHP-CS-Fixer/PHP-CS-Fixer
	$(C) require --dev friendsofphp/php-cs-fixer
	$(M) co m="Install PHP CS Fixer"

require_phpmd: ## Install PHP Mess Detector - https://phpmd.org/
	$(C) require --dev phpmd/phpmd
	$(M) co m="Install PHP Mess Detector"

require_phpmetrics: ## Install PHPMetrics - https://phpmetrics.github.io/website/
	$(C) require --dev phpmetrics/phpmetrics
	$(M) co m="composer require --dev phpmetrics/phpmetrics"

require_phpstan: ## Install PHPStan - https://phpstan.org/
	$(C) require --dev \
		phpstan/phpstan \
		phpstan/phpstan-symfony \
		phpstan/phpstan-doctrine \
		phpstan/phpstan-phpunit
	$(M) co m="Install PHPStan (+ symfony, doctrine & phpunit)"

require_twigcsfixer: ## Install Twig CS Fixer - https://github.com/VincentLanglet/Twig-CS-Fixer
	$(C) require --dev vincentlanglet/twig-cs-fixer
	$(M) co m="Install Twig CS Fixer"

##

require_bootstrap: _assets ## Install Bootstrap - https://getbootstrap.com/
	$(CONSOLE) importmap:require bootstrap
	$(M) co m="Install Bootstrap"

require_tailwind: _assets ## Install Tailwind CSS - https://tailwindcss.com/
	$(C) require symfonycasts/tailwind-bundle
	$(M) co m="Install Tailwind CSS"
	$(CONSOLE) tailwind:init
	$(M) co m="Initialize Tailwind CSS"

##

health: c ?= 200
health: ## Check the website and database connection (via Doctrine) | [c=<status_code>] [t=<text>] | c=404 t="Welcome to Symfony"
	@printf "\n$(Y)--- Check Health ---$(S)\n"
	@EXIT_CODE=0; \
	STATUS_CODE=$$(curl -k -L -s -o /dev/null -w "%{http_code}" $(LOCALHOST_MAIN)); \
	if [ "$${STATUS_CODE}" -eq $(c) ]; then \
		printf " $(G)✔ HTTP status OK (Expecting $(c)) - $(LOCALHOST_MAIN)$(S)\n"; \
	else \
		printf " $(R)✘ HTTP status failed (Expecting $(c) - Got $${STATUS_CODE}) - $(LOCALHOST_MAIN)$(S)\n"; \
		EXIT_CODE=1; \
	fi; \
	if [ -n "$(t)" ]; then \
		if curl -k -L -s $(LOCALHOST_MAIN) | grep -q "$(t)"; then \
			printf " $(G)✔ Content found (Searching for '$(t)') - $(LOCALHOST_MAIN)$(S)\n"; \
		else \
			printf " $(R)✘ Content missing (Searching for '$(t)') - $(LOCALHOST_MAIN)$(S)\n"; \
			EXIT_CODE=1; \
		fi; \
	fi; \
	if [ ! -e "$(VENDOR_DOCTRINE_ORM)" ]; then \
		printf " $(Y)› Database connection skipped (Doctrine not installed)$(S)\n"; \
	else \
		if $(CONSOLE) dbal:run-sql "SELECT 1" > /dev/null 2>&1; then \
			printf " $(G)✔ Database connection OK$(S)\n"; \
		else \
			printf " $(R)✘ Database connection Failed$(S)\n"; \
			EXIT_CODE=1; \
		fi; \
	fi; \
	printf "\n"; \
	exit $${EXIT_CODE}

health_entrypoint: # INTERNAL
	$(M) health c=200 t="Entrypoint"

health_symfony_demo: # INTERNAL
	$(M) health c=200 t="Symfony Demo"

health_welcome_to_easy_admin: # INTERNAL
	$(M) health c=200 t="Welcome to EasyAdmin"

health_welcome_to_symfony: # INTERNAL
	$(M) health c=404 t="Welcome to Symfony"

## ▸ DATABASE

switch_to_mariadb: .env Dockerfile compose.override.yaml compose.yaml ## Switch the stack from PostgreSQL to MySQL/MariaDB
ifeq ($(IS_POSTGRESQL),)
	@printf "\n $(R)⨯$(S) Please install $(Y)Doctrine (with PostgreSQL by default)$(S) with $(G)make require_orm$(S)\n"
	@exit 1
endif
	$(M) permissions
	$(M) rb m=doctrine/doctrine-bundle t=.env s=.starter/block/mariadb/.env
	$(M) rb m=doctrine/doctrine-bundle t=Dockerfile s=.starter/block/mariadb/Dockerfile
	$(M) rb m=doctrine/doctrine-bundle t=compose.override.yaml s=.starter/block/mariadb/compose.override.yaml
	$(M) rb m=doctrine/doctrine-bundle t=compose.yaml s=.starter/block/mariadb/compose.yaml
	$(M) ya f=compose.yaml k=services.php.depends_on.database.condition v=service_healthy
	$(M) co m="stack updated to MySQL/MariaDB"
	$(M) deep_clean NO_INTERACTION=true
	$(M) build_force_start
	@printf " $(G)✔$(S) Stack updated to MySQL/MariaDB!\n"

switch_to_sqlite: .env Dockerfile compose.override.yaml compose.yaml ## Switch the stack from PostgreSQL to SQLite
ifeq ($(IS_POSTGRESQL),)
	@printf "\n $(R)⨯$(S) Please install $(Y)Doctrine (with PostgreSQL by default)$(S) with $(G)make require_orm$(S)\n"
	@exit 1
endif
	$(M) permissions
	$(M) rb m=doctrine/doctrine-bundle t=.env s=.starter/block/sqlite/.env
	$(M) rb m=doctrine/doctrine-bundle t=Dockerfile s=.starter/block/sqlite/Dockerfile
	$(M) cb m=doctrine/doctrine-bundle t=compose.override.yaml
	$(M) cb m=doctrine/doctrine-bundle t=compose.yaml
	$(M) co m="stack updated to SQLite"
	$(M) deep_clean NO_INTERACTION=true
	$(M) build_force_start
	@printf " $(G)✔$(S) Stack updated to SQLite!\n"

## ▸ YQ

yq: ## Run yq, a lightweight and portable command-line YAML, JSON, INI and XML processor | [a=<argument>] | a=--help
	$(YQ) $(a)

yq_add ya: ## Append a value to an array key in a YAML file | f=<file> k=<key> v=<value> | f=compose.yaml k=services.php.extra_hosts v=host.docker.internal:host-gateway
	$(if $(f),, $(error "Please specify a file with 'f=...'"))
	$(if $(k),, $(error "Please specify a key with 'k=...'"))
	$(if $(value v),, $(error "Please specify a value with 'v=...'"))
	$(YQ) --inplace '.$(k) += "$(value v)"' $(f)

yq_clear yc: ## Clear a key's value in a YAML file (sets it to empty string) | f=<file> k=<key> | f=compose.yaml k=services.php.extra_hosts
	$(if $(f),, $(error "Please specify a file with 'f=...'"))
	$(if $(k),, $(error "Please specify a key with 'k=...'"))
	$(YQ) --inplace '.$(k) = ""' $(f)

yq_delete yd: ## Delete a key from a YAML file | f=<file> k=<key> | f=compose.yaml k=services.php.extra_hosts
	$(if $(f),, $(error "Please specify a file with 'f=...'"))
	$(if $(k),, $(error "Please specify a key with 'k=...'"))
	$(YQ) --inplace 'del(.$(k))' $(f)

yq_print: ## Print contents of a file as idiomatic YAML with colors | f=<file> | f=compose.yaml
	$(if $(f),, $(error "Please specify a file with 'f=...'"))
	$(YQ) --prettyPrint --colors --output-format yaml $(f)

yq_update yu: ## Set or update a key's value in a YAML file | f=<file> | f=compose.yaml k=services.php.build.target v=frankenphp_prod
	$(if $(f),, $(error "Please specify a file with 'f=...'"))
	$(if $(k),, $(error "Please specify a key with 'k=...'"))
	$(if $(value v),, $(error "Please specify a value with 'v=...'"))
	$(YQ) --inplace '.$(k) = "$(value v)"' $(f)
