## — TRANSLATION 🇬🇧 ———————————————————————————————————————————————————————————

_translation:
ifeq ($(wildcard $(VENDOR_TRANSLATION)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)Translation$(S) with $(G)make require_translation$(S)\n"
	@exit 1
endif

.PHONY: extract
extract: _translation ## Extract translation strings from templates
	$(CONSOLE) translation:extract --sort=asc --format=yaml --force fr
