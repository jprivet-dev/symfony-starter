## — DOCTRINE / SQL 💽 ————————————————————————————————————————————————————————

db: _doctrine drop create migrate ## Drop and create the database and migrate

db@test: a="--env=test"
db@test: _doctrine drop create migrate ## Drop and create the database and migrate (env=test)

##

.PHONY: drop
drop: _doctrine confirm ## Drop the database [y/N] | [a=<args>] | a="--env=test"
ifneq ($(IS_SQLITE),)
	@printf "$(G)SQLite$(S) detected via environment. Removing $(Y)$(SQLITE_DB_FILE)$(S).\n"
	rm -rf $(SQLITE_DB_FILE)
else
	@printf "$(G)Standard SQL$(S) engine detected. Dropping database...\n"
	$(CONSOLE) doctrine:database:drop --if-exists --force $(a)
endif

.PHONY: create
create: _doctrine ## Create the database | [a=<args>] | a="--env=test"
ifneq ($(IS_SQLITE),)
	@printf "$(G)SQLite$(S) detected via environment. Ensuring directory exists for $(Y)$(SQLITE_DB_FILE)$(S).\n"
	mkdir -p $(dir $(SQLITE_DB_FILE))
else
	@printf "$(G)Standard SQL$(S) engine detected. Creating database $(Y)$(SQLITE_DB_FILE)$(S)...\n"
	$(CONSOLE) doctrine:database:create --if-not-exists $(a)
endif

##

.PHONY: diff
diff: _doctrine ## Generate a migration by comparing your current database to your mapping information (format the generated SQL) | [a=<args>] | a="--profile"
	$(CONSOLE) doctrine:migrations:diff --formatted -v $(a)

.PHONY: execute
execute: _doctrine ## Execute one or more migration versions up or down manually | a=<args> | a="DoctrineMigrations\Version20240205143239"
	$(CONSOLE) doctrine:migrations:execute $(a)

.PHONY: generate
generate: _doctrine ## Generate a blank migration class
	$(CONSOLE) doctrine:migrations:generate

.PHONY: list
list: _doctrine ## Display a list of all available migrations and their status
	$(CONSOLE) doctrine:migrations:list

.PHONY: migrate
migrate: _doctrine ## Execute a migration to the latest available version (in a transaction) | [a=<args>] | a="current+3"
	$(CONSOLE) doctrine:migrations:migrate --no-interaction --all-or-nothing $(a)

.PHONY: migration
migration: _doctrine ## Create (via MakerBundle) a new migration based on database changes (format the generated SQL) | [a=<args>] | a="--profile"
	$(CONSOLE) make:migration --formatted -v $(a)

##

.PHONY: fixtures
fixtures: _doctrine ## Load fixtures (CAUTION! The load command purges the database) | [a=<args>] | a="--append"
	$(CONSOLE) doctrine:fixtures:load -n $(a)

fixtures@test: a="--env=test"
fixtures@test: _doctrine fixtures ## Load fixtures (env=test)

.PHONY: sql
sql: _doctrine ## Execute the given SQL query and output the results | [q=<query>] | q="SELECT * FROM user"
	$(CONSOLE) doctrine:query:sql "$(q)"

update_dump: _doctrine ## Generate and output the SQL needed to synchronize the database schema with the current mapping metadata
	$(CONSOLE) doctrine:schema:update --dump-sql

update_force: _doctrine ## Execute the generated SQL needed to synchronize the database schema with the current mapping metadata
	$(CONSOLE) doctrine:schema:update --force

.PHONY: validate
validate: _doctrine ## Validate the mapping files | [a=<args>] | a="--env=test"
	@printf "\n$(Y)--- Doctrine Schema Validate ---$(S)\n"
	$(CONSOLE) doctrine:schema:validate -v $(a)

##

phpstorm_config: ## Display database connection details for PhpStorm "Data Sources and Drivers" dialog
	@printf "See https://www.jetbrains.com/help/phpstorm/data-sources-and-drivers-dialog.html\n"
ifneq ($(IS_POSTGRESQL),)
	@printf "\n$(Y)--- PostgreSQL ---$(S)\n"
	@printf " $(Y)›$(S) Name           : $(G)$(POSTGRES_DB)@$(POSTGRES_HOST_PUBLIC)$(S)\n"
	@printf " $(Y)›$(S) Host           : $(G)$(POSTGRES_HOST_PUBLIC)$(S)\n"
	@printf " $(Y)›$(S) Port           : $(G)$(POSTGRES_PORT_PUBLIC)$(S)\n"
	@printf " $(Y)›$(S) Authentication : $(G)User & Password$(S)\n"
	@printf " $(Y)›$(S) User           : $(G)$(POSTGRES_USER)$(S)\n"
	@printf " $(Y)›$(S) Password       : $(G)$(POSTGRES_PASSWORD)$(S)\n"
	@printf " $(Y)›$(S) Database       : $(G)$(POSTGRES_DB)$(S)\n"
	@printf " $(Y)›$(S) URL            : $(G)jdbc:postgresql://$(POSTGRES_HOST_PUBLIC):$(POSTGRES_PORT_PUBLIC)/$(POSTGRES_DB)$(S)\n"
endif
ifneq ($(IS_MYSQL),)
	@printf "\n$(Y)--- MySQL/MariaDB ---$(S)\n"
	@printf " $(Y)›$(S) Name           : $(G)$(MARIADB_DATABASE)@$(MARIADB_HOST_PUBLIC)$(S)\n"
	@printf " $(Y)›$(S) Host           : $(G)$(MARIADB_HOST_PUBLIC)$(S)\n"
	@printf " $(Y)›$(S) Port           : $(G)$(MARIADB_PORT_PUBLIC)$(S)\n"
	@printf " $(Y)›$(S) Authentication : $(G)User & Password$(S)\n"
	@printf " $(Y)›$(S) User           : $(G)$(MARIADB_USER)$(S)\n"
	@printf " $(Y)›$(S) Password       : $(G)$(MARIADB_PASSWORD)$(S)\n"
	@printf " $(Y)›$(S) Database       : $(G)$(MARIADB_DATABASE)$(S)\n"
	@printf " $(Y)›$(S) URL            : $(G)jdbc:mariadb://$(MARIADB_HOST_PUBLIC):$(MARIADB_PORT_PUBLIC)/$(MARIADB_DATABASE)$(S)\n"
endif
ifneq ($(IS_SQLITE),)
	@printf "\n$(Y)--- SQLite ---$(S)\n"
	@printf " $(Y)›$(S) File           : $(G)$(SQLITE_DB_FILE)$(S)\n"
	@printf " $(Y)›$(S) URL            : $(G)jdbc:sqlite:$(SQLITE_DB_FILE)$(S)\n"
endif
	@printf "\n"


ifneq ($(or $(ALL), $(IS_POSTGRESQL)),)
include make/doctrine_postgresql.mk
endif

ifneq ($(or $(ALL), $(IS_MYSQL)),)
include make/doctrine_mysql.mk
endif

ifneq ($(or $(ALL), $(IS_SQLITE)),)
include make/doctrine_sqlite.mk
endif
