## — SYMFONY CONTRIBUTION 🔗 ——————————————————————————————————————————————————

##   (to delete this section, delete .make/contrib.mk)
##

# Clone by default your Symfony monorepo side-by-side with the Symfony Starter
SYMFONY_MONOREPO_DIR=symfony

reproducer_dockerfile: ## Add the necessary PHP extensions for the reproducer in the Dockerfile (xsl, etc.)
	$(M) permissions
	$(M) rb m=recipes t=Dockerfile s=.starter/block/contrib/Dockerfile
	$(M) co m="Enable reproducer PHP extensions (xsl, etc.)"
	$(M) deep_clean NO_INTERACTION=true
	$(M) build_force_start
	@printf " $(G)✔$(S) Necessary PHP extensions added for the reproducer in the Dockerfile (xsl, etc.)\n"

## ▸ SYMFONY MONOREPO

_monorepo: # INTERNAL
	$(M) _repo d=$(SYMFONY_MONOREPO_DIR)

monorepo_volume: ## Add a Docker volume for the Symfony monorepo
	$(M) repo_volume d=$(SYMFONY_MONOREPO_DIR)

monorepo_link: _monorepo ## Replace vendors with symlinks to the Symfony monorepo
	$(PHP) /$(SYMFONY_MONOREPO_DIR)/link /app
	@printf "🔗 Local directory $(Y)/$(SYMFONY_MONOREPO_DIR)$(S) linked to the project\n"

monorepo_install: ## Install external dependencies used during the tests in the Symfony monorepo
	$(M) repo_install d=$(SYMFONY_MONOREPO_DIR)

##

monorepo_status: ## Show current branch for reproducer and the Symfony monorepo
	$(M) repo_status d=$(SYMFONY_MONOREPO_DIR) a=$(a)

monorepo_tests: ## Run PHPUnit tests in the Symfony monorepo | [a=<args>] | a=/symfony/src/Symfony/Bundle/FrameworkBundle
	$(M) repo_tests d=$(SYMFONY_MONOREPO_DIR) a=$(a)

monorepo_tests_clean: ## Clean PHPUnit cache and temporary files in the Symfony monorepo
	$(M) repo_tests_clean d=$(SYMFONY_MONOREPO_DIR)
##

monorepo_clean: ## Remove vendor and lock file from the Symfony monorepo
	$(M) repo_clean d=$(SYMFONY_MONOREPO_DIR)

monorepo_unlink: ## Restore original vendors (rollback symlinks to the Symfony monorepo)
	$(PHP) /$(SYMFONY_MONOREPO_DIR)/link /app --rollback
	@printf "🔙 Original vendors restored (detached from $(Y)/$(SYMFONY_MONOREPO_DIR)$(S))\n"

## ▸ OTHER REPO

_repo: # INTERNAL
	@if [ ! -d "../$(d)" ]; then \
		printf "$(R)✘ Directory '../$(d)' not found. Clone your fork side-by-side with the Symfony Starter first.$(S)\n"; \
		exit 1; \
	fi

repo_volume: _repo repo_status ## Add a Docker volume for a local repository | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(M) ya f=compose.override.yaml k=services.php.volumes v='../$(d):/$(d)'
	@sed -i'' "s|^SAFE_DIRECTORIES = .*|& /$(d)|" Makefile
	$(M) co m="Add the Docker volume for the $(d) repository"
	$(M) restart

repo_add: _repo repo_status ## Register a path repository in composer.json | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(COMPOSER) config repositories.$(d) '{"type": "path", "url": "../$(d)", "options": {"symlink": true}}'
	$(M) co m="Register the $(d) path repository"

repo_install: _repo repo_status ## Install external dependencies used during the tests | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	@printf "🧙 Install Composer packages in $(Y)/$(d)$(S)\n"
	$(COMPOSER) install --working-dir=/$(d)

##

repo_status: _repo ## Show current branch for reproducer and a local repository | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	@printf "$(Y)%-25s  %s$(S)\n" "REPOSITORY" "BRANCH"
	@printf "%-25s  %s\n" "$(PROJECT_NAME)" "$$(git rev-parse --abbrev-ref HEAD)"
	@printf "%-25s  %s\n" "$(d)" "$$(git -C ../$(d) rev-parse --abbrev-ref HEAD)"
	@printf "\n"

repo_tests: repo_tests_clean ## Run PHPUnit tests in a local repository | d=<dir> [a=<args>] | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	@if $(CONTAINER_PHP) test -f "/$(d)/phpunit"; then \
		PHPUNIT="/$(d)/phpunit"; \
	else \
		PHPUNIT="/$(d)/vendor/bin/phpunit"; \
	fi; \
	if $(CONTAINER_PHP) test -f "/$(d)/phpunit.xml"; then \
		CONFIG="/$(d)/phpunit.xml"; \
	elif $(CONTAINER_PHP) test -f "/$(d)/phpunit.xml.dist"; then \
		CONFIG="/$(d)/phpunit.xml.dist"; \
	else \
		echo "$(R)✘ PHPUnit configuration file not found in /$(d) inside the container$(S)"; \
		exit 1; \
	fi; \
	$(CONTAINER_PHP) $$PHPUNIT -c $$CONFIG --display-skipped $(a)

repo_tests_clean: _repo repo_status ## Clean PHPUnit cache and temporary files in a local repository | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(CONTAINER_PHP) rm -fr /tmp/* /$(d)/.phpunit.result.cache /$(d)/var/cache/*

##

repo_remove: ## Unregister a path repository from composer.json | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(COMPOSER) config --unset repositories.$(d)


repo_clean: ## Remove vendor and lock file from a local repository | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(CONTAINER_PHP) rm -fr /$(d)/vendor /$(d)/composer.lock
