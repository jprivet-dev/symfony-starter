## — ASSETS 🎨‍ ————————————————————————————————————————————————————————————————

.PHONY: assets a
assets a: assets_install assets_generate ## Install and generate all assets

assets_install: ## Install all assets
ifneq ($(wildcard $(VENDOR_ASSET_MAPPER)),)
	$(MAKE) importmap_install
endif
ifneq ($(wildcard $(WEBPACK_CONFIG)),)
	$(MAKE) npm_install
endif

assets_generate: ## Generate all assets
ifneq ($(wildcard $(VENDOR_TAILWIND)),)
ifeq ($(APP_ENV),prod)
	$(MAKE) tailwind_minify
else
	$(MAKE) tailwind_build
endif
endif
ifneq ($(wildcard $(WEBPACK_CONFIG)),)
ifeq ($(APP_ENV),prod)
	$(MAKE) npm_build
else
	$(MAKE) npm_dev
endif
endif
	$(MAKE) cache_clear

ifneq ($(or $(ALL), $(wildcard $(VENDOR_ASSET_MAPPER))),)
include .make/asset_mapper.mk
endif

ifneq ($(or $(ALL), $(wildcard $(VENDOR_TAILWIND))),)
include .make/asset_mapper_tailwind.mk
endif

ifneq ($(or $(ALL), $(wildcard $(WEBPACK_CONFIG))),)
include .make/encore.mk
endif
