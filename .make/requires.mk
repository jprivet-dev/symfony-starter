_assets: # INTERNAL
ifeq ($(wildcard $(VENDOR_ASSETS)),)
	@printf "\n $(R)⨯ Missing package:$(S) please install $(Y)AssetMapper$(S) with $(G)make frontend_asset_mapper$(S)\n"
	@exit 1
endif

_assets_or_encore: # INTERNAL
ifeq ($(wildcard $(VENDOR_ASSETS))$(wildcard $(WEBPACK_CONFIG)),)
	@printf "\n $(R)⨯ Missing package:$(S) please install $(Y)AssetMapper$(S) with $(G)make frontend_asset_mapper$(S) or $(Y)Webpack Encore$(S) with $(G)make frontend_webpack_encore$(S)\n"
	@exit 1
endif

_doctrine: # INTERNAL
ifeq ($(wildcard $(VENDOR_DOCTRINE_ORM)),)
	@printf "\n $(R)⨯ Missing package:$(S) please install $(Y)Doctrine$(S) with $(G)make require_orm$(S)\n"
	@exit 1
endif

_encore: # INTERNAL
ifeq ($(wildcard $(WEBPACK_CONFIG)),)
	@printf "\n $(R)⨯ Missing package:$(S) please install $(Y)Webpack Encore (with Node.js)$(S) with $(G)make frontend_webpack_encore$(S)\n"
	@exit 1
endif

_monolog: # INTERNAL
ifeq ($(wildcard $(VENDOR_MONOLOG)),)
	@printf "\n $(R)⨯ Missing package:$(S) please install $(Y)MonologBundle$(S)\n"
	@exit 1
endif

_phpcsfixer: # INTERNAL
ifeq ($(wildcard $(VENDOR_PHPCSFIXER)),)
	@printf "\n $(R)⨯ Missing package:$(S) please install $(Y)PHP CS Fixer$(S) with $(G)make require_phpcsfixer$(S)\n"
	@exit 1
endif

_phpmd: # INTERNAL
ifeq ($(wildcard $(VENDOR_PHPMD)),)
	@printf "\n $(R)⨯ Missing package:$(S) please install $(Y)PHP Mess Detector$(S) with $(G)make require_phpmd$(S)\n"
	@exit 1
endif

_phpmetrics: # INTERNAL
ifeq ($(wildcard $(VENDOR_PHPMETRICS)),)
	@printf "\n $(R)⨯ Missing package:$(S) please install $(Y)PHPMetrics$(S) with $(G)make require_phpmetrics$(S)\n"
	@exit 1
endif

_phpstan: # INTERNAL
ifeq ($(wildcard $(VENDOR_PHPSTAN)),)
	@printf "\n $(R)⨯ Missing package:$(S) please install $(Y)PHPStan$(S) with $(G)make require_phpstan$(S)\n"
	@exit 1
endif

_phpunit: # INTERNAL
ifeq ($(wildcard $(BIN_PHPUNIT)),)
	@printf "\n $(R)⨯ Missing package:$(S) please install $(Y)PHPUnit$(S) with $(G)make require_test_pack$(S)\n"
	@exit 1
endif

_translation: # INTERNAL
ifeq ($(wildcard $(VENDOR_TRANSLATION)),)
	@printf "\n $(R)⨯ Missing package:$(S) please install $(Y)Translation$(S) with $(G)make require_translation$(S)\n"
	@exit 1
endif

_twigcsfixer: # INTERNAL
ifeq ($(wildcard $(VENDOR_TWIGCSFIXER)),)
	@printf "\n $(R)⨯ Missing package:$(S) please install $(Y)Twig CS Fixer$(S) with $(G)make require_twigcsfixer$(S)\n"
	@exit 1
endif
