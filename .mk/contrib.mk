## — SYMFONY CONTRIBUTION 🔗 ——————————————————————————————————————————————————

##   (to delete this section, delete .mk/contrib.mk)
##

CONTRIB_INTERNAL_PATH = /symfony
CONTRIB_DEFAULT_PATH  = ../symfony
CONTRIB_PATH          = $(or $(SYMFONY_MONOREPO),$(CONTRIB_DEFAULT_PATH))
CONTRIB_COMPOSER      = $(CONTRIB_PATH)/composer.json

_monorepo: # INTERNAL - Check if local Symfony monorepo is correctly mounted
ifeq ($(wildcard $(CONTRIB_PATH)),)
	@printf " $(R)❌ Error: $(CONTRIB_PATH) does not exist on your machine.$(S)\n"
	@printf " $(Y)›$(S) Check $(Y)CONTRIB_MONOREPO_LOCAL_PATH$(S) in your $(G).env.local$(S) file if you don't use $(G)$(CONTRIB_DEFAULT_PATH)$(S) by default\n"
	@exit 1
endif
	@$(BASH_COMMAND) "test -f $(CONTRIB_COMPOSER)" \
		|| (printf " $(R)❌ Error: Volume not mounted in Docker.$(S)\n" \
		&& printf " $(Y)›$(S) The directory $(Y)$(CONTRIB_INTERNAL_PATH)$(S) is missing inside the container.\n" \
		&& printf " $(Y)›$(S) Run $(G)make contrib_init$(S) to add the volume in your $(Y)compose.override.yaml$(S) file.\n" \
		&& exit 1)

contrib_check: _monorepo ## Check if local Symfony monorepo is correctly mounted
	@echo "  $(G)✔ All is good!$(S) The Docker volume $(Y)$(CONTRIB_INTERNAL_PATH)$(S) is configured and connected to $(Y)$(CONTRIB_PATH).$(S)"

contrib_init: ## Configure Docker volume for Symfony contribution (updates compose.override.yaml)
	$(MAKE) ya f=compose.override.yaml k=services.php.volumes v='$${SYMFONY_MONOREPO:-../symfony}:/symfony'
	$(MAKE) commit m="use volume to $(CONTRIB_INTERNAL_PATH) with SYMFONY_MONOREPO var in compose.override.yaml"
	$(MAKE) build up_detached
	@echo " $(G)✔ Docker for Symfony contribution configured...$(S)"

##

contrib_link: _monorepo ## Link local Symfony monorepo to the project (replace vendors with symlinks)
	$(PHP) $(CONTRIB_INTERNAL_PATH)/link /app
	@printf "🔗 Local Symfony repository linked to $(Y)$(SYMFONY_MONOREPO)$(S)\n"

contrib_unlink: _monorepo ## Restore original vendors (rollback links)
	$(PHP) $(CONTRIB_INTERNAL_PATH)/link /app --rollback
	@printf "🔙 Original vendors restored (detached from $(Y)$(SYMFONY_MONOREPO)$(S))\n"

##

contrib_install: _monorepo ## Install Composer packages in the local Symfony monorepo
	@printf "🧙 Install Composer packages in $(Y)$(SYMFONY_MONOREPO)$(S)\n"
	$(BASH_COMMAND) "cd $(CONTRIB_INTERNAL_PATH) && composer install"

contrib_clean: _monorepo ## Remove vendor and lock file from the local Symfony monorepo
	$(BASH_COMMAND) "rm -fr $(CONTRIB_INTERNAL_PATH)/vendor && rm -f $(CONTRIB_INTERNAL_PATH)/composer.lock"

##

contrib_tests: _monorepo ## Run PHPUnit tests in the local Symfony monorepo - $ make contrib_tests [a=<arguments>] - Example: $ make contrib_tests a="src/Symfony/Bundle/FrameworkBundle"
	$(BASH_COMMAND) "cd $(CONTRIB_INTERNAL_PATH) && ./phpunit $(a)"

contrib_tests_www_data: ## Run PHPUnit tests in the local Symfony monorepo as www-data user - $ make contrib_tests_www_data [a=<arguments>] - Example: $ make contrib_tests_www_data a="src/Symfony/Bundle/FrameworkBundle"
	FORCE_WWW_DATA_USER=true $(MAKE) contrib_tests

contrib_tests_clean: _monorepo ## Clean PHPUnit cache and temporary files in the local Symfony monorepo
	$(BASH_COMMAND) "rm -fr /tmp/* && rm -f $(CONTRIB_INTERNAL_PATH)/.phpunit.result.cache"

##

doctrine_bridge: a=src/Symfony/Bridge/Doctrine
doctrine_bridge: contrib_tests ## Run PHPUnit tests for the Doctrine Bridge

monolog_bridge: a=src/Symfony/Bridge/Monolog
monolog_bridge: contrib_tests ## Run PHPUnit tests for the Monolog Bridge

phpunit_bridge: a=src/Symfony/Bridge/PhpUnit
phpunit_bridge: contrib_tests ## Run PHPUnit tests for the PhpUnit Bridge

psr_http_message_bridge: a=src/Symfony/Bridge/PsrHttpMessage
psr_http_message_bridge: contrib_tests ## Run PHPUnit tests for the PsrHttpMessage Bridge

twig_bridge: a=src/Symfony/Bridge/Twig
twig_bridge: contrib_tests ## Run PHPUnit tests for the Twig Bridge

##

debug_bundle: a=src/Symfony/Bundle/DebugBundle
debug_bundle: contrib_tests ## Run PHPUnit tests for the DebugBundle

framework_bundle: a=src/Symfony/Bundle/FrameworkBundle
framework_bundle: contrib_tests ## Run PHPUnit tests for the FrameworkBundle

security_bundle: a=src/Symfony/Bundle/SecurityBundle
security_bundle: contrib_tests ## Run PHPUnit tests for the SecurityBundle

twig_bundle: a=src/Symfony/Bundle/TwigBundle
twig_bundle: contrib_tests ## Run PHPUnit tests for the TwigBundle

web_profiler_bundle: a=src/Symfony/Bundle/WebProfilerBundle
web_profiler_bundle: contrib_tests ## Run PHPUnit tests for the WebProfilerBundle

##

dependency_injection: a=src/Symfony/Component/DependencyInjection
dependency_injection: contrib_tests ## Run PHPUnit tests for the DependencyInjection Component (Sample command: You can add any other necessary commands to this contrib.mk file)
