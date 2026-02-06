## — DOCTRINE / SQL 💽 ————————————————————————————————————————————————————————

_doctrine:
ifeq ($(wildcard $(VENDOR_DOCTRINE)),)
	@printf "\n $(R)⨯$(S) Please install $(Y)Doctrine$(S) with $(G)make require_doctrine$(S)\n"
	@exit 1
endif

db_init: _doctrine db_drop db_create migrate ## Drop and create the database and migrate

db_init@test: a="--env=test"
db_init@test: _doctrine db_drop db_create migrate ## Drop and create the database and migrate (env=test)

##

db_drop: _doctrine confirm ## Drop the database [y/N] - $ make db_drop [a=<arguments>] - Example: $ make db_drop a="--env=test"
ifneq ($(IS_SQLITE),)
	@printf "$(G)SQLite$(S) detected via environment. Removing $(Y)$(SQLITE_DB_FILE)$(S).\n"
	rm -rf $(SQLITE_DB_FILE)
else
	@printf "$(G)Standard SQL$(S) engine detected. Dropping database...\n"
	$(CONSOLE) doctrine:database:drop --if-exists --force $(a)
endif

db_create: _doctrine ## Create the database - $ make db_create [a=<arguments>] - Example: $ make db_create a="--env=test"
ifneq ($(IS_SQLITE),)
	@printf "$(G)SQLite$(S) detected via environment. Ensuring directory exists for $(Y)$(SQLITE_DB_FILE)$(S).\n"
	$(CONSOLE) doctrine:schema:create $(a)
else
	@printf "$(G)Standard SQL$(S) engine detected. Creating database $(Y)$(SQLITE_DB_FILE)$(S)...\n"
	$(CONSOLE) doctrine:database:create --if-not-exists $(a)
endif

##

.PHONY: execute
execute: _doctrine ## Execute one or more migration versions up or down manually - $ make execute a=<arguments> - Example: $ make execute a="DoctrineMigrations\Version20240205143239"
	$(CONSOLE) doctrine:migrations:execute $(a)

.PHONY: generate
generate: _doctrine ## Generate a blank migration class
	$(CONSOLE) doctrine:migrations:generate

.PHONY: list
list: _doctrine ## Display a list of all available migrations and their status
	$(CONSOLE) doctrine:migrations:list

.PHONY: migrate
migrate: _doctrine ## Execute a migration to the latest available version (in a transaction) - $ make migrate [a=<param>] - Example: $ make migrate a="current+3"
	$(CONSOLE) doctrine:migrations:migrate --no-interaction --all-or-nothing $(a)

.PHONY: migration
migration: ## Create a new migration based on database changes (format the generated SQL)
	$(CONSOLE) make:migration --formatted -v $(a)

##

.PHONY: fixtures
fixtures: _doctrine ## Load fixtures (CAUTION! The load command purges the database) - $ make fixtures [a=<param>] - Example: $ make fixtures a="--append"
	$(CONSOLE) doctrine:fixtures:load -n $(a)

fixtures@test: a="--env=test"
fixtures@test: _doctrine fixtures ## Load fixtures (env=test)

.PHONY: sql
sql: _doctrine ## Execute the given SQL query and output the results - $ make sql [q=<query>] - Example: $ make sql q="SELECT * FROM user"
	$(CONSOLE) doctrine:query:sql "$(q)"

update_dump: _doctrine ## Generate and output the SQL needed to synchronize the database schema with the current mapping metadata
	$(CONSOLE) doctrine:schema:update --dump-sql

update_force: _doctrine ## Execute the generated SQL needed to synchronize the database schema with the current mapping metadata
	$(CONSOLE) doctrine:schema:update --force

.PHONY: validate
validate: _doctrine ## Validate the mapping files - $ make validate [a=<arguments>] - Example: $ make validate a="--env=test"
	@printf "\n$(Y)--- Doctrine Schema Validate ---$(S)\n"
	$(CONSOLE) doctrine:schema:validate -v $(a)

##

phpstorm_config: ## Display database connection details for PhpStorm "Data Sources and Drivers" dialog
	@printf "See https://www.jetbrains.com/help/phpstorm/data-sources-and-drivers-dialog.html\n"
ifneq ($(IS_POSTGRESQL),)
	@printf "\n$(Y)--- PostgreSQL ---$(S)\n"
	@printf "Name    : $(POSTGRES_DB)@$(POSTGRES_HOST_PUBLIC)\n"
	@printf "Host    : $(POSTGRES_HOST_PUBLIC)\n"
	@printf "User    : $(POSTGRES_USER)\n"
	@printf "Password: $(POSTGRES_PASSWORD)\n"
	@printf "Database: $(POSTGRES_DB)\n"
	@printf "URL     : jdbc:postgresql://$(POSTGRES_HOST_PUBLIC):$(POSTGRES_PORT_PUBLIC)/$(POSTGRES_DB)\n"
endif
ifneq ($(IS_MYSQL),)
	@printf "\n$(Y)--- MySQL/MariaDB ---$(S)\n"
	@printf "Name    : $(MARIADB_DATABASE)@$(MARIADB_HOST_PUBLIC)\n"
	@printf "Host    : $(MARIADB_HOST_PUBLIC)\n"
	@printf "User    : $(MARIADB_USER)\n"
	@printf "Password: $(MARIADB_PASSWORD)\n"
	@printf "Database: $(MARIADB_DATABASE)\n"
	@printf "URL     : jdbc:mariadb://$(MARIADB_HOST_PUBLIC):$(MARIADB_PORT_PUBLIC)/$(MARIADB_DATABASE)\n"
endif

