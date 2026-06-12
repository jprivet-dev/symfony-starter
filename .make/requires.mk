_assets: # INTERNAL
ifeq ($(wildcard $(VENDOR_ASSETS)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)AssetMapper$(S) with $(G)make require_asset_mapper$(S)\n"
	@exit 1
endif

_doctrine: # INTERNAL
ifeq ($(wildcard $(VENDOR_DOCTRINE)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)Doctrine$(S) with $(G)make require_orm$(S)\n"
	@exit 1
endif

_monolog: # INTERNAL
ifeq ($(wildcard $(VENDOR_MONOLOG)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)MonologBundle$(S)\n"
	@exit 1
endif

_phpcsfixer: # INTERNAL
ifeq ($(wildcard $(VENDOR_PHPCSFIXER)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)PHP CS Fixer$(S) with $(G)make require_phpcsfixer$(S)\n"
	@exit 1
endif

_phpmd: # INTERNAL
ifeq ($(wildcard $(VENDOR_PHPMD)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)PHP Mess Detector$(S) with $(G)make require_phpmd$(S)\n"
	@exit 1
endif

_phpmetrics: # INTERNAL
ifeq ($(wildcard $(VENDOR_PHPMETRICS)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)PHPMetrics$(S) with $(G)make require_phpmetrics$(S)\n"
	@exit 1
endif

_phpstan: # INTERNAL
ifeq ($(wildcard $(VENDOR_PHPSTAN)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)PHPStan$(S) with $(G)make require_phpstan$(S)\n"
	@exit 1
endif

_phpunit: # INTERNAL
ifeq ($(wildcard $(BIN_PHPUNIT)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)PHPUnit$(S) with $(G)make require_test_pack$(S)\n"
	@exit 1
endif

_translation: # INTERNAL
ifeq ($(wildcard $(VENDOR_TRANSLATION)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)Translation$(S) with $(G)make require_translation$(S)\n"
	@exit 1
endif

_twigcsfixer: # INTERNAL
ifeq ($(wildcard $(VENDOR_TWIGCSFIXER)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)Twig CS Fixer$(S) with $(G)make require_twigcsfixer$(S)\n"
	@exit 1
endif
