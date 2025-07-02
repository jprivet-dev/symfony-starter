# Save the generated Symfony application

⬅️ [README](../README.md)

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
````

## 2 - Commit all changes

Once the installation block is removed, your Symfony application is now the core of your project. It's time to **commit these changes** to your Git repository.

```shell
git add . && git commit -m "Fresh Symfony application saved"
```

## 3 - Verify the changes (optional)

To ensure everything is correctly set up, you can restart your containers. The application should start quickly without attempting to re-create the project.

```shell
make stop
make start
```