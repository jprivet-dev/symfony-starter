# PhpStorm - Connect it to the running PostgreSQL container

[⬅️ STARTER](../STARTER.md)

---

## About

**PostgreSQL** is an **Object-Relational Database Management System (ORDBMS)**, meaning it combines traditional relational database features (like SQL, ACID properties) with object-oriented concepts (such as inheritance and function overloading). It is known for its strong standards compliance, reliability, and data integrity.

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
* https://www.jetbrains.com/help/phpstorm/postgresql.html

---

[⬅️ STARTER](../STARTER.md)
