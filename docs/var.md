# Accessing the `var/` directory

⬅️ [README](../README.md)

---

The `var/` directory is essential for debugging as it contains cache and log files. By default, this folder is located inside the **Docker** container, making it difficult to access directly from your host machine (IDE, text editor, etc.).

To get direct access to this directory, you need to add a "bind mount" for the `var/` directory and its `log` subdirectory in the `compose.override.yaml` file. This ensures proper two-way synchronization between your host and the container.

## Activating the bind mount

Add `./var:/app/var` and `./var/log:/app/var/log` to the `volumes` section to the `php` service as shown below:

  ```yaml
  # compose.override.yaml
  services:
    php:
      volumes:
        - ...
        - ./var:/app/var
        - ./var/log:/app/var/log
  ```

## How it works

The `composer.yaml` file has a line that creates an anonymous volume for `var/`, which can cause conflicts with the host machine. By explicitly adding these bind mounts, you are instructing **Docker** to create a direct and persistent link to the folders on your host. This workaround ensures that you can reliably see all your cache and log files, regardless of the container's internal configuration.

---

⬅️ [README](../README.md)
