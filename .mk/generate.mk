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

_patch_var_log_mapping: f=var-log-mapping.patch
_patch_var_log_mapping: git_apply # INTERNAL

_patch_postgresql: f=postgresql.patch
_patch_postgresql: git_apply # INTERNAL

_patch_sqlite_base: f=sqlite-00-base.patch
_patch_sqlite_base: git_apply # INTERNAL

_patch_sqlite_env: f=sqlite-01-env.patch
_patch_sqlite_env: git_apply # INTERNAL

.PHONY: demo
demo: ## Generate a Symfony Demo application (with SQLite) with Docker configuration
	@# --- new branch ---
	git switch -c demo-$(NOW)

	@# --- clone_symfony_demo ---
	make clone_symfony_demo
	git add . && git commit -m "make clone_symfony_demo"

	@# --- clone_symfony_docker ---
	make clone_symfony_docker
	git add . && git commit -m "make clone_symfony_demo"
	make git_apply f=common/compose-var-mapping.patch
	git add . && git commit -m "make git_apply f=common/compose-var-mapping.patch"
	make git_apply f=common/compose-DATABASE_URL.patch
	git add . && git commit -m "make git_apply f=common/compose-DATABASE_URL.patch"
	make build up_detached runtime permissions
	git add . && git commit -m "make build up_detached runtime permissions"
	make git_apply f=common/docker-entrypoint-clean-composer.patch
	git add . && git commit -m "make git_apply f=common/docker-entrypoint-clean.patch"

	@# --- sqlite ---
	make git_apply f=sqlite/compose-doctrine-bundle.patch
	git add . && git commit -m "make git_apply f=sqlite/compose-doctrine-bundle.patch"
	make git_apply f=sqlite/dockerfile-sqlite.patch
	git add . && git commit -m "make git_apply f=sqlite/dockerfile-sqlite.patch"

	@# --- restart ---
	make down up_detached runtime permissions images info
	@printf " $(G)✔$(S) Symfony Demo application with SQLite generated!\n\n"

.PHONY: minimalist
minimalist: ## Generate a minimalist Symfony application with Docker configuration (stable release)
	@# --- new branch ---
	git switch -c minimalist-$(NOW)

	@# --- clone_symfony_docker ---
	make clone_symfony_docker
	git add . && git commit -m "make clone_symfony_demo"
	make git_apply f=common/compose-var-mapping.patch
	git add . && git commit -m "make git_apply f=common/compose-var-mapping.patch"
	make git_apply f=common/compose-DATABASE_URL.patch
	git add . && git commit -m "make git_apply f=common/compose-DATABASE_URL.patch"
	make build up_detached runtime permissions
	git add . && git commit -m "make build up_detached runtime permissions"
	make git_apply f=common/docker-entrypoint-clean-composer.patch
	git add . && git commit -m "make git_apply f=common/docker-entrypoint-clean.patch"

	@# --- restart ---
	make down up_detached runtime permissions images info
	@printf " $(G)✔$(S) Minimalist Symfony application generated!\n\n"

minimalist@postgresql: ## Generate a minimalist Symfony application (with PostgreSQL) with Docker configuration (stable release)
	@# --- new branch ---
	git switch -c minimalist-postgresql-$(NOW)

	@# --- clone_symfony_docker ---
	make clone_symfony_docker
	git add . && git commit -m "make clone_symfony_demo"
	make git_apply f=common/compose-var-mapping.patch
	git add . && git commit -m "make git_apply f=common/compose-var-mapping.patch"
	make git_apply f=common/compose-DATABASE_URL.patch
	git add . && git commit -m "make git_apply f=common/compose-DATABASE_URL.patch"
	make build up_detached runtime permissions
	git add . && git commit -m "make build up_detached runtime permissions"
	make git_apply f=common/docker-entrypoint-clean-composer.patch
	git add . && git commit -m "make git_apply f=common/docker-entrypoint-clean.patch"

	@# --- postgresql ---
	make require a=symfony/orm-pack
	git add . && git commit -m "make require a=symfony/orm-pack"
	make git_apply f=postgresql/compose-ports-5432.patch
	git add . && git commit -m "make git_apply f=postgresql/compose-ports-5432.patch"
	make git_apply f=postgresql/env-DATABASE_URL.patch
	git add . && git commit -m "make git_apply f=postgresql/env-DATABASE_URL.patch"

	@# --- restart ---
	make down up_detached runtime permissions images info
	@printf " $(G)✔$(S) Minimalist Symfony application with PostgreSQL generated!\n\n"

