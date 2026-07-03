## — 🐳 🎵 THE SYMFONY STARTER MAKEFILE 🎵 🐳 —————————————————————————————————

.DEFAULT_GOAL = help
.PHONY: help
help: f ?=
help: MAX_LENGTH = 36
help: ## Display this help message with available commands
	@printf "Usage: make $(G)<target>$(S)\n"
	@printf "       make $(G)f=<find>$(S)\n"
	@grep -E '(^[.a-zA-Z_-]+[^:]+:.*##.*?$$)|(^#{2})' $(MAKEFILE_LIST) | awk -v find="$(f)" 'BEGIN {FS = "## "}\
	function show(targets, description) {\
		split(targets, parts, " "); target = parts[1]; alias = parts[2];\
		n = split(description, fields, / \| /); params = (n >= 2) ? " " fields[2] : ""; example = (n >= 3) ? " (e.g. make " target " " fields[3] ")" : "";\
		printf "\033[32m  %-$(MAX_LENGTH)s \033[35m%-2s \033[0m%s\033[36m%s\033[0m\n", target params, alias, fields[1], example;\
	} {\
		split($$1, line, ":"); targets=line[2]; description=$$2;\
		if      (find == "" && targets == "##")                    printf "\033[33m%s\n", "";\
		else if (find == "" && targets == "" && description != "") printf "\033[33m\n%s\n", description;\
		else if (find == "" && targets != "" && description != "") show(targets, description);\
		else if (targets != "" && description != "" && (index(tolower(targets), tolower(find)) || index(tolower(description), tolower(find)))) show(targets, description);\
	}'
	@echo

##

.PHONY: install
install: up_detached ## Start the project, install dependencies and show info
	$(MAKE) composer_install
ifneq ($(wildcard $(VENDOR_ASSETS)),)
	$(MAKE) assets
endif
ifneq ($(wildcard $(WEBPACK_CONFIG)),)
	$(MAKE) npm_install
endif
	$(MAKE) images permissions git_hooks_init info

.PHONY: info
info: ## Show project access info
	@printf "\n$(Y)--- Info ---$(S)\n"
	@printf " $(Y)›$(S) Copy $(Y)$(MAKE_LOCAL_MK_DIST)$(S) to $(G)$(MAKE_LOCAL_MK)$(S) (ignored by Git) to extend the Makefile with your own local commands.\n"
	@printf " $(Y)›$(S) Run $(Y). aliases$(S) or $(Y)source aliases$(S) to create bash aliases for main make commands ($(G)symfony$(S), $(G)php$(S), $(G)composer$(S), ...)\n"
	@printf " $(Y)›$(S) Access to the application (accept the auto-generated TLS certificate):\n"
	@printf "    - Homepage ....... $(G)$(LOCALHOST)/$(S)\n"
ifneq ($(wildcard $(VENDOR_API)),)
	@printf "    - API ............ $(G)$(LOCALHOST_API)$(S)\n"
endif
ifneq ($(wildcard $(VENDOR_EASYADMIN)),)
	@printf "    - EasyAdmin ...... $(G)$(LOCALHOST_ADMIN)$(S)\n"
endif
ifneq ($(wildcard $(VENDOR_PROFILER)),)
	@printf "    - Profiler ....... $(G)$(LOCALHOST_PROFILER)$(S)\n"
endif
ifneq ($(wildcard $(VENDOR_MAILER)),)
	@printf "    - Mail Catcher ... $(G)$(LOCALHOST_MAILER)$(S)\n"
endif

##

.PHONY: start
start: up_detached images info ## Start the project and show info (detached mode)

.PHONY: stop
stop: down ## Stop the project (down)

##

.PHONY: restart
restart: ## [Level 1] Standard restart - Reloading containers (triggers: .env, compose.yaml, code changes)
	@printf " $(G)🔄 [Level 1] Standard restart - Reloading containers...$(S)\n"
	$(MAKE) stop start

build_start: ## [Level 2] Build & Start - Updating image with cache (triggers: composer.lock, CaddyFile, *.ini, entrypoint.sh)
	@printf " $(Y)🏗️ [Level 2] Build & Start - Updating image with cache...$(S)\n"
	$(MAKE) build start

build_force_start: ## [Level 3] Force build & Start - Rebuilding from scratch (triggers: Dockerfile, system packages, cache issues)
	@printf " $(R)🏗️ [Level 3] Force build & Start - Rebuilding from scratch...$(S)\n"
	$(MAKE) build_force start

##

check:  ## Check everything before you deliver - Composer, Doctrine validation, linters, ... (NO STOP on failure)
	-$(MAKE) composer_validate
ifneq ($(wildcard $(VENDOR_DOCTRINE_ORM)),)
	-$(MAKE) validate
endif
ifneq ($(or $(wildcard $(VENDOR_PHPCSFIXER)), $(wildcard $(VENDOR_PHPMD)), $(wildcard $(VENDOR_PHPMETRICS)), $(wildcard $(VENDOR_PHPSTAN)), $(wildcard $(VENDOR_TWIGCSFIXER))),)
	-$(MAKE) lint
endif
ifneq ($(wildcard $(BIN_PHPUNIT)),)
	-$(MAKE) phpunit
endif

check_stop: ## Check on git push (STOP on failure)
	$(MAKE) composer_validate
ifneq ($(wildcard $(VENDOR_DOCTRINE_ORM)),)
	$(MAKE) validate
endif
ifneq ($(or $(wildcard $(VENDOR_PHPCSFIXER)), $(wildcard $(VENDOR_PHPMD)), $(wildcard $(VENDOR_PHPMETRICS)), $(wildcard $(VENDOR_PHPSTAN)), $(wildcard $(VENDOR_TWIGCSFIXER))),)
	$(MAKE) lint
endif
ifneq ($(wildcard $(BIN_PHPUNIT)),)
	$(MAKE) phpunit
endif

.PHONY: tests t
tests t: ## Run all tests (STOP on failure)
ifneq ($(wildcard $(BIN_PHPUNIT)),)
	$(MAKE) phpunit
endif
