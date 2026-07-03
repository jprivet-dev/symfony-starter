## — SYMFONY 🎵 ———————————————————————————————————————————————————————————————

.PHONY: symfony sf
symfony sf: ## Run any Symfony console command | [c=<command>] | c=cache:clear
	$(CONSOLE) $(c)

.PHONY: console
console: ## Symfony console alias | [c=<command>] | c=cache:clear
	$(CONSOLE) $(c)

##

.PHONY: about
about: ## Display information about the current Symfony project
	$(CONSOLE) about

.PHONY: cc
cache_clear cc: ## Clear the Symfony cache
	$(CONSOLE) cache:clear

.PHONY: dotenv
dotenv: ## Lists all .env files with variables and values
	$(CONSOLE) debug:dotenv

.PHONY: dumpenv
dumpenv: ## Generate .env.local.php for production
	$(COMPOSER) dump-env prod

.PHONY: routes
routes: ## Display current routes with assigned controllers and aliases
	$(CONSOLE) debug:route --show-controllers --show-aliases
