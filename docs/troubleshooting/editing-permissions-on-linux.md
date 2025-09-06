# Editing permissions on Linux

[⬅️ Troubleshooting](../troubleshooting.md)

---

## Problem

When working on Linux, you might encounter permission errors after the initial project setup, preventing you from editing certain files. This usually happens because files created by the Docker container are owned by the `root` user (or a different user ID) within the container, not your host user.

## Solution

To fix this, you can run the following command in your project directory:

```shell
make permissions
```

This command will change the ownership of the project files to your current host user, allowing you to edit them freely.

> See https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md for more details on `dunglas/symfony-docker` troubleshooting.

## Alternative solution (when containers are stopped)

If the containers are stopped and their configuration has been removed, you can also fix this by using a `sudo chown` command to reset the permissions:

```shell
sudo chown -R $(id -u):$(id -g) .
```

This command recursively changes the ownership of all files and directories in your project to your current user and group. It's a quick solution but should be used with caution.

---

[⬅️ Troubleshooting](../troubleshooting.md)
