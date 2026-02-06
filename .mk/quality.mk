## — QUALITY ✅ ———————————————————————————————————————————————————————————————

.PHONY: fix
fix: ## Fix with all linters
	-$(MAKE) phpcsfixer_fix
	-$(MAKE) twigcsfixer_fix

.PHONY: lint
lint: phpcsfixer_lint phpstan_lint phpmd_lint twigcsfixer_lint ## Run all linters (stop on failure)

##

_phpcsfixer:
ifeq ($(wildcard $(VENDOR_PHPCSFIXER)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)PHP CS Fixer$(S) with $(G)make require_phpcsfixer$(S)\n"
	@exit 1
endif

.PHONY: phpcsfixer
phpcsfixer: _phpcsfixer ## Run PHP CS Fixer - $ make phpcsfixer [a=<arguments>] - Example: $ make phpcsfixer a=list
	$(PHPCSFIXER) $(a)

phpcsfixer_fix: _phpcsfixer ## Fix code style
	$(PHPCSFIXER) --config=$(PHPCSFIXER_CONFIG) fix

phpcsfixer_lint: _phpcsfixer ## Check code style
	@printf "\n$(Y)--- PHP CS Fixer [LINT] ---$(S)\n"
	$(PHPCSFIXER) --config=$(PHPCSFIXER_CONFIG) check

##

_phpmd:
ifeq ($(wildcard $(VENDOR_PHPMD)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)PHP Mess Detector$(S) with $(G)make require_phpmd$(S)\n"
	@exit 1
endif

.PHONY: phpmd
phpmd: _phpmd ## Run PHP Mess Detector - $ make phpmd [a=<arguments>] - Example: $ make phpmd a="src ansi cleancode"
	$(PHPMD) $(a)

phpmd_lint: _phpmd ## Run PHP Mess Detector with all rules
	@printf "\n$(Y)--- PHP Mess Detector [LINT] ---$(S)\n"
	$(PHPMD) $(SRC),$(TESTS) ansi cleancode,codesize,controversial,design,naming,unusedcode $(a)

##

_phpmetrics:
ifeq ($(wildcard $(VENDOR_PHPMETRICS)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)PHPMetrics$(S) with $(G)make require_phpmetrics$(S)\n"
	@exit 1
endif

phpmetrics_report: DIR = $(BUILD)/phpmetrics/phpmetrics-$(NOW)
phpmetrics_report: _phpmetrics ## Run PHPMetrics and generate detailed report
	@printf "\n$(Y)--- PHPMetrics Report ---$(S)\n"
	mkdir -p $(BUILD)/phpmetrics
	$(PHPMETRICS) --report-html=$(DIR) $(SRC)
	@printf " $(G)✔$(S) PHPMetrics report is ready at $(Y)$(PWD)/$(DIR)/index.html$(S)\n"

##

_phpstan:
ifeq ($(wildcard $(VENDOR_PHPSTAN)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)PHPStan$(S) with $(G)make require_phpstan$(S)\n"
	@exit 1
endif

.PHONY: phpstan
phpstan: _phpstan ## Run PHPStan - $ make phpstan [a=<arguments>] - Example: $ make phpstan a="src tests"
	$(PHPSTAN) $(a)

phpstan_baseline: _phpstan ## Generate PHPStan baseline - $ make phpstan_baseline [a=<arguments>] - Example: $ make phpstan_baseline a="src tests"
	$(PHPSTAN) analyse -c $(PHPSTAN_CONFIG) $(a) --generate-baseline $(PHPSTAN_BASELINE)

phpstan_lint: _phpstan ## Run PHPStan analyse - $ make phpstan_analyse [a=<arguments>] - Example: $ make phpstan_analyse a="src tests"
	@printf "\n$(Y)--- PHPStan [LINT] ---$(S)\n"
	$(PHPSTAN) analyse -c $(PHPSTAN_CONFIG) $(a)

##

_twigcsfixer:
ifeq ($(wildcard $(VENDOR_TWIGCSFIXER)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)Twig CS Fixer$(S) with $(G)make require_twigcsfixer$(S)\n"
	@exit 1
endif

.PHONY: twigcsfixer
twigcsfixer: _twigcsfixer ## Run Twig CS Fixer - $ make twigcsfixer [a=<arguments>] - Example: $ make twigcsfixer a="lint /path/to/code"
	$(TWIGCSFIXER) $(a)

twigcsfixer_fix: _twigcsfixer ## Fix Twig style
	$(TWIGCSFIXER) lint --fix $(TEMPLATES)

twigcsfixer_lint: _twigcsfixer ## Check Twig style
	@printf "\n$(Y)--- Twig CS Fixer [LINT] ---$(S)\n"
	$(TWIGCSFIXER) lint $(TEMPLATES)
