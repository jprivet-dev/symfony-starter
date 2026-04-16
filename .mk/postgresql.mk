## — POSTGRESQL 🛢️ ————————————————————————————————————————————————————————————

.PHONY: psql
psql: ## Execute psql - $ make psql [a=<arguments>] - Example: $ make psql a="-V"
	$(CONTAINER_DATABASE) psql -U $(POSTGRES_USER) $(POSTGRES_DB) $(a)

psql_sh: ## Open a shell on the PostgreSQL container
	$(CONTAINER_DATABASE) psql -U $(POSTGRES_USER) $(POSTGRES_DB)

.PHONY: tables
tables: ## Show all tables
	$(CONTAINER_DATABASE) psql -U $(POSTGRES_USER) $(POSTGRES_DB) -c "\dt"

##

.PHONY: dump
dump: FILE=$(BUILD)/dumps/dump-$(NOW).sql
dump: ## Create a SQL dump
	mkdir -p $(BUILD)/dumps
	$(CONTAINER_DATABASE) pg_dump -U $(POSTGRES_USER) $(POSTGRES_DB) >$(FILE)
	@printf " $(G)✔$(S) Database successfully dumped to $(Y)$(FILE)$(S)\n"

dump_gz: FILE=$(BUILD)/dumps/dump-$(NOW).gz
dump_gz: ## Create a compressed SQL dump (gzip)
	mkdir -p $(BUILD)/dumps
	$(CONTAINER_DATABASE) pg_dump -U $(POSTGRES_USER) $(POSTGRES_DB) | gzip >$(FILE)
	@printf " $(G)✔$(S) Database successfully dumped to $(Y)$(FILE)$(S)\n"

.PHONY: restore
restore: confirm drop create ## Restore a dump (CAUTION! The command purges the database) [y/N] - $ make restore f=<file> - Example: $ make restore f="build/dumps/dump.sql"
	$(if $(f),, $(error "Please specify a file with 'f=...'"))
	$(CONTAINER_DATABASE_NO_TTY) psql -U $(POSTGRES_USER) $(POSTGRES_DB) <$(f)
