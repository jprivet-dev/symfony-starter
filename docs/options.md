# Makefile: use Docker build options

⬅️ [README](../README.md)

You can use the same variables from https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#docker-build-options with the `Makefile`:

## Method 1

```shell
SYMFONY_VERSION=6.4.* make generate
```

## Method 2

```dotenv
# .env.local
SYMFONY_VERSION=6.4.*
```

```shell
make generate
```
