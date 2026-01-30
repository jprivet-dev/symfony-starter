## — SYMFONY CONTRIBUTION 🔗 ——————————————————————————————————————————————————

##   (to delete this section, delete .mk/contrib.mk)
##

_monorepo: # INTERNAL - Check if local Symfony monorepo is correctly mounted
ifeq ($(wildcard $(SYMFONY_MONOREPO_PATH)/composer.json),)
	@printf " $(R)❌ Error:$(S) $(G)/symfony$(S) is missing or empty inside the container.$(S)\n"
	@printf "   1. Check $(Y)SYMFONY_MONOREPO_PATH$(S) in $(G).env.local$(S) if you don't use $(G)../symfony$(S) by default\n"
	@printf "   2. Run $(Y)make contrib_init$(S)\n"
	@exit 1
endif

contrib_init: ## Configure Docker volume for Symfony contribution (updates compose.override.yaml)
	$(MAKE) yq_add f=compose.override.yaml k=services.php.volumes v='$${SYMFONY_MONOREPO_PATH:-../symfony}:/symfony'
	$(MAKE) commit m="use volume to /symfony with SYMFONY_MONOREPO_PATH var in compose.override.yaml"
	$(MAKE) build up_detached
	@echo " $(G)🛠️ Docker for Symfony contribution configured...$(S)"

##

contrib_link: _monorepo ## Link local Symfony monorepo to the project (replace vendors with symlinks)
	$(PHP) /symfony/link /app
	@printf "🔗 Local Symfony repository linked to $(Y)$(SYMFONY_MONOREPO_PATH)$(S)\n"

contrib_unlink: _monorepo ## Restore original vendors (rollback links)
	$(PHP) /symfony/link /app --rollback
	@printf "🔙 Original vendors restored (detached from $(Y)$(SYMFONY_MONOREPO_PATH)$(S))\n"

##

contrib_install: _monorepo ## Install Composer packages in the local Symfony monorepo
	@printf "🧙 Install Composer packages in $(Y)$(SYMFONY_MONOREPO_PATH)$(S)\n"
	$(BASH_COMMAND) "cd /symfony && composer install"

contrib_clean: _monorepo ## Remove vendor and lock file from the local Symfony monorepo
	$(BASH_COMMAND) "rm -fr /symfony/vendor && rm -f /symfony/composer.lock"

##

contrib_tests: _monorepo ## Run PHPUnit tests in the local Symfony monorepo - $ make contrib_tests [a=<arguments>] - Example: $ make contrib_tests a="src/Symfony/Bundle/FrameworkBundle"
	#$(BASH_COMMAND) "cd /symfony && ./phpunit $(a)"

contrib_tests_www_data: ## Run PHPUnit tests in the local Symfony monorepo as www-data user - $ make contrib_tests_www_data [a=<arguments>] - Example: $ make contrib_tests_www_data a="src/Symfony/Bundle/FrameworkBundle"
	FORCE_WWW_DATA_USER=true $(MAKE) contrib_tests

contrib_tests_clean: _monorepo ## Clean PHPUnit cache and temporary files in the local Symfony monorepo
	$(BASH_COMMAND) "rm -fr /tmp/* && rm -f /symfony/.phpunit.result.cache"

##

tests_framework_bundle: a=src/Symfony/Bundle/FrameworkBundle
tests_framework_bundle: contrib_tests ## Run PHPUnit tests for the FrameworkBundle (Sample command: You can add any other necessary commands to this contrib.mk file)