minimalist_lts: ## Generate a minimalist Symfony application with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION).* $(MAKE) minimalist

minimalist_lts@postgresql: ## Generate a minimalist Symfony application (with PostgreSQL) with Docker configuration (LTS - long-term support release)
	SYMFONY_VERSION=$(SYMFONY_LTS_VERSION).* $(MAKE) minimalist@postgresql

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

remove_all: confirm ## Remove all fresh Symfony application files
	-$(MAKE) permissions
	$(MAKE) clean_deep
	git reset --hard
	git clean -f -d

##   COMPLETE INSTALLATION

require_api: ## Install API Platform - https://api-platform.com/docs/symfony/
	$(COMPOSER) require api
	$(MAKE) restart

require_easy_admin: ## Install EasyAdmin Bundle - https://symfony.com/bundles/EasyAdminBundle/current/index.html
	$(COMPOSER) require easycorp/easyadmin-bundle
	$(MAKE) restart

require_stimulus: ## Install StimulusBundle - https://ux.symfony.com/
	$(COMPOSER) require symfony/asset-mapper symfony/stimulus-bundle

require_webapp: ## Install a web application - https://symfony.com/doc/current/setup.html
	# Use "symfony/webapp-pack" instead of "webapp" to avoid "Could not find package webapp."
	$(COMPOSER) require symfony/webapp-pack
	$(MAKE) restart

##

require_asset_mapper: ## Install AssetMapper - https://symfony.com/doc/current/frontend/asset_mapper.html
	$(COMPOSER) require symfony/asset-mapper symfony/asset symfony/twig-pack

require_bootstrap: require_asset_mapper ## Install Bootstrap - https://getbootstrap.com/
	$(CONSOLE) importmap:require bootstrap

require_maker_bundle: ## Install MakerBundle - https://symfony.com/bundles/SymfonyMakerBundle/current/index.html
	$(COMPOSER) require --dev symfony/maker-bundle

require_postgresql: ## Install Doctrine (PostgreSQL) - https://symfony.com/doc/current/doctrine.html
	$(COMPOSER) require symfony/orm-pack
	$(MAKE) _patch_postgresql
	$(MAKE) restart

require_profiler: ## Install Profiler - https://symfony.com/doc/current/profiler.html
	$(COMPOSER) require --dev symfony/profiler-pack

require_sqlite: ## Install Doctrine (SQLite) - https://symfony.com/doc/current/doctrine.html
	$(MAKE) _patch_sqlite_base
	$(COMPOSER) require symfony/orm-pack
	$(MAKE) _patch_sqlite_env
	$(MAKE) restart

require_test_pack: ## Install PHPUnit - https://symfony.com/doc/current/testing.html
	$(COMPOSER) require --dev symfony/test-pack

require_translation: ## Install Translation - https://symfony.com/doc/current/translation.html
	$(COMPOSER) require symfony/translation

##

require_phpcsfixer: ## Install PHP CS Fixer - https://github.com/PHP-CS-Fixer/PHP-CS-Fixer
	$(COMPOSER) require --dev friendsofphp/php-cs-fixer

require_phpmd: ## Install PHP Mess Detector - https://phpmd.org/
	$(COMPOSER) require --dev phpmd/phpmd

require_phpmetrics: ## Install PHPMetrics - https://phpmetrics.github.io/website/
	$(COMPOSER) require --dev phpmetrics/phpmetrics

require_phpstan: ## Install PHPStan - https://phpstan.org/
	$(COMPOSER) require --dev \
		phpstan/phpstan \
		phpstan/phpstan-symfony \
		phpstan/phpstan-doctrine \
		phpstan/phpstan-phpunit

require_twigcsfixer: ## Install Twig CS Fixer - https://github.com/VincentLanglet/Twig-CS-Fixer
	$(COMPOSER) require --dev vincentlanglet/twig-cs-fixer
