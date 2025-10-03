# Git "dubious ownership" Error in Docker Container

[⬅️ Troubleshooting](../troubleshooting.md)

---

## Problem

You might encounter this error when running Git or Composer commands inside your Docker PHP container:

```
fatal: detected dubious ownership in repository at '/app'
To add an exception for this directory, call:

        git config --global --add safe.directory /app
```

Git detects that the `/app` directory inside the container is owned by a different user (e.g., `root`) than the one executing the Git command, which is a security measure.

## Solution

You need to tell Git within the container that `/app` is a safe directory:

```bash
make git_safe_dir
```

This will execute the necessary `git config` command inside your `php` Docker service. After this, you should be able to run Git and Composer commands (like `composer require`) without this error.

---

[⬅️ Troubleshooting](../troubleshooting.md)
