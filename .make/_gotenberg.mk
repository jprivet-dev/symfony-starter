## — GOTENBERGBUNDLE CONTRIBUTION 🔗 ——————————————————————————————————————————

GOTENBERG_BUNDLE_DIR           = GotenbergBundle
GOTENBERG_DAGGER               = cd ../$(GOTENBERG_BUNDLE_DIR) && dagger
GOTENBERG_SYMFONY_VERSION      = 6.4.*
GOTENBERG_PHP_VERSION          = 8.2
GOTENBERG_SYMFONY_PHP_VERSIONS = \
    6.4.*:8.1 6.4.*:8.2 6.4.*:8.3 6.4.*:8.4 6.4.*:8.5 \
    7.3.*:8.2 7.3.*:8.3 7.3.*:8.4 7.3.*:8.5 \
    7.4.*:8.2 7.4.*:8.3 7.4.*:8.4 7.4.*:8.5 \
    8.0.*:8.4 8.0.*:8.5 \
    8.1.*:8.4 8.1.*:8.5

gotenberg_status: ## Show current branch for reproducer and GotenbergBundle repository
	$(MAKE) repo_status d=$(GOTENBERG_BUNDLE_DIR)

gotenberg_install: ## Install external dependencies used during the tests and initialize Dagger
	$(MAKE) repo_install d=$(GOTENBERG_BUNDLE_DIR)
	$(MAKE) dagger_develop

gotenberg_tests: ## Run PHPUnit tests
	$(MAKE) repo_tests d=$(GOTENBERG_BUNDLE_DIR)

gotenberg_coverage: ## Generate HTML coverage report
	$(MAKE) repo_coverage d=$(GOTENBERG_BUNDLE_DIR)

##

dagger_develop: ## Initialize Dagger module in GotenbergBundle
	$(GOTENBERG_DAGGER) develop

dagger_all: ## Run all Dagger checks (stop on failure) [GotenbergBundle]
	$(MAKE) dagger_cs_fixer
	$(MAKE) dagger_phpstan
	$(MAKE) dagger_deps
	$(MAKE) dagger_docs
	$(MAKE) dagger_phpunit

##

dagger_cs_fixer: ## Fix code style via Dagger [GotenbergBundle]
	$(GOTENBERG_DAGGER) call php-cs-fixer fix

dagger_phpstan: ## Run PHPStan static analysis via Dagger [GotenbergBundle]
	$(GOTENBERG_DAGGER) call test --symfony-version='$(GOTENBERG_SYMFONY_VERSION)' --php-version='$(GOTENBERG_PHP_VERSION)' phpstan

dagger_deps: ## Validate Composer dependencies via Dagger [GotenbergBundle]
	$(GOTENBERG_DAGGER) call test --symfony-version='$(GOTENBERG_SYMFONY_VERSION)' --php-version='$(GOTENBERG_PHP_VERSION)' validate-dependencies

dagger_docs: ## Generate documentation via Dagger [GotenbergBundle]
	$(GOTENBERG_DAGGER) call generate-docs

dagger_phpunit: ## Run PHPUnit tests via Dagger for all Symfony/PHP version combinations [GotenbergBundle]
	@for pair in $(GOTENBERG_SYMFONY_PHP_VERSIONS); do \
		s=$$(echo $$pair | cut -d: -f1); p=$$(echo $$pair | cut -d: -f2); \
		$(GOTENBERG_DAGGER) test --symfony-version="$$s" --php-version="$$p" phpunit; \
	done
