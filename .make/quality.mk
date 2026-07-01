## — QUALITY ✅ ———————————————————————————————————————————————————————————————

.PHONY: lint
lint: ## Run all linters (NO STOP on failure)
ifneq ($(wildcard $(VENDOR_PHPCSFIXER)),)
	-$(MAKE) phpcsfixer_check
endif
ifneq ($(wildcard $(VENDOR_TWIGCSFIXER)),)
	-$(MAKE) twigcsfixer_lint
endif
ifneq ($(wildcard $(VENDOR_PHPSTAN)),)
	-$(MAKE) phpstan_analyse
endif
ifneq ($(wildcard $(VENDOR_PHPMD)),)
	-$(MAKE) phpmd_lint
endif

##

.PHONY: phpcsfixer
phpcsfixer: _phpcsfixer ## Run PHP CS Fixer | [a=<args>] | a=list
	$(PHPCSFIXER) $(a)

phpcsfixer_check: _phpcsfixer ## Check code style
	@printf "\n$(Y)--- PHP CS Fixer [CHECK] ---$(S)\n"
	$(PHPCSFIXER) --config=$(PHPCSFIXER_CONFIG) check --diff

phpcsfixer_fix: _phpcsfixer ## Fix code style
	$(PHPCSFIXER) --config=$(PHPCSFIXER_CONFIG) fix

##

.PHONY: phpmd
phpmd: _phpmd ## Run PHP Mess Detector | [a=<args>] | a="src ansi cleancode"
	$(PHPMD) $(a)

phpmd_lint: _phpmd ## Run PHP Mess Detector with all rules
	@printf "\n$(Y)--- PHP Mess Detector [LINT] ---$(S)\n"
	$(PHPMD) $(SRC) ansi cleancode,codesize,controversial,design,naming,unusedcode $(a)

##

phpmetrics_report: DIR = $(BUILD)/phpmetrics/phpmetrics-$(NOW)
phpmetrics_report: _phpmetrics ## Run PHPMetrics and generate detailed report
	@printf "\n$(Y)--- PHPMetrics Report ---$(S)\n"
	mkdir -p $(BUILD)/phpmetrics
	$(PHPMETRICS) --report-html=$(DIR) $(SRC)
	@printf " $(G)✔$(S) PHPMetrics report is ready at $(Y)$(PWD)/$(DIR)/index.html$(S)\n"

##

.PHONY: phpstan
phpstan: _phpstan ## Run PHPStan | [a=<args>] | a="src tests"
	$(PHPSTAN) $(a)

phpstan_baseline: _phpstan ## Generate PHPStan baseline | [a=<args>] | a="src tests"
	$(PHPSTAN) analyse -c $(PHPSTAN_CONFIG) $(a) --generate-baseline $(PHPSTAN_BASELINE)

phpstan_analyse: _phpstan ## Run PHPStan analyse | [a=<args>] | a="src tests"
	@printf "\n$(Y)--- PHPStan [ANALYSE] ---$(S)\n"
	$(PHPSTAN) analyse -c $(PHPSTAN_CONFIG) $(a) --memory-limit=-1

##

.PHONY: twigcsfixer
twigcsfixer: _twigcsfixer ## Run Twig CS Fixer | [a=<args>] | a="lint /path/to/code"
	$(TWIGCSFIXER) $(a)

twigcsfixer_fix: _twigcsfixer ## Fix Twig style
	$(TWIGCSFIXER) lint --fix $(TEMPLATES)

twigcsfixer_lint: _twigcsfixer ## Check Twig style
	@printf "\n$(Y)--- Twig CS Fixer [LINT] ---$(S)\n"
	$(TWIGCSFIXER) lint $(TEMPLATES)
