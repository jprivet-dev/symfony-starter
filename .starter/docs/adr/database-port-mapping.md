# Database: port mapping strategy

[⬅️ STARTER](../STARTER.md)

---

## Context and problem statement

When using Docker, the `ports` section in a Compose file maps a container port to a host port. By default, if only the container port is specified, Docker assigns a **random high port** on the host machine.

This causes connection issues when trying to reach the database from the host (e.g., from PhpStorm or any local database client):

```yaml
# Problematic configuration
services:
  database:
    ports:
      - "5432" # Host port is NOT specified — Docker assigns a random port
```

Attempting to connect to `127.0.0.1:5432` from the host results in:

> Connection to 127.0.0.1:5432 refused. Check that the hostname and port are correct and that the postmaster is accepting TCP/IP connections.

## Considered options

### 1. Document the random port behavior

Let Docker assign a random port and document how to find it with `docker compose ps`. This is flexible but adds friction for developers using IDE database tools.

### 2. Hardcode the port mapping in `compose.override.yaml`

Explicitly map the container port to the same port on the host using `HOST:CONTAINER` syntax. This ensures a predictable, stable connection address for local tools.

```yaml
# Correct configuration
services:
  database:
    ports:
      - "5432:5432" # Explicit mapping: Host port 5432 -> Container port 5432
```

### 3. Use `.starter/block/<db>/` files to manage port mapping per database

Provide a dedicated block file for each database engine that includes the correct port mapping. These blocks are injected into `compose.override.yaml` via the `make switch_to_<db>` commands.

## Decision outcome

> [!NOTE]
>
> **Option 3 is chosen:** Use `.starter/block/<db>/` files to manage port mapping per database engine.

This approach ensures that:

* The correct port mapping is applied automatically when switching databases.
* Developers can always connect from their host machine using a predictable address.
* The configuration is centralized and consistent across all database engines.

The `.starter/block/` directory contains one folder per database engine (`postgresql/`, `mariadb/`, `sqlite/`), each with the appropriate `compose.override.yaml` fragment injected by the `make switch_to_<db>` command.

---

[⬅️ STARTER](../STARTER.md)
