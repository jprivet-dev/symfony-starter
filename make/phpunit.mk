## — PHPUNIT ✅ ———————————————————————————————————————————————————————————————

_phpunit:
ifeq ($(wildcard $(BIN_PHPUNIT)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)PHPUnit$(S) with $(G)make require_test_pack$(S)\n"
	@exit 1
endif

.PHONY: phpunit p
phpunit p: _phpunit ## Run PHPUnit - $ make phpunit [a=<arguments>] - Example: $ make phpunit a="tests/myTest.php"
	@printf "\n$(Y)--- PHPUnit ---$(S)\n"
	$(PHPUNIT) $(a)

phpunit_log: FILE = $(BUILD)/phpunit/phpunit-$(NOW).log
phpunit_log: _phpunit ## Exporting PHPUnit terminal output to a log file
	mkdir -p $(BUILD)/phpunit
	-$(MAKE) phpunit >$(FILE)
	@printf " $(G)✔$(S) PHPUnit terminal output is ready at $(Y)$(PWD)/$(FILE)$(S)\n"

##

.PHONY: coverage
coverage: DIR = $(BUILD)/coverage/coverage-$(NOW)
coverage: _phpunit ## Generate code coverage report in HTML format - $ make coverage [a=<arguments>] - Example: $ make coverage a="tests/myTest.php"
	@printf "\n$(Y)--- PHPUnit Coverage ---$(S)\n"
	mkdir -p $(BUILD)/coverage
	-$(PHPUNIT_COVERAGE) --coverage-html $(DIR) $(a)
	@printf " $(G)✔$(S) Coverage is ready at $(Y)$(PWD)/$(DIR)/index.html$(S)\n"

.PHONY: dox
dox: _phpunit ## Report test execution progress in TestDox format - $ make dox [a=<arguments>] - Example: $ make dox a="tests/myTest.php"
	@printf "\n$(Y)--- PHPUnit TestDox ---$(S)\n"
	$(PHPUNIT) --testdox $(a)

dox_html: FILE = $(BUILD)/dox/testdox-$(NOW).html
dox_html: _phpunit ## Report test execution progress in TestDox format and export it to an HTML file
	mkdir -p $(BUILD)/dox
	-$(PHPUNIT) --testdox-html $(FILE) $(a)
	@printf " $(G)✔$(S) TestDox report is ready at $(Y)$(PWD)/$(FILE)$(S)\n"

dox_text: FILE = $(BUILD)/dox/testdox-$(NOW).txt
dox_text: _phpunit ## Report test execution progress in TestDox format and export it to a text file
	mkdir -p $(BUILD)/dox
	-$(PHPUNIT) --testdox-text $(FILE) $(a)
	@printf " $(G)✔$(S) TestDox report is ready at $(Y)$(PWD)/$(FILE)$(S)\n"

xdebug_version: ## Xdebug version number
	$(PHP) -r "var_dump(phpversion('xdebug'));"
