## — ASSET MAPPER 🧰‍ ——————————————————————————————————————————————————————————

asset_map_clear: _asset_mapper ## Clear all assets in the public output directory
	$(COMPOSE) run --rm php rm -rf ./public/assets

asset_map_compile: _asset_mapper asset_map_clear ## Compile all mapped assets and write them to the final public output directory
	$(CONSOLE) asset-map:compile

asset_map_debug: _asset_mapper ## See all of the mapped assets
	$(CONSOLE) debug:asset-map --full

##

importmap_audit: _asset_mapper ## Check for security vulnerability advisories for dependencies
	$(CONSOLE) importmap:audit

importmap_install: _asset_mapper ## Download all assets that should be downloaded
	$(CONSOLE) importmap:install

importmap_outdated: _asset_mapper ## List outdated JavaScript packages and their latest versions | [p=<packages>] | p="lodash"
	$(CONSOLE) importmap:outdated $(p)

importmap_remove: _asset_mapper ## Remove JavaScript packages | p=<packages> | p="lodash"
	$(if $(p),, $(error "Please specify the packages with 'p=...'"))
	$(CONSOLE) importmap:remove $(p)

importmap_require: _asset_mapper ## Require JavaScript packages | p=<packages> | p="lodash@^4.15"
	$(if $(p),, $(error "Please specify the packages with 'p=...'"))
	$(CONSOLE) importmap:require $(p)

importmap_update: _asset_mapper ## Update JavaScript packages to their latest versions | [p=<packages>] | p="lodash"
	$(CONSOLE) importmap:update $(p)
