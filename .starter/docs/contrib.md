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

Run the framework tests inside the container:

```shell
# Run tests for a specific component
make contrib_tests d=symfony a=src/Symfony/Component/HttpKernel
```

Clean PHPUnit cache if needed:

```shell
make contrib_tests_clean d=symfony
```

### Revert

```shell
make contrib_unlink d=symfony
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

Install the bundle's dependencies and link the local version:

```shell
make contrib_install d=monolog-bundle
make require a="symfony/monolog-bundle:4.x-dev --prefer-source"
```

> **Note:** Composer expects a version following the `[branch-name]-dev` pattern (e.g., if your local branch is `4.x`, use `4.x-dev`).

### Develop & Test

Modify files in `../monolog-bundle/` — changes are immediately reflected in the application.

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
