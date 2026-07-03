## — WEBPACK ⚙️ ———————————————————————————————————————————————————————————————

.PHONY: node
node: ## Run Node.js | [a=<args>] | a=--help
	$(NODE) $(a)

##

.PHONY: npm
npm: ## Run the Node Package Manager | [a=<args>] | a=--help
	$(NPM) $(a)

npm_install: ## Install the project's Node.js dependencies | [a=<args>] | a=--help
	$(NPM) install $(a)

npm_watch: ## Compile assets and automatically re-compile when files change
	$(NPM) run watch

npm_dev_server: ## Run a dev-server that can sometimes update your code without refreshing the page
	$(NPM) run dev-server

npm_dev: ## Compile assets once
	$(NPM) run dev

npm_build: ## On deploy, create a production build
	$(NPM) run build

##

.PHONY: npx
npx: ## Run the Node Package eXecute | [a=<args>] | a=--help
	$(NPX) $(a)

.PHONY: webpack
webpack: ## Run the Webpack bundler | [a=<args>] | a=--help
	$(WEBPACK) $(a)

.PHONY: encore
encore: ## Run Webpack Encore | [a=<args>] | a=--help
	$(ENCORE) $(a)
