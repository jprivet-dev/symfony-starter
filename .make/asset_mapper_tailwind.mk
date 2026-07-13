##

tailwind_init: ## Initializes Tailwind CSS for your project
	$(CONSOLE) tailwind:init

tailwind_clear: ## Clear var/tailwind directory
	$(COMPOSE) run --rm php rm -rf ./var/tailwind

tailwind_build: ## Build the Tailwind CSS assets | [a=<args>] | a=--help
	$(CONSOLE) tailwind:build -v $(a)

tailwind_watch w: a=--watch
tailwind_watch w: tailwind_build ## Watch for changes and rebuild automatically.

tailwind_minify: a=--minify
tailwind_minify: tailwind_build ## Minify the output CSS.

tailwind_debug: ## See the full config from TailwindBundle
	$(CONSOLE) config:dump symfonycasts_tailwind
