## — MYSQL 🛢️ —————————————————————————————————————————————————————————————————

.PHONY: mysql
mysql: ## Execute mysql | [a=<args>] | a="-V"
	$(CONTAINER_DATABASE) mysql -u $(MARIADB_USER) -p$(MARIADB_PASSWORD) $(MARIADB_DATABASE) $(a)

mysql_sh: ## Open a shell on the MySQL/MariaDB container
	$(CONTAINER_DATABASE) mysql -u $(MARIADB_USER) -p$(MARIADB_PASSWORD) $(MARIADB_DATABASE)

.PHONY: table
table: ## Show the content of a table | n=<name> | n=user
	$(if $(n),, $(error "Please specify a table name with 'n=...'"))
	$(CONTAINER_DATABASE) mysql -u $(MARIADB_USER) -p$(MARIADB_PASSWORD) $(MARIADB_DATABASE) -e "SELECT * FROM $(n);"

.PHONY: tables
tables: ## Show all tables
	$(CONTAINER_DATABASE) mysql -u $(MARIADB_USER) -p$(MARIADB_PASSWORD) $(MARIADB_DATABASE) -e "SHOW TABLES;"

##

.PHONY: dump
dump: FILE=$(BUILD)/dumps/dump-$(NOW).sql
dump: ## Create a SQL dump
	mkdir -p $(BUILD)/dumps
	$(CONTAINER_DATABASE) mysqldump -u $(MARIADB_USER) -p$(MARIADB_PASSWORD) $(MARIADB_DATABASE) >$(FILE)
	@printf " $(G)✔$(S) Database successfully dumped to $(Y)$(FILE)$(S)\n"

dump_gz: FILE=$(BUILD)/dumps/dump-$(NOW).gz
dump_gz: ## Create a compressed SQL dump (gzip)
	mkdir -p $(BUILD)/dumps
	$(CONTAINER_DATABASE) mysqldump -u $(MARIADB_USER) -p$(MARIADB_PASSWORD) $(MARIADB_DATABASE) | gzip >$(FILE)
	@printf " $(G)✔$(S) Database successfully dumped to $(Y)$(FILE)$(S)\n"

.PHONY: restore
restore: confirm drop create ## Restore a dump (CAUTION! The command purges the database) [y/N] | f=<file> | f="build/dumps/dump.sql"
	$(if $(f),, $(error "Please specify a file with 'f=...'"))
	$(CONTAINER_DATABASE_NO_TTY) mysql -u $(MARIADB_USER) -p$(MARIADB_PASSWORD) $(MARIADB_DATABASE) <$(f)
	@printf " $(G)✔$(S) Database successfully restored from $(Y)$(f)$(S)\n"
