# Contributing to Symfony Core

[⬅️ README](../README.md)

---

This starter provides a powerful toolkit to help you contribute to the Symfony framework itself.
It allows you to **link a local version of the Symfony Monorepo** directly into your Dockerized application.

This means you can :
1.  Develop a fix or a feature in your local `symfony/symfony` clone.
2.  Test it immediately within a running application.
3.  Run the framework's internal unit tests within the Docker container.

## 🛠️ Prerequisites

### 1. Clone the Symfony Repository

You need to have the Symfony Monorepo cloned on your machine.

```bash
cd /path/to/your/workspace
git clone [https://github.com/symfony/symfony.git](https://github.com/symfony/symfony.git)
```

### 2. Configure the Path

Tell the starter where your local Symfony repository is located.
You can add the `SYMFONY_REPO_PATH` variable to your `.env` file (or `Makefile`).

```bash
# Example: if your folders are side-by-side
# /workspace
#   ├── symfony-starter
#   └── symfony

echo "SYMFONY_REPO_PATH=../symfony" >> .env
```

## 🔄 The Contribution Workflow

### Step 1: Install Symfony Dependencies

Before linking, your local Symfony repository needs its own vendor directory (for its internal tests and dependencies).

```shell
make contrib_install

```

### Step 2: Link the Repository

This is the magic command. It replaces the `vendor/symfony/*` packages in your application with symbolic links pointing to your local `SYMFONY_REPO_PATH`.

```shell
make contrib_link
```

> **Note:** You can now modify PHP files in your local `../symfony/src/...` folder, and the changes will be immediately reflected in your `symfony-starter` application.

### Step 3: Run Framework Tests

You can run the PHPUnit tests of the Symfony framework directly inside the container (ensuring the correct PHP version and extensions).

```shell
# Run all tests (can be long!)
make contrib_tests

# Run tests for a specific component (Recommended)
make contrib_tests a="src/Symfony/Component/HttpKernel"
```

### Step 4: Revert to Normal

Once you have finished your contribution or testing, you can restore the original vendor packages (installing them back from Packagist).

```shell
make contrib_unlink
```

## 💡 Workflow Tips

### Managing Branches

Since the starter links your **local folder**, you manage your Git branches as usual on your host machine.

1. Go to your Symfony clone: `cd ../symfony`
2. Create your branch: `git checkout -b my-fix`
3. Go back to your app: `cd ../symfony-starter`
4. Test the changes!

### Cleanup

To remove vendors and lock files from the local Symfony monorepo to save space:

```shell
make contrib_clean
```

---

[⬅️ README](../README.md)
