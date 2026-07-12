## — PHP 🐘 ———————————————————————————————————————————————————————————————————

.PHONY: php
php: ## Run PHP command | [a=<args>] | a=--version
	$(PHP) $(a)

##

php_command: ## Run a command inside the PHP container | [a=<args>] | a="ls -al"
	$(BASH_COMMAND) "$(a)"

php_env: ## Display all environment variables set within the PHP container
	$(CONTAINER_PHP) env

.PHONY: sh
php_sh sh: ## Connect to the PHP container shell
	$(CONTAINER_PHP) sh
