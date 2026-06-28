## — SYMFONY CONTRIBUTION 🔗 ——————————————————————————————————————————————————

##   (to delete this section, delete .make/contrib.mk)
##

# Clone by default your Symfony monorepo side-by-side with the Symfony Starter
SYMFONY_MONOREPO_DIR=symfony

PHPUNIT_EXE =
ifneq ($(wildcard ../$(d)/phpunit),)
PHPUNIT_EXE = /$(d)/phpunit
endif
ifneq ($(wildcard ../$(d)/vendor/bin/phpunit),)
PHPUNIT_EXE = /$(d)/vendor/bin/phpunit
endif

PHPUNIT_CONFIG =
ifneq ($(wildcard ../$(d)/phpunit.xml),)
PHPUNIT_CONFIG = /$(d)/phpunit.xml
endif
ifneq ($(wildcard ../$(d)/phpunit.xml.dist),)
PHPUNIT_CONFIG = /$(d)/phpunit.xml.dist
endif

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

monorepo_volume: monorepo_status ## Add a Docker volume for the Symfony monorepo
	$(M) repo_volume d=$(SYMFONY_MONOREPO_DIR)

monorepo_install: monorepo_status ## Install external dependencies used during the tests in the Symfony monorepo
	$(M) repo_install d=$(SYMFONY_MONOREPO_DIR)

monorepo_update: monorepo_status ## Update Composer dependencies in the Symfony monorepo
	$(M) repo_update d=$(SYMFONY_MONOREPO_DIR)

##

monorepo_link: monorepo_status ## Replace vendors with symlinks to the Symfony monorepo
	$(PHP) /$(SYMFONY_MONOREPO_DIR)/link /app
	@printf "🔗 Local directory $(Y)/$(SYMFONY_MONOREPO_DIR)$(S) linked to the project\n"

monorepo_unlink: monorepo_status ## Restore original vendors (rollback symlinks to the Symfony monorepo)
	$(PHP) /$(SYMFONY_MONOREPO_DIR)/link /app --rollback
	@printf "🔙 Original vendors restored (detached from $(Y)/$(SYMFONY_MONOREPO_DIR)$(S))\n"

link: monorepo_link ## monorepo_link alias

unlink: monorepo_unlink ## monorepo_unlink alias

##

.PHONY: monorepo_status ms
monorepo_status ms: _monorepo ## Show current branch for reproducer and the Symfony monorepo
	$(M) repo_status d=$(SYMFONY_MONOREPO_DIR) a=$(a)

.PHONY: monorepo_tests mt
monorepo_tests mt: monorepo_status ## Run PHPUnit tests in the Symfony monorepo | [a=<args>] | a=/symfony/src/Symfony/Bundle/FrameworkBundle
	$(M) repo_tests d=$(SYMFONY_MONOREPO_DIR) a="$(a)"

monorepo_coverage mc: ## Generate HTML coverage report | [a=<args>] | a="/symfony/src/Symfony/Component/Console"
	$(M) repo_coverage d=$(SYMFONY_MONOREPO_DIR) a="$(a)"

monorepo_tests_clean: monorepo_status ## Clean PHPUnit cache and temporary files in the Symfony monorepo
	$(M) repo_tests_clean d=$(SYMFONY_MONOREPO_DIR)

monorepo_clean: monorepo_status ## Remove vendor and lock file from the Symfony monorepo
	$(M) repo_clean d=$(SYMFONY_MONOREPO_DIR)

## ▸ OTHER REPO

_repo: # INTERNAL
	@if [ ! -d "../$(d)" ]; then \
		printf "$(R)✘ Directory '../$(d)' not found. Clone your fork side-by-side with the Symfony Starter first.$(S)\n"; \
		exit 1; \
	fi

repo_volume: repo_status ## Add a Docker volume for a local repository | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(M) ya f=compose.override.yaml k=services.php.volumes v='../$(d):/$(d)'
	@sed -i'' "s|^SAFE_DIRECTORIES = .*|& /$(d)|" Makefile
	$(M) co m="Add the Docker volume for the $(d) repository"
	$(M) restart

repo_add: repo_status ## Register a path repository in composer.json | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(COMPOSER) config repositories.$(d) '{"type": "path", "url": "../$(d)", "options": {"symlink": true}}'
	$(M) co m="Register the $(d) path repository"

repo_install: repo_status ## Install external dependencies used during the tests | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	@printf "🧙 Install Composer packages in $(Y)/$(d)$(S)\n"
	$(COMPOSER) install --working-dir=/$(d)

repo_update: repo_status ## Update Composer dependencies in a local repository | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	@printf "🧙 Update Composer packages in $(Y)/$(d)$(S)\n"
	$(COMPOSER) update --working-dir=/$(d)

##

.PHONY: repo_status rs
repo_status rs: _repo ## Show current branch for reproducer and a local repository | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	@printf "$(Y)%-25s  %s$(S)\n" "REPOSITORY" "BRANCH"
	@printf "%-25s  %s\n" "$(PROJECT_NAME)" "$$(git rev-parse --abbrev-ref HEAD)"
	@printf "%-25s  %s\n" "$(d)" "$$(git -C ../$(d) rev-parse --abbrev-ref HEAD)"
	@printf "\n"

.PHONY: repo_tests rt
repo_tests rt: repo_tests_clean repo_status ## Run PHPUnit tests in a local repository | d=<dir> [a=<args>] | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(if $(PHPUNIT_EXE),, $(error PHPUnit executable not found in /$(d)))
	$(if $(PHPUNIT_CONFIG),, $(error PHPUnit configuration file not found in /$(d)))
	$(CONTAINER_PHP) $(PHPUNIT_EXE) -c $(PHPUNIT_CONFIG) $(a)

.PHONY: repo_coverage rc
repo_coverage rc: repo_tests_clean repo_status ## Generate HTML coverage report for a local repository | d=<dir> [a=<args>] | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(if $(PHPUNIT_EXE),, $(error PHPUnit executable not found in /$(d)))
	$(if $(PHPUNIT_CONFIG),, $(error PHPUnit configuration file not found in /$(d)))
	-$(CONTAINER_PHP_COVERAGE) $(PHPUNIT_EXE) -c $(PHPUNIT_CONFIG) $(a) --coverage-html $(COVERAGE_DIR)
	@printf " $(G)✔$(S) Coverage report: $(Y)$(COVERAGE_INDEX)$(S)\n"

repo_tests_clean: repo_status ## Clean PHPUnit cache and temporary files in a local repository | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(CONTAINER_PHP) rm -fr /tmp/* /$(d)/.phpunit.result.cache /$(d)/var/cache/*

##

repo_remove: repo_status ## Unregister a path repository from composer.json | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(COMPOSER) config --unset repositories.$(d)


repo_clean: repo_status ## Remove vendor and lock file from a local repository | d=<dir> | d=monolog-bundle
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(CONTAINER_PHP) rm -fr /$(d)/vendor /$(d)/composer.lock
