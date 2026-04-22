# Contributing to Symfony: Connect your local repository

[⬅️ README](README.md)

---

This starter provides a powerful toolkit to help you contribute to the Symfony framework or any Symfony bundle. It allows you to mount a local repository directly into your Dockerized application and test your changes immediately.

## Contribute to symfony/symfony

### Prerequisites

1. Fork [github.com/symfony/symfony](https://github.com/symfony/symfony) on GitHub.
2. Clone your fork side-by-side with the starter:

```shell
git clone git@github.com:YOUR_USERNAME/symfony.git ../symfony
```

### Setup

Add the Docker volume and rebuild:

```shell
make contrib_volume d=symfony
git commit -am "Add a Docker volume for the symfony directory"

make build
make up_detached
```

Link the monorepo into your application's vendors:

```shell
make contrib_link d=symfony
```

### Develop & Test

Modify files in `../symfony/src/` — changes are immediately reflected in the application.

Before running tests, ensure all dependencies are installed within the monorepo:

```bash
make contrib_install d=symfony
```

Run the framework tests inside the container using absolute paths from the container's root:

```bash
# Run tests for a specific component
make contrib_tests d=symfony a="/symfony/src/Symfony/Component/HttpKernel"

# Run tests for all Bridge components
make contrib_tests d=symfony a="/symfony/src/Symfony/Bridge"

# Run tests for all Bundle components
make contrib_tests d=symfony a="/symfony/src/Symfony/Bundle"

# Run tests for all Components
make contrib_tests d=symfony a="/symfony/src/Symfony/Component"
```

> **Pro-tip:** When running large test suites, you can exclude specific groups that require additional infrastructure (like Redis) by appending the argument:
> `make contrib_tests d=symfony a="/symfony/src/Symfony/Bundle --exclude-group=redis"`

Clean PHPUnit cache and temporary files if needed (recommended before running large suites):

```bash
make contrib_tests_clean d=symfony
```

---

## Contribute to a Symfony bundle

This section uses [symfony/monolog-bundle](https://github.com/symfony/monolog-bundle) as an example. The same workflow applies to any Symfony bundle.

### Prerequisites

1. Fork [github.com/symfony/monolog-bundle](https://github.com/symfony/monolog-bundle) on GitHub.
2. Clone your fork side-by-side with the starter:

```shell
git clone git@github.com:YOUR_USERNAME/monolog-bundle.git ../monolog-bundle
```

### Setup

Add the Docker volume and register the path repository:

```shell
make contrib_volume d=monolog-bundle
make contrib_repo d=monolog-bundle
git commit -am "Add a Docker volume and repo for the monolog-bundle"

make build
make up_detached
```

Link the local version:

```shell
make require a="symfony/monolog-bundle:4.x-dev --prefer-source"
git add .
git commit -m "Install symfony/monolog-bundle:4.x-dev"
```

> **Note:** Composer expects a version following the `[branch-name]-dev` pattern (e.g., if your local branch is `4.x`, use `4.x-dev`).

### Develop & Test

Modify files in `../monolog-bundle/` — changes are immediately reflected in the application.

Before running tests, ensure all dependencies are installed within the repo:

```bash
make contrib_install d=monolog-bundle
```

Run the bundle tests inside the container:

```shell
make contrib_tests d=monolog-bundle
```

Clean PHPUnit cache if needed:

```shell
make contrib_tests_clean d=monolog-bundle
```

### Revert

Remove the local Composer repository and restore the original package:

```shell
make contrib_remove_repo d=monolog-bundle
make update a="symfony/monolog-bundle"
```

---

## Submit your contribution

Manage your Git branches as usual on your host machine and open a Pull Request on the official repository.

```shell
# For symfony/symfony
cd ../symfony
git checkout -b fix/my-issue
# ... commit your changes ...
git push origin fix/my-issue
```

```shell
# For symfony/monolog-bundle
cd ../monolog-bundle
git checkout -b fix/my-issue
# ... commit your changes ...
git push origin fix/my-issue
```

> See the [official contribution guide](https://symfony.com/doc/current/contributing/code/pull_requests.html) for more details.

---

## Cleanup

To remove vendors and lock files from a local repository to save space:

```shell
make contrib_clean d=symfony
make contrib_clean d=monolog-bundle
```

---

[⬅️ README](README.md)
