# "Git is not recognizing my project as a repository" after `make generate`

⬅️ [Troubleshooting](../troubleshooting.md)

---

## Problem

On Linux systems, you might encounter an issue where Git no longer recognizes your project as a repository, or you see permission errors after running `make generate`. This usually happens because files created inside the Docker containers (like your Symfony application files installed by Composer) are owned by a different user within the container (often `root`). When these files are written to your local filesystem via Docker volumes, they retain these permissions, which can prevent your host user (and thus Git) from properly accessing or modifying them.

## Solution

If you face this problem, simply run:

```shell
make permissions
```

This command automatically adjusts the file ownership to match your host user, resolving any Git-related permission issues. Note that this command is conditional and only executes the ownership change on Linux environments where it's typically needed.

---

⬅️ [Troubleshooting](../troubleshooting.md)
