# Save the generated Symfony application

⬅️ [README](../README.md)

## 1 - Remove code block from [frankenphp/docker-entrypoint.sh](app/frankenphp/docker-entrypoint.sh)

```shell
	# Install the project the first time PHP is started
	# After the installation, the following block can be deleted
	if [ ! -f composer.json ]; then
		rm -Rf tmp/
		composer create-project "symfony/skeleton $SYMFONY_VERSION" tmp --stability="$STABILITY" --prefer-dist --no-progress --no-interaction --no-install
		# ...
	fi
```

## 2 - Commit all

```shell
git add . && git commit -m "Fresh Symfony application"
```