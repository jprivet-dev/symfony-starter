# Symfony Demo

[⬅️ README](../README.md)

---

## About

How to use [symfony/demo](https://github.com/symfony/demo) files with [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker)?

## Get the files of each projects

```shell
make clone_symfony_demo
make clone_symfony_docker
```

## Activate SQLite

### [Dockerfile](../Dockerfile)

Add following lines:

```dockerfile
RUN apt-get update && apt-get install -y sqlite3 && rm -rf /var/lib/apt/lists/*
RUN install-php-extensions pdo_sqlite
```

### [compose.yaml](../compose.yaml)

In `services.php.environment` use:

```yaml
      DATABASE_URL: ${DATABASE_URL}
```

### [compose.override.yaml](../compose.override.yaml)

In `services.php.volumes` add:

```yaml
      - ./var/data_dev.db:/app/var/data_dev.db:rw
```

## Install dependencies

```shell
make up_detached composer_install assets fixtures images info
```

---

[⬅️ README](../README.md)
