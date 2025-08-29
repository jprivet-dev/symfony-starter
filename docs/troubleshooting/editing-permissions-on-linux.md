# Editing permissions on Linux

⬅️ [Troubleshooting](../troubleshooting.md)

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

---

⬅️ [Troubleshooting](../troubleshooting.md)
