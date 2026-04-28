## — SYMFONY CONTRIBUTION 🔗 ——————————————————————————————————————————————————

##   (to delete this section, delete make/contrib.mk)
##

# Clone by default your Symfony monorepo side-by-side with the Symfony Starter
SYMFONY_MONOREPO_DIR=symfony

contrib_dockerfile: ## Inject PHP extensions required for contribution into Dockerfile (xsl, etc.)
	$(M) permissions
	$(M) rb m=recipes t=Dockerfile s=.starter/block/contrib/Dockerfile
	$(M) co m="Enable contribution PHP extensions (xsl, etc.)"
	$(M) deep_clean NO_INTERACTION=true
	$(M) build_force_start
	@printf " $(G)✔$(S) Enable contribution PHP extensions (xsl, etc.)\n"

##

_bundle: # INTERNAL
	@if [ ! -d "../$(d)" ]; then \
		printf "$(R)✘ Directory '../$(d)' not found. Clone your fork side-by-side with the Symfony Starter first.$(S)\n"; \
		exit 1; \
	fi

bundle_volume: _bundle ## Add a Docker volume for a local repository | d=<dir> | d=symfony
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(MAKE) ya f=compose.override.yaml k=services.php.volumes v='../$(d):/$(d)'
	@sed -i'' "s|^SAFE_DIRECTORIES = .*|& /$(d)|" Makefile

bundle_add: _bundle ## Register a path repository in composer.json | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(COMPOSER) config repositories.$(d) '{"type": "path", "url": "../$(d)", "options": {"symlink": true}}'

bundle_remove: ## Unregister a path repository from composer.json | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(COMPOSER) config --unset repositories.$(d)

bundle_install: _bundle ## Install external dependencies used during the tests | d=<dir> | d=symfony
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	@printf "🧙 Install Composer packages in $(Y)/$(d)$(S)\n"
	$(COMPOSER) install --working-dir=/$(d)

bundle_clean: ## Remove vendor and lock file from a local repository | d=<dir> | d=symfony
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(CONTAINER_PHP) rm -fr /$(d)/vendor /$(d)/composer.lock

bundle_tests: bundle_tests_clean ## Run PHPUnit tests in a local repository | d=<dir> [a=<args>] | d=symfony a=/symfony/src/Symfony/Bundle/FrameworkBundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	@if docker compose exec php [ -f "/$(d)/phpunit" ]; then \
		echo "$(G)🧙 Running PHPUnit via root phpunit binary$(S)"; \
		docker compose exec -e SYMFONY_DEPRECATIONS_HELPER=weak -e COMPOSER_ALLOW_SUPERUSER=1 php /$(d)/phpunit -c /$(d)/phpunit.xml.dist --display-skipped $(a); \
	elif docker compose exec php [ -f "/$(d)/vendor/bin/phpunit" ]; then \
		echo "$(G)🧙 Running PHPUnit via vendor/bin/phpunit$(S)"; \
		docker compose exec -e SYMFONY_DEPRECATIONS_HELPER=weak -e COMPOSER_ALLOW_SUPERUSER=1 php /$(d)/vendor/bin/phpunit -c /$(d)/phpunit.xml.dist --display-skipped $(a); \
	else \
		echo "$(R)✘ PHPUnit binary not found in /$(d) inside the container$(S)"; \
		exit 1; \
	fi

bundle_tests_clean: _bundle ## Clean PHPUnit cache and temporary files in a local repository | d=<dir> | d=symfony
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	docker compose exec -u 0 php rm -fr /tmp/* /$(d)/.phpunit.result.cache /$(d)/var/cache/*

##

_monorepo: # INTERNAL
	$(MAKE) _bundle d=$(SYMFONY_MONOREPO_DIR)

monorepo_volume: ## Add a Docker volume for the Symfony monorepo
	$(MAKE) bundle_volume d=$(SYMFONY_MONOREPO_DIR)

monorepo_link: _monorepo ## Replace vendors with symlinks to the Symfony monorepo
	$(PHP) /$(SYMFONY_MONOREPO_DIR)/link /app
	@printf "🔗 Local directory $(Y)/$(SYMFONY_MONOREPO_DIR)$(S) linked to the project\n"

monorepo_unlink: ## Restore original vendors (rollback symlinks to the Symfony monorepo)
	$(PHP) /$(SYMFONY_MONOREPO_DIR)/link /app --rollback
	@printf "🔙 Original vendors restored (detached from $(Y)/$(SYMFONY_MONOREPO_DIR)$(S))\n"

monorepo_install: ## Install external dependencies used during the tests in the Symfony monorepo
	$(MAKE) bundle_install d=$(SYMFONY_MONOREPO_DIR)

monorepo_clean: ## Remove vendor and lock file from the Symfony monorepo
	$(MAKE) bundle_clean d=$(SYMFONY_MONOREPO_DIR)

monorepo_tests: ## Run PHPUnit tests in the Symfony monorepo | [a=<args>] | a=/symfony/src/Symfony/Bundle/FrameworkBundle
	$(MAKE) bundle_tests d=$(SYMFONY_MONOREPO_DIR) a=$(a)

monorepo_tests_clean: ## Clean PHPUnit cache and temporary files in the Symfony monorepo
	$(MAKE) bundle_tests_clean d=$(SYMFONY_MONOREPO_DIR)
