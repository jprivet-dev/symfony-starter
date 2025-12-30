# PhpStorm - Connect it to the running PostgreSQL container

[⬅️ README](../README.md)

---

## About

**PostgreSQL** is an **Object-Relational Database Management System (ORDBMS)**, meaning it combines traditional relational database features (like SQL, ACID properties) with object-oriented concepts (such as inheritance and function overloading). It is known for its strong standards compliance, reliability, and data integrity.

## Avoid "Connection to 127.0.0.1:5432 refused"

When using Docker, the `ports` section maps a container port to a host port. Misconfiguring this often leads to a connection refused error, especially when trying to connect from your host machine (like PhpStorm).

### Problematic configuration (Connection Refused)

With the following configuration, Docker exposes the container's internal port `5432` to a **random, high port** on your host machine. When you try to connect to `127.0.0.1:5432`, your host system finds nothing listening there.

```yaml
# compose.override.yaml
services:
  ###> doctrine/doctrine-bundle ###
  database:
    ports:
      - "5432" # Host port is NOT specified, causing the connection refusal
  ###< doctrine/doctrine-bundle ###
```

This results in the error:

> Connection to 127.0.0.1:5432 refused. Check that the hostname and port are correct and that the postmaster is accepting TCP/IP connections.

### Correct configuration (Port Mapping)

To explicitly map the container's internal port (`5432`) to the same port on your host machine (`5432`), you must specify the mapping using the syntax `HOST:CONTAINER`. This allows local tools (like PhpStorm) to find the database at the expected address.

```yaml
# compose.override.yaml
services:
  ###> doctrine/doctrine-bundle ###
  database:
    ports:
      - "5432:5432" # Correct mapping: Host port 5432 -> Container port 5432
  ###< doctrine/doctrine-bundle ###
```

You can apply the above changes with the following patch:

* With Git: `git apply .patch/postgresql-port-mapping.patch`
* With PhpStorm: **Right-click** on the file and select **Apply Patch...**

## Connect PhpStorm

1. Open the **Database** tool window (`View > Tool Windows > Database`).
2. Click the `+` icon in the toolbar, navigate to **Data Source**, and select **PostgreSQL**.
3. In the right pane, use the following settings under the **General** tab:
   * **Host**: `127.0.0.1`
   * **Port**: `5432`
   * **User**: `app`
   * **Password**: `!ChangeMe!`
   * **Database**: `app`
4. Click **Test Connection** to confirm the setup. You should see a **Succeeded** message.
5. Click `OK` or `Apply` to validate the connection.

## Links

* https://www.postgresql.org/
* https://aws.amazon.com/fr/rds/postgresql/what-is-postgresql
* https://www.jetbrains.com/help/phpstorm/postgresql.html

---

[⬅️ README](../README.md)
