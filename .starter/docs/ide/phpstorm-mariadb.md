# PhpStorm - Connect it to the running MariaDB container

[⬅️ STARTER](../STARTER.md)

---

## About

**MariaDB** is an open-source relational database management system, originally forked from MySQL. It is fully compatible with MySQL and is known for its performance, reliability, and rich feature set. It uses the same SQL syntax and client libraries as MySQL.

## Switch to MariaDB

To switch your stack from PostgreSQL to MariaDB, run:

```shell
make require_orm # only if necessay
make switch_to_mariadb
```

## Get connection details

Run the following command to display the connection details for your IDE:

```shell
make phpstorm_config
```

> [!NOTE]
>
> See [Database: port mapping strategy](adr/database-port-mapping.md) to understand why the port mapping is configured the way it is.

## Connect PhpStorm

1. Open the **Database** tool window (`View > Tool Windows > Database`).
2. Click the `+` icon in the toolbar, navigate to **Data Source**, and select **MariaDB**.
3. In the right pane, use the following settings under the **General** tab:
  * **Host**: `127.0.0.1`
  * **Port**: `3306`
  * **User**: `app`
  * **Password**: `!ChangeMe!`
  * **Database**: `app`
4. Click **Test Connection** to confirm the setup. You should see a **Succeeded** message.
5. Click `OK` or `Apply` to validate the connection.

## Links

* https://mariadb.org/
* https://www.jetbrains.com/help/phpstorm/mariadb.html

---

[⬅️ STARTER](../STARTER.md)
