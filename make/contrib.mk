## — SYMFONY CONTRIBUTION 🔗 ——————————————————————————————————————————————————

##   (to delete this section, delete make/contrib.mk)
##

contrib_directory: ## Add a Docker volume for a directory - $ make contrib_directory d=<directory> - Example: $ make contrib_directory d=symfony
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(MAKE) ya f=compose.override.yaml k=services.php.volumes v='../$(d):/$(d)'
	@sed -i'' "s|^SAFE_DIRECTORIES = .*|& /$(d)|" Makefile

##

contrib_link: ## Link a local directory to the project (replace vendors with symlinks) - $ make contrib_link d=<directory> - Example: $ make contrib_link d=symfony
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(PHP) /$(d)/link /app
	@printf "🔗 Local directory $(Y)/$(d)$(S) linked to the project\n"

contrib_unlink: ## Restore original vendors (rollback links from a directory) - $ make contrib_unlink d=<directory> - Example: $ make contrib_unlink d=symfony
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(PHP) /$(d)/link /app --rollback
	@printf "🔙 Original vendors restored (detached from $(Y)/$(d)$(S))\n"

##

contrib_install: ## Install Composer packages in a directory - $ make contrib_install d=<directory> - Example: $ make contrib_install d=symfony
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	@printf "🧙 Install Composer packages in $(Y)/$(d)$(S)\n"
	$(COMPOSER) install --working-dir=/$(d)

contrib_clean: ## Remove vendor and lock file from a directory - $ make contrib_clean d=<directory> - Example: $ make contrib_clean d=symfony
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(PHP) rm -fr /$(d)/vendor /$(d)/composer.lock

##

contrib_tests: ## Run PHPUnit tests in a directory - $ make contrib_tests d=<directory> [a=<arguments>] - Example: $ make contrib_tests d=symfony a="src/Symfony/Bundle/FrameworkBundle"
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(PHP) /$(d)/phpunit $(a)

contrib_tests_www_data: ## Run PHPUnit tests in a directory as www-data user - $ make contrib_tests_www_data d=<directory> [a=<arguments>]
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	FORCE_WWW_DATA_USER=true $(MAKE) contrib_tests d=$(d) a=$(a)

contrib_tests_clean: ## Clean PHPUnit cache and temporary files in a directory - $ make contrib_tests_clean d=<directory> - Example: $ make contrib_tests_clean d=symfony
	$(if $(d),, $(error "Please specify a directory name with 'd=...'"))
	$(PHP) rm -fr /tmp/* /$(d)/.phpunit.result.cache
