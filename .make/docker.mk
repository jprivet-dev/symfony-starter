## — DOCKER 🐳 ————————————————————————————————————————————————————————————————

.PHONY: build
build: ## Build or rebuild Docker services using cache | [a=<args>] | a=--no-cache
	$(COMPOSE) build $(a)

.PHONY: build_force
build_force: a=--no-cache
build_force: build ## Build or rebuild Docker services without cache (force fresh install)

##

.PHONY: up
up: ## Start the containers | [a=<args>] | a=-d
	$(UP_ENV) $(COMPOSE) up --remove-orphans $(a)
	$(MAKE) runtime
	$(MAKE) permissions
	$(MAKE) safe

up_detached: a=-d
up_detached: up ## Start the containers (wait for services to be running|healthy - detached mode)

##

.PHONY: down
down: ## Stop the containers
	-$(COMPOSE) down

.PHONY: kill
kill: ## Remove containers and networks (keep database data)
	$(COMPOSE) down --remove-orphans

.PHONY: kill_all
kill_all: confirm ## Remove containers, networks AND VOLUMES (database destroyed)
	$(COMPOSE) down --remove-orphans --volumes

deep_clean: confirm ## [Danger] Remove containers, volumes, networks and images, including orphans (triggers: webapp-pack, database, branch switch) [y/N]
	@printf "🔥 $(Y)Cleaning Docker environment for $(PROJECT_NAME) (if file exists)...$(S)\n"
	-$(COMPOSE) down --volumes --rmi local --remove-orphans 2>/dev/null || true

	@printf "🔥 $(Y)Force clean everything else using Docker labels (works even if compose.yaml is missing)...$(S)\n"
	-docker ps -a --filter "label=com.docker.compose.project=$(PROJECT_NAME)" -q | xargs -r docker rm -f
	-docker network ls --filter "label=com.docker.compose.project=$(PROJECT_NAME)" -q | xargs -r docker network rm
	-docker volume ls --filter "label=com.docker.compose.project=$(PROJECT_NAME)" -q | xargs -r docker volume rm

	@printf "🔥 $(Y)Cleaning project images...$(S)\n"
	-docker images --filter "reference=$(IMAGES_PREFIX)*" -q | xargs -r docker rmi -f

##

.PHONY: canonical
canonical: ## Parse, resolve, and render compose file in canonical format
	$(UP_ENV) $(COMPOSE) config

.PHONY: images
images: ## List images used by the current containers
	@printf "\n$(Y)--- Images used by the current containers ---$(S)\n"
	$(COMPOSE) images | grep -E "REPOSITORY|$(IMAGES_PREFIX)"

.PHONY: logs
logs: ## View logs (follow mode)
	$(COMPOSE) logs -f
