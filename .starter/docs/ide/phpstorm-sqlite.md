# PhpStorm - Connect it to the SQLite database

[⬅️ STARTER](../STARTER.md)

---

## About

**SQLite** is a lightweight, serverless, self-contained relational database engine. Unlike PostgreSQL or MariaDB, SQLite does not require a separate server process — the database is stored as a single file on disk. It is ideal for development, testing, and lightweight applications.

## Switch to SQLite

To switch your stack from PostgreSQL to SQLite, run:

```shell
make require_orm # only if necessay
make switch_to_sqlite
```

## Get connection details

Run the following command to display the connection details for your IDE:

```shell
make phpstorm_config
```

## Connect PhpStorm

1. Open the **Database** tool window (`View > Tool Windows > Database`).
2. Click the `+` icon in the toolbar, navigate to **Data Source**, and select **SQLite**.
3. In the right pane, use the following settings under the **General** tab:
  * **File**: path to your SQLite database file (see `make phpstorm_config` output)
4. Click **Test Connection** to confirm the setup. You should see a **Succeeded** message.
5. Click `OK` or `Apply` to validate the connection.

## Links

* https://www.sqlite.org/
* https://www.jetbrains.com/help/phpstorm/sqlite.html

---

[⬅️ STARTER](../STARTER.md)
