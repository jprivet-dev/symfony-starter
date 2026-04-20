## — SYMFONY CONTRIBUTION 🔗 ——————————————————————————————————————————————————

##   (to delete this section, delete .mk/contrib.mk)
##

contrib_volume: ## Add a Docker volume for a repository - $ make contrib_volume f=<folder> - Example: $ make contrib_volume f=symfony
	$(if $(f),, $(error "Please specify a folder name with 'f=...'"))
	$(MAKE) ya f=compose.override.yaml k=services.php.volumes v='../$(f):/$(f)'

##

contrib_link: ## Link the Symfony monorepo to the project (replace vendors with symlinks) - $ make contrib_link f=<folder> - Example: $ make contrib_link f=symfony
	$(if $(f),, $(error "Please specify a folder name with 'f=...'"))
	$(PHP) /$(f)/link /app
	@printf "🔗 Local repository $(Y)/$(f)$(S) linked to the project\n"

contrib_unlink: ## Restore original vendors (rollback links) - $ make contrib_unlink f=<folder> - Example: $ make contrib_unlink f=symfony
	$(if $(f),, $(error "Please specify a folder name with 'f=...'"))
	$(PHP) /$(f)/link /app --rollback
	@printf "🔙 Original vendors restored (detached from $(Y)/$(f)$(S))\n"

##

contrib_install: ## Install Composer packages in a repository - $ make contrib_install f=<folder> - Example: $ make contrib_install f=symfony
	$(if $(f),, $(error "Please specify a folder name with 'f=...'"))
	@printf "🧙 Install Composer packages in $(Y)/$(f)$(S)\n"
	$(COMPOSER) install --working-dir=/$(f)

contrib_clean: ## Remove vendor and lock file from a repository - $ make contrib_clean f=<folder> - Example: $ make contrib_clean f=symfony
	$(if $(f),, $(error "Please specify a folder name with 'f=...'"))
	$(PHP) rm -fr /$(f)/vendor /$(f)/composer.lock

##

contrib_tests: ## Run PHPUnit tests in a repository - $ make contrib_tests f=<folder> [a=<arguments>] - Example: $ make contrib_tests f=symfony a="src/Symfony/Bundle/FrameworkBundle"
	$(if $(f),, $(error "Please specify a folder name with 'f=...'"))
	$(PHP) /$(f)/phpunit $(a)

contrib_tests_www_data: ## Run PHPUnit tests as www-data user - $ make contrib_tests_www_data f=<folder> [a=<arguments>]
	$(if $(f),, $(error "Please specify a folder name with 'f=...'"))
	FORCE_WWW_DATA_USER=true $(MAKE) contrib_tests f=$(f) a=$(a)

contrib_tests_clean: ## Clean PHPUnit cache and temporary files - $ make contrib_tests_clean f=<folder> - Example: $ make contrib_tests_clean f=symfony
	$(if $(f),, $(error "Please specify a folder name with 'f=...'"))
	$(PHP) rm -fr /tmp/* /$(f)/.phpunit.result.cache
