## — SYMFONY CONTRIBUTION 🔗 ——————————————————————————————————————————————————

##   (to delete this section, delete .mk/contrib.mk)
##

_monorepo:
ifeq ($(wildcard $(SYMFONY_MONOREPO_PATH)),)
	@printf " $(R)⨯$(S) Remove the $(Y)SYMFONY CONTRIBUTION 🔗$(S) section or define $(Y)SYMFONY_MONOREPO_PATH$(S) in your $(G).env.local$(S)\n"
	@exit 1
endif

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
