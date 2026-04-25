## — QUALITY ✅ ———————————————————————————————————————————————————————————————

.PHONY: fix
fix: ## Fix with all linters
	-$(MAKE) phpcsfixer_fix
	-$(MAKE) twigcsfixer_fix

.PHONY: lint
lint: phpcsfixer_lint phpstan_lint phpmd_lint twigcsfixer_lint ## Run all linters (stop on failure)

##

.PHONY: phpcsfixer
phpcsfixer: _phpcsfixer ## Run PHP CS Fixer | [a=<args>] | a=list
	$(PHPCSFIXER) $(a)

phpcsfixer_fix: _phpcsfixer ## Fix code style
	$(PHPCSFIXER) --config=$(PHPCSFIXER_CONFIG) fix

phpcsfixer_lint: _phpcsfixer ## Check code style
	@printf "\n$(Y)--- PHP CS Fixer [LINT] ---$(S)\n"
	$(PHPCSFIXER) --config=$(PHPCSFIXER_CONFIG) check

##

.PHONY: phpmd
phpmd: _phpmd ## Run PHP Mess Detector | [a=<args>] | a="src ansi cleancode"
	$(PHPMD) $(a)

phpmd_lint: _phpmd ## Run PHP Mess Detector with all rules
	@printf "\n$(Y)--- PHP Mess Detector [LINT] ---$(S)\n"
	$(PHPMD) $(SRC),$(TESTS) ansi cleancode,codesize,controversial,design,naming,unusedcode $(a)

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

phpstan_lint: _phpstan ## Run PHPStan analyse | [a=<args>] | a="src tests"
	@printf "\n$(Y)--- PHPStan [LINT] ---$(S)\n"
	$(PHPSTAN) analyse -c $(PHPSTAN_CONFIG) $(a)

##

.PHONY: twigcsfixer
twigcsfixer: _twigcsfixer ## Run Twig CS Fixer | [a=<args>] | a="lint /path/to/code"
	$(TWIGCSFIXER) $(a)

twigcsfixer_fix: _twigcsfixer ## Fix Twig style
	$(TWIGCSFIXER) lint --fix $(TEMPLATES)

twigcsfixer_lint: _twigcsfixer ## Check Twig style
	@printf "\n$(Y)--- Twig CS Fixer [LINT] ---$(S)\n"
	$(TWIGCSFIXER) lint $(TEMPLATES)
