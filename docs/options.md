# Makefile: use Docker build options

⬅️ [README](../README.md)

This document explains how to pass specific **Docker build options**, such as the Symfony version or PHP extensions, to your project using the `Makefile`. These options are directly sourced from the `dunglas/symfony-docker` configuration.

You can use the same variables from https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#docker-build-options with the `Makefile`. For example, you can set `SYMFONY_VERSION`, `XDEBUG_MODE`, `SERVER_NAME`, and other variables.

## Method 1 - Directly in the command line

This method allows you to set variables directly when running a `make` command.

```shell
# Example for a specific PHP version: PHP_VERSION=8.3 make build
SYMFONY_VERSION=6.4.* make generate
````

## Method 2 - Using `.env.local`

For more permanent settings, you can define these variables in your local environment file (`.env.local`).

```dotenv
# .env.local

SYMFONY_VERSION=6.4.*

# Example for custom ports:
# HTTP_PORT=8000
# HTTPS_PORT=4443
```

Then, simply run your `make` command:

```shell
make generate
```