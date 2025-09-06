# Save your generated Symfony application

[⬅️ README](../README.md)

---

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

## 2. Remove GENERATION commands and variables from `Makefile`

### 2.1. Remove the GENERATION variables

**Delete the entire GENERATION block** and its associated variables:

* `SYMFONY_LTS_VERSION`
* `REPOSITORY`
* `CLONE_DIR`

### 2.2. Remove GENERATION targets

These commands are specific to the one-time project creation process. **Locate and remove them**:

* `generate`
* `generate@lts`
* `generate@webapp`
* `generate@webapp_lts`
* `webapp`
* `clone`
* `clear_all`

## 3. Commit all changes

```shell
git add . && git commit -m "Fresh Symfony application saved and setup commands removed"
```

## 4. Verify the changes (optional)

Restart your containers. The application should start quickly:

```shell
make restart
```

---

[⬅️ README](../README.md)
