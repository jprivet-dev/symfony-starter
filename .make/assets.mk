## — ASSETS 🎨‍ ————————————————————————————————————————————————————————————————

.PHONY: assets a
assets a: _assets ## Generate all assets
	@printf "\n$(Y)--- Assets (env: $(APP_ENV)) ---$(S)\n"
ifeq ($(APP_ENV),prod)
	$(MAKE) importmap_install
ifneq ($(wildcard $(VENDOR_TAILWIND)),)
	$(MAKE) tailwind_minify
endif
else
ifneq ($(wildcard $(VENDOR_TAILWIND)),)
	$(MAKE) tailwind_build
endif
endif
	$(MAKE) cache_clear

##

asset_map_clear: _assets ## Clear all assets in the public output directory
	$(COMPOSE) run --rm php rm -rf ./public/assets

asset_map_compile: _assets asset_map_clear ## Compile all mapped assets and write them to the final public output directory
	$(CONSOLE) asset-map:compile

asset_map_debug: _assets ## See all of the mapped assets
	$(CONSOLE) debug:asset-map --full

##

importmap_audit: _assets ## Check for security vulnerability advisories for dependencies
	$(CONSOLE) importmap:audit

importmap_install: _assets ## Download all assets that should be downloaded
	$(CONSOLE) importmap:install

importmap_outdated: _assets ## List outdated JavaScript packages and their latest versions | [p=<packages>] | p="lodash"
	$(CONSOLE) importmap:outdated $(p)

importmap_remove: _assets ## Remove JavaScript packages | p=<packages> | p="lodash"
	$(if $(p),, $(error "Please specify the packages with 'p=...'"))
	$(CONSOLE) importmap:remove $(p)

importmap_require: _assets ## Require JavaScript packages | p=<packages> | p="lodash@^4.15"
	$(if $(p),, $(error "Please specify the packages with 'p=...'"))
	$(CONSOLE) importmap:require $(p)

importmap_update: _assets ## Update JavaScript packages to their latest versions | [p=<packages>] | p="lodash"
	$(CONSOLE) importmap:update $(p)

ifneq ($(or $(ALL), $(wildcard $(VENDOR_TAILWIND))),)
include .make/assets_tailwind.mk
endif
