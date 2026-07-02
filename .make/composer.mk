## — COMPOSER 🧙 ——————————————————————————————————————————————————————————————

.PHONY: composer
composer: ## Run composer command | [a=<args>] | a="require --dev phpunit/phpunit"
	$(COMPOSER) $(a)

.PHONY: i
composer_install i: ## Install Composer packages
	@printf "\n$(Y)--- Composer Install (env: $(APP_ENV)) ---$(S)\n"
ifeq ($(APP_ENV),prod)
	$(COMPOSER) install --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader
else
	$(COMPOSER) install
endif

composer_validate: ## Check if lock file is up to date (even when config.lock is false)
	@printf "\n$(Y)--- Composer Validate ---$(S)\n"
	$(COMPOSER) validate --strict

##

.PHONY: config
config: ## Run composer config | k=<key> [v=<value>] | k=repositories.monolog-bundle v='{"type": "path", "url": "/monolog-bundle"}'
	$(if $(k),, $(error "Please specify a key with 'k=...'"))
	$(COMPOSER) config $(if $(v),$(k) '$(v)',--unset $(k))

.PHONY: hash
hash: ## Update only the content hash of composer.lock without updating dependencies
	$(COMPOSER) update --lock

.PHONY: outdated
outdated: ## Show a list of installed packages that have updates available, including their latest version
	$(COMPOSER) outdated

.PHONY: remove
remove: ## Remove a package from the require or require-dev | [a=<args>] | a="phpunit/phpunit"
	$(COMPOSER) remove $(a)

.PHONY: require
require: ## Add required packages to your composer.json and installs them | [a=<args>] | a="--dev phpunit/phpunit"
	$(COMPOSER) require $(a)

.PHONY: update
update: ## Update Composer packages | [a=<args>] | a="symfony/monolog-bundle"
	@printf "\n$(Y)--- Composer Update (env: $(APP_ENV)) ---$(S)\n"
ifeq ($(APP_ENV),prod)
	$(COMPOSER) update --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader $(a)
else
	$(COMPOSER) update $(a)
endif
