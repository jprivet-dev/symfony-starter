## — SYMFONY CONTRIBUTION 🔗 ——————————————————————————————————————————————————

##   (to delete this section, delete make/contrib.mk)
##

# Clone by default your Symfony monorepo side-by-side with the Symfony Starter
SYMFONY_MONOREPO_DIR=symfony

contrib_dockerfile: ## Inject PHP extensions for contribution into Dockerfile
	$(M) permissions
	$(M) rb m=recipes t=Dockerfile s=.starter/block/contrib/Dockerfile
	$(M) co m="Enable contribution PHP extensions (xsl, etc.)"
	$(M) deep_clean NO_INTERACTION=true
	$(M) build_force_start
	@printf " $(G)✔$(S) Enable contribution PHP extensions (xsl, etc.)\n"

##

contrib_volume: ## Add a Docker volume for a directory | d=<dir> | d=symfony
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(MAKE) ya f=compose.override.yaml k=services.php.volumes v='../$(d):/$(d)'
	@sed -i'' "s|^SAFE_DIRECTORIES = .*|& /$(d)|" Makefile

contrib_add_repo: ## Add a path repository to composer.json | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(COMPOSER) config repositories.$(d) '{"type": "path", "url": "../$(d)", "options": {"symlink": true}}'

contrib_remove_repo: ## Remove a path repository to composer.json | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(COMPOSER) config --unset repositories.$(d)

contrib_install: ## Install Composer packages in a directory | d=<dir> | d=symfony
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	@printf "🧙 Install Composer packages in $(Y)/$(d)$(S)\n"
	$(COMPOSER) install --working-dir=/$(d)

contrib_clean: ## Remove vendor and lock file from a directory | d=<dir> | d=symfony
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(CONTAINER_PHP) rm -fr /$(d)/vendor /$(d)/composer.lock

contrib_tests: contrib_tests_clean ## Run PHPUnit tests in a directory | d=<dir> [a=<args>] | d=symfony a=/symfony/src/Symfony/Bundle/FrameworkBundle
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

contrib_tests_clean: ## Clean PHPUnit cache and temporary files in a directory | d=<dir> | d=symfony
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	docker compose exec -u 0 php rm -fr /tmp/* /$(d)/.phpunit.result.cache /$(d)/var/cache/*

##

monorepo_volume: ## Add a Docker volume for the Symfony monorepo
	$(MAKE) contrib_volume d=$(SYMFONY_MONOREPO_DIR)

monorepo_link: ## Link the Symfony monorepo to the project (replace vendors with symlinks)
	$(PHP) /$(SYMFONY_MONOREPO_DIR)/link /app
	@printf "🔗 Local directory $(Y)/$(SYMFONY_MONOREPO_DIR)$(S) linked to the project\n"

monorepo_unlink: ## Restore original vendors (rollback links from the Symfony monorepo)
	$(PHP) /$(SYMFONY_MONOREPO_DIR)/link /app --rollback
	@printf "🔙 Original vendors restored (detached from $(Y)/$(SYMFONY_MONOREPO_DIR)$(S))\n"

monorepo_install: ## Install Composer packages in the Symfony monorepo
	$(MAKE) contrib_install d=$(SYMFONY_MONOREPO_DIR)

monorepo_clean: ## Remove vendor and lock file from the Symfony monorepo
	$(MAKE) contrib_clean d=$(SYMFONY_MONOREPO_DIR)

monorepo_tests: ## Run PHPUnit tests in the Symfony monorepo | [a=<args>] | a=/symfony/src/Symfony/Bundle/FrameworkBundle
	$(MAKE) contrib_tests d=$(SYMFONY_MONOREPO_DIR) a=$(a)

monorepo_tests_clean: ## Clean PHPUnit cache and temporary files the Symfony monorepo
	$(MAKE) contrib_tests_clean d=$(SYMFONY_MONOREPO_DIR)
