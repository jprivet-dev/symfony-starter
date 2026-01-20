## — SYMFONY CONTRIBUTION 🔗 (remove .mk/contrib.mk if not necessary) —————————

contrib_link: ## Link local Symfony monorepo to the project (replace vendors with symlinks)
	$(PHP) /symfony/link /app
	@printf "🔗 Local Symfony repository linked to $(Y)$(SYMFONY_REPO_PATH)$(S)\n"

contrib_unlink: ## Restore original vendors (rollback links)
	$(PHP) /symfony/link /app --rollback
	@printf "🔙 Original vendors restored (detached from $(Y)$(SYMFONY_REPO_PATH)$(S))\n"

