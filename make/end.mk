## — CERTIFICATES 🔐‍️ ——————————————————————————————————————————————————————————

.PHONY: certificates
certificates: ## Install the Caddy TLS certificate to the trust store
	@printf "\n$(Y)--- Copying the Caddy certificate to trust store ---$(S)\n"
	@if [ ! -f /tmp/caddy_root.crt ]; then \
		$(CONTAINER_PHP) sh -c "cat /data/caddy/pki/authorities/local/root.crt" >/tmp/caddy_root.crt; \
	fi
ifeq ($(UNAME_S),Darwin)
	@printf " $(Y)› OS: macOS$(S)\n"
	@sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /tmp/caddy_root.crt
	@rm /tmp/caddy_root.crt
else ifeq ($(UNAME_S),Linux)
	@printf " $(Y)› OS: Linux$(S)\n"
	@sudo cp /tmp/caddy_root.crt /usr/local/share/ca-certificates/caddy_root.crt
	@sudo update-ca-certificates
	@rm /tmp/caddy_root.crt
endif
	@printf " $(G)✔$(S) The Caddy root certificate has been added to the trust store.\n"

certificates_export: FILE=$(BUILD)/tls/root.crt
certificates_export: ## Export the Caddy root certificate from the container to the host
	mkdir -p $(BUILD)/tls
	@$(CONTAINER_PHP) sh -c "cat /data/caddy/pki/authorities/local/root.crt" >$(FILE)
	@printf " $(G)✔$(S) The Caddy root certificate has been exported to $(Y)$(FILE)$(S).\n"
	@printf " $(Y)›$(S) You may need to manually import this certificate into your browser's trust store:\n"
	@printf "    - $(Y)Chrome/Brave:$(S) Go to chrome://settings/certificates and import the file '$(FILE)' under 'Authorities'.\n"
	@printf "    - $(Y)Firefox:$(S) Go to about:preferences#privacy, click 'View Certificates...' and import '$(FILE)' under 'Authorities'.\n"

.PHONY: hosts
hosts: ## Add the server name to /etc/hosts file
	@if ! grep -q "$(SERVER_NAME)" /etc/hosts; then \
		echo "127.0.0.1 $(SERVER_NAME)" | sudo tee -a /etc/hosts >/dev/null; \
		printf " $(G)✔$(S) \"$(SERVER_NAME)\" added to /etc/hosts.\n"; \
	else \
		printf " $(G)✔$(S) \"$(SERVER_NAME)\" already exists in /etc/hosts.\n"; \
	fi

## — GIT 🐙 ———————————————————————————————————————————————————————————————————

git_hooks_init: ## Initialize the project's hooks directory (set GIT_HOOKS var)
	@printf "\n$(Y)--- Git hooks init (GIT_HOOKS=$(GIT_HOOKS)) ---$(S)\n"
ifeq ($(GIT_HOOKS),on)
	$(MAKE) git_hooks_enable
else
	$(MAKE) git_hooks_disable
endif

##

git_hooks_disable: ## Disable the project's hooks directory
	-git config --unset core.hooksPath
	@printf " $(R)⨯$(S) Git hooks disabled.\n"

git_hooks_enable: ## Enable the project's hooks directory
	-git config core.hooksPath hooks/
	@printf " $(G)✔$(S) Git hooks enabled.\n"

git_pre_push: check_push ## Actions on Git pre-push

## — TROUBLESHOOTING 😵️ ———————————————————————————————————————————————————————

.PHONY: permissions
permissions: ## Fix file permissions (primarily for Linux hosts)
	@printf "\n$(Y)--- Permissions ---$(S)\n"
ifeq ($(UNAME_S),Linux)
	$(COMPOSE) run --rm php chown -R $(USER) .
	@printf " $(G)✔$(S) You are now defined as the owner $(Y)$(USER)$(S) of the project files.\n"
else
	@printf " $(Y)›$(S) 'make permissions' is typically not needed on $(UNAME_S).\n"
endif

.PHONY: safe
safe: ## Add configured directories to Git's safe directories
	$(foreach dir, $(SAFE_DIRECTORIES), $(CONTAINER_PHP) git config --global --add safe.directory $(dir);)
	@printf " $(G)✔$(S) Git safe directories updated: $(Y)$(SAFE_DIRECTORIES)$(S)\n"

## — UTILITIES 🛠️ —————————————————————————————————————————————————————————————

.PHONY: aliases
aliases: ## Show aliases info and loading instructions
	@printf "To load aliases, run:\n  $(Y). aliases$(S)\nor:\n  $(Y)console aliases$(S)\n";

env_files: ## Show env files loaded into this Makefile
	@printf "\n$(Y)--- Symfony Env Files ---$(S)\n"
	@printf "Files loaded into this Makefile (in order of decreasing priority) $(Y)[APP_ENV=$(APP_ENV)]$(S):\n\n"
	@for file in .env.$(APP_ENV).local .env.$(APP_ENV) .env.local .env; do \
		if [ -f "$${file}" ]; then printf "$(G)✔$(S) $${file}\n"; else printf "$(R)⨯$(S) $${file}\n"; fi; \
	done

.PHONY: tree
tree: l ?= 3
tree: ## Visualize your structure (requires `tree` command) | [l=<level>] | l=1
	tree -a -A -L $(l) -F -I '.git' -I '.idea' --dirsfirst

.PHONY: vars
vars: ## Show key Makefile variables
	@printf "\n$(Y)--- Vars ---$(S)\n"
	@$(foreach var, \
		USER UNAME_S GIT_HOOKS APP_ENV UP_ENV COMPOSE_V2 COMPOSE FORCE_NO_TTY \
		CONTAINER_PHP PHP COMPOSER BASH_COMMAND CONSOLE \
		IS_MYSQL IS_POSTGRESQL IS_SQLITE, \
		printf "%-15s : %s\n" "${var}" "${${var}}"; \
	)

# —— INTERNAL (HIDDEN) 🚧‍️ ——————————————————————————————————————————————————————————————

PHONY: confirm
confirm: # INTERNAL - Display a confirmation before continuing [y/N]
	@if [ "$${NO_INTERACTION}" = "true" ]; then exit 0; fi; \
	printf "$(G)Do you want to continue?$(S) [$(Y)y/N$(S)]: " && read answer && [ $${answer:-N} = y ]

PHONY: runtime
runtime: # INTERNAL - Check if vendor/autoload_runtime.php is ready yet
	@printf "\nWaiting for Symfony Runtime...\n"
	@until $(CONTAINER_PHP) ls vendor/autoload_runtime.php >/dev/null 2>&1; do \
		printf " $(R)⨯$(S) The vendor file is not ready yet. Pause 3 seconds...\n"; \
		sleep 3; \
	done
	@printf " $(G)✔$(S) Symfony Runtime is ready!\n"
	@sleep 1
