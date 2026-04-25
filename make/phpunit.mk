## — PHPUNIT ✅ ———————————————————————————————————————————————————————————————

.PHONY: phpunit p
phpunit p: _phpunit ## Run PHPUnit | [a=<args>] | a="tests/myTest.php"
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
coverage: _phpunit ## Generate code coverage report in HTML format | [a=<args>] | a="tests/myTest.php"
	@printf "\n$(Y)--- PHPUnit Coverage ---$(S)\n"
	mkdir -p $(BUILD)/coverage
	-$(PHPUNIT_COVERAGE) --coverage-html $(DIR) $(a)
	@printf " $(G)✔$(S) Coverage is ready at $(Y)$(PWD)/$(DIR)/index.html$(S)\n"

.PHONY: dox
dox: _phpunit ## Report test execution progress in TestDox format | [a=<args>] | a="tests/myTest.php"
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
