# Saving Your Generated Symfony Application

⬅️ [README](https://www.google.com/search?q=../README.md)

After successfully generating your Symfony application for the first time, it's crucial to "**save**" its state. This prevents it from being regenerated on subsequent container starts and officially makes it part of your project's codebase. This document guides you through the necessary steps.

## 1 - Remove the installation block from `frankenphp/docker-entrypoint.sh`

The `frankenphp/docker-entrypoint.sh` script contains a block of code responsible for creating the initial Symfony project if `composer.json` is not found. Once your application is generated, this block is **no longer needed and must be removed**. Removing it will prevent unnecessary re-installations, potential conflicts, and speed up container startup times.

Locate and **delete the following lines** from `frankenphp/docker-entrypoint.sh`:

```shell
	# Install the project the first time PHP is started
	# After the installation, the following block can be deleted
	if [ ! -f composer.json ]; then
		rm -Rf tmp/
		composer create-project "symfony/skeleton $SYMFONY_VERSION" tmp --stability="$STABILITY" --prefer-dist --no-progress --no-interaction --no-install
		# ... (ensure all lines of this conditional block are removed, including the 'fi')
	fi
```

## 2 - Remove initial setup commands and variables from `Makefile`

Your `Makefile` includes specific targets and variables designed solely for the *initial generation* of your Symfony application. Once the application is generated and saved, these elements are **no longer required** and can be removed to streamline your `Makefile`. This ensures your project is self-contained and ready for continuous development without carrying around setup-specific logic.

**Here's what you can safely remove:**

### 2.1 - Remove the `INSTALLATION` block

Delete the entire **`INSTALLATION`** block and its associated variables located at the top of your `Makefile`. This block defines where `dunglas/symfony-docker` is cloned from and where it's temporarily stored during the initial setup.

```makefile
#
# INSTALLATION
# These variables and commands are for initial setup and can be removed after saving the project.
#
REPOSITORY = git@github.com:dunglas/symfony-docker.git
CLONE_DIR  = clone
```

### 2.2 - Remove the `generate` and `clone` targets

Locate and remove both the **`generate`** and **`clone`** targets from the `Makefile`. These commands are specific to the one-time project creation process and are no longer needed once your application is set up.

```makefile
##
# These targets are for initial setup and can be removed after saving the project.
.PHONY: generate
generate: clone build up_detached permissions info ## Generate a fresh Symfony application with Docker configuration

.PHONY: clone
clone: ## Clone 'dunglas/symfony-docker' configuration files
	# ... (all lines within this target)
```

*Note: Make sure to remove all lines belonging to both `generate` and `clone` targets.*

## 3 - Commit all changes

Once the installation block is removed from `docker-entrypoint.sh` and the unnecessary elements are cleaned from your `Makefile`, your Symfony application is now the core of your project. It's time to **commit these changes** to your Git repository.

```shell
git add . && git commit -m "Fresh Symfony application saved and setup commands removed"
```

## 4 - Verify the changes (optional)

To ensure everything is correctly set up, you can restart your containers. The application should start quickly without attempting to re-create the project.

```shell
make stop
make start
```