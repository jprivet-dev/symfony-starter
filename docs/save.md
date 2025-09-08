# Save your generated Symfony application

[⬅️ README](../README.md)

---

## About

After successfully generating your Symfony application for the first time, it's crucial to "**save**" its state. This prevents regeneration on subsequent container starts and officially integrates the application into your codebase.

## 1. Remove the installation block from `frankenphp/docker-entrypoint.sh`

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

## 2. Remove `GENERATION` blocks from `Makefile`

To find the items to remove in the `Makefile` file, search for the word `GENERATION`.

* You will find variables that are only used for the initial setup: `SYMFONY_LTS_VERSION`, `REPOSITORY`, etc.
* You will find targets that are only used for the initial setup: `minimalist`, `webapp`, `api`, etc.

## 3. Commit all changes

```shell
git add . && git commit -m "Fresh Symfony application saved (setup variables and targets removed)"
```

## 4. Verify the changes (optional)

Restart your containers. The application should start quickly:

```shell
make restart
```

---

[⬅️ README](../README.md)
