## — TRANSLATION 🇬🇧 ———————————————————————————————————————————————————————————

.PHONY: extract
extract: _translation ## Extract translation strings from templates
	$(CONSOLE) translation:extract --sort=asc --format=yaml --force fr
