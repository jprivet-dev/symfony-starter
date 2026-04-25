## — MONOLOG 📝 ———————————————————————————————————————————————————————————————

monolog: FILE = $(BUILD)/monolog/monolog-current-config-$(APP_ENV)-$(NOW).yaml
monolog: _monolog ## Export the Monolog current configuration (debug:config) to a YAML file
	mkdir -p $(BUILD)/monolog
	$(CONSOLE) debug:config monolog >$(FILE)
	@printf " $(G)✔$(S) Monolog current configuration is ready at $(Y)$(PWD)/$(FILE)$(S)\n"

monolog@prod: FILE = $(BUILD)/monolog/monolog-current-config-prod-$(NOW).yaml
monolog@prod: _monolog ## Export the Monolog current configuration (debug:config) to a YAML file (PROD)
	mkdir -p $(BUILD)/monolog
	$(CONSOLE) debug:config monolog --env=prod >$(FILE)
	@printf " $(G)✔$(S) Monolog current configuration is ready at $(Y)$(PWD)/$(FILE)$(S)\n"

monolog_default: FILE = $(BUILD)/monolog/monolog-default-config-$(NOW).yaml
monolog_default: _monolog ## Export the Monolog default configuration (config:dump-reference) to a YAML file
	mkdir -p $(BUILD)/monolog
	$(CONSOLE) config:dump-reference monolog >$(FILE)
	@printf " $(G)✔$(S) Monolog default configuration is ready at $(Y)$(PWD)/$(FILE)$(S)\n"
