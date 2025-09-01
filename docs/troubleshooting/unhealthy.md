# Error "container is unhealthy" after `docker compose up`

⬅️ [Troubleshooting](../troubleshooting.md)

---

## Problem

You might encounter this error after starting the containers:

```
container symfony-starter-php-1 is unhealthy
```

This issue occurs when the `php` container fails to connect to the database quickly enough. The container's `HEALTHCHECK`, which verifies if the application is ready to respond, fails. The container is marked as **unhealthy** even before the database is fully operational.

The cause is often a conflict between the database waiting logic in the `docker-entrypoint.sh` script and the `HEALTHCHECK` from the Docker image.

## Solution

To resolve this issue permanently, you must ensure you are starting from a clean environment to avoid conflicts between different container image versions.

To do this, follow these steps.

### 1. Stop and remove all containers and volumes

This command stops and removes all containers and any unnamed volumes. This is the most crucial step as it clears your project's state:

```shell
docker compose down --volumes --rmi all
```

### 2. Clean up all unused images

This command removes all images that are not attached to any container:

```shell
docker image prune
```

### 3. Start the project with a fresh build

This command rebuilds the image and restarts the project without using Docker's build cache, ensuring that your most recent changes are taken into account:

```shell
docker compose up --build --no-cache
```

Following these steps guarantees that you are always starting from a **clean and up-to-date** environment.

---

⬅️ [Troubleshooting](../troubleshooting.md)
