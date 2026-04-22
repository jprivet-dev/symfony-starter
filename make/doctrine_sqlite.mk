## — SQLITE 🛢️ ————————————————————————————————————————————————————————————————

.PHONY: sqlite
sqlite: ## Execute sqlite3 | [a=<args>] | a="-version"
	$(CONTAINER_PHP) sqlite3 $(SQLITE_DB_FILE) $(a)

sqlite_sh: ## Open a SQLite shell on the PHP container
	$(CONTAINER_PHP) sqlite3 $(SQLITE_DB_FILE)

.PHONY: table
table: ## Show the content of a table | n=<name> | n=user
	$(if $(n),, $(error "Please specify a table name with 'n=...'"))
	$(CONTAINER_PHP) sqlite3 $(SQLITE_DB_FILE) "SELECT * FROM $(n);"

.PHONY: tables
tables: ## Show all tables
	$(CONTAINER_PHP) sqlite3 $(SQLITE_DB_FILE) ".tables"

##

.PHONY: dump
dump: FILE=$(BUILD)/dumps/dump-$(NOW).sql
dump: ## Create a SQL dump
	mkdir -p $(BUILD)/dumps
	$(CONTAINER_PHP) sqlite3 $(SQLITE_DB_FILE) ".dump" >$(FILE)
	@printf " $(G)✔$(S) Database successfully dumped to $(Y)$(FILE)$(S)\n"

dump_gz: FILE=$(BUILD)/dumps/dump-$(NOW).gz
dump_gz: ## Create a compressed SQL dump (gzip)
	mkdir -p $(BUILD)/dumps
	$(CONTAINER_PHP) sqlite3 $(SQLITE_DB_FILE) ".dump" | gzip >$(FILE)
	@printf " $(G)✔$(S) Database successfully dumped to $(Y)$(FILE)$(S)\n"

.PHONY: restore
restore: confirm ## Restore a dump (CAUTION! The command purges the database) [y/N] | f=<file> | f="build/dumps/dump.sql"
	$(if $(f),, $(error "Please specify a file with 'f=...'"))
	rm -f $(SQLITE_DB_FILE)
	$(CONTAINER_PHP_NO_TTY) sqlite3 $(SQLITE_DB_FILE) < $(f)
	@printf " $(G)✔$(S) Database successfully restored from $(Y)$(f)$(S)\n"
