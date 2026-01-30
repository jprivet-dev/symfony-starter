# Contributing to Symfony: Connect Your Local Symfony Repository

[⬅️ README](../README.md)

---

This starter provides a powerful toolkit to help you contribute to the Symfony framework itself.
It allows you to **link a local version of the Symfony Monorepo** directly into your Dockerized application.

This means you can :
1.  Develop a fix or a feature in your local **fork** of Symfony.
2.  Test it immediately within a running application.
3.  Run the framework's internal unit tests within the Docker container.

## Prerequisites

### 1. Fork & Clone the Repository

To contribute, you first need to **fork** the official repository to your GitHub account, and then clone your fork.

1.  Go to [github.com/symfony/symfony](https://github.com/symfony/symfony) and click the **Fork** button.
2.  Clone **your fork** locally:

```bash
cd /path/to/your/workspace

# Replace 'YOUR_USERNAME' with your GitHub username
git clone git@github.com:YOUR_USERNAME/symfony.git
```

### 2. Configure the Path

Tell the starter where your local Symfony repository is located.
You can add the `CONTRIB_MONOREPO_LOCAL_PATH` variable to your `.env.local` file.

```bash
# Example: if your folders are side-by-side
# /workspace
#   ├── symfony-starter
#   └── symfony

touch .env.local
echo "CONTRIB_MONOREPO_LOCAL_PATH=../symfony" >> .env.local
```

## The Contribution Workflow

### Step 1: Install Symfony Dependencies

Before linking, your local Symfony repository needs its own vendor directory (for its internal tests and dependencies).

```shell
make contrib_install
```

### Step 2: Link the Repository

This is the magic command. It replaces the `vendor/symfony/*` packages in your application with symbolic links pointing to your local `CONTRIB_MONOREPO_LOCAL_PATH`.

```shell
make contrib_link
```

> **Note:** You can now modify PHP files in your local `../symfony/src/...` folder, and the changes will be immediately reflected in your `symfony-starter` application.

### Step 3: Run Framework Tests

You can run the PHPUnit tests of the Symfony framework directly inside the container (ensuring the correct PHP version and extensions).

```shell
# Run all tests (can be long!)
make contrib_tests

# Run tests for a specific component
make contrib_tests a="src/Symfony/Component/HttpKernel"
```

### Step 4: Revert to Normal

Once you have finished your contribution or testing, you can restore the original vendor packages (installing them back from Packagist).

```shell
make contrib_unlink
```

## Workflow Tips

### Managing Branches & Upstream

Since the starter links your **local folder**, you manage your Git branches as usual on your host machine.

1. **Sync with Upstream:** Ensure your local main branch is up-to-date with the official repository.
2. **Create a Branch:** `git checkout -b fix/my-issue`
3. **Code & Test:** Work on your fix and test it in the starter app.
4. **Push & PR:** Push your branch to your fork and open a Pull Request on the official `symfony/symfony` repository.

### Cleanup

To remove vendors and lock files from the local Symfony monorepo to save space:

```shell
make contrib_clean
```

---

[⬅️ README](../README.md)
