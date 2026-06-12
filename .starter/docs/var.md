# Compose - Accessing the `var/` directory

[⬅️ STARTER](STARTER.md)

---

## About

The `var/` directory is essential for debugging as it contains cache and log files. By default, this directory is managed by an anonymous Docker volume (defined in `compose.override.yaml`), making it inaccessible from your host machine (IDE, text editor, etc.):

```yaml
# compose.override.yaml
# Keep var/ off the bind-mount for faster I/O on Mac/Windows; comment to inspect from the host.
- /app/var
```

To get direct access to this directory, you need to replace this anonymous volume with explicit bind mounts.

## Activating the bind mount

Add `./var:/app/var` and `./var/log:/app/var/log` to the `volumes` section of the `php` service:

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

- `./var:/app/var` replaces the anonymous volume and makes the entire `var/` directory visible from the host.
- `./var/log:/app/var/log` is required because a minimal Symfony project does not create `var/log/` at startup. Without this explicit mount, Docker does not create the directory inside the container, making logs inaccessible even after the first HTTP request.

---

[⬅️ STARTER](STARTER.md)
