## — MONOLOG 📝 ———————————————————————————————————————————————————————————————

_monolog:
ifeq ($(wildcard $(VENDOR_MONOLOG)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)MonologBundle$(S)\n"
	@exit 1
endif

monolog: _monolog ## Dump the current configuration for MonologBundle (current APP_ENV)
	$(CONSOLE) debug:config monolog $(a)

monolog@prod: a=--env=prod
monolog@prod: monolog ## Dump the current configuration for MonologBundle (PROD)

##

monolog_default: _monolog ## Dump the default configuration for MonologBundle
	$(CONSOLE) config:dump-reference monolog $(a)

monolog_default_xml: a=--format=xml
monolog_default_xml: monolog_default ## Dump the default configuration for MonologBundle (XML format)
