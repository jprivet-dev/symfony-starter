# Contributing to Symfony: Connect your local repository

[⬅️ README](../README.md)

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
make contrib_volume f=symfony
make build up_detached
```

Install Symfony's own dependencies:

```shell
make contrib_install f=symfony
```

Link the monorepo into your application's vendors:

```shell
make contrib_link f=symfony
```

### Develop & test

Modify files in `../symfony/src/` — changes are immediately reflected in the application.

Run the framework tests inside the container:

```shell
# Run tests for a specific component
make contrib_tests f=symfony a=src/Symfony/Component/HttpKernel
```

Clean PHPUnit cache if needed:

```shell
make contrib_tests_clean f=symfony
```

### Revert

```shell
make contrib_unlink f=symfony
```

### Submit your contribution

Manage your Git branches as usual on your host machine:

```shell
cd ../symfony
git checkout -b fix/my-issue
# ... commit your changes ...
git push origin fix/my-issue
```

Then open a Pull Request on [github.com/symfony/symfony](https://github.com/symfony/symfony).

> See the [official contribution guide](https://symfony.com/doc/current/contributing/code/pull_requests.html) for more details.

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

Add the Docker volume and rebuild:

```shell
make contrib_volume f=monolog-bundle
make build up_detached
```

Install the bundle's own dependencies:

```shell
make contrib_install f=monolog-bundle
```

Tell Composer to use your local fork instead of the Packagist version:

```shell
$(COMPOSER) config repositories.monolog-bundle '{"type": "path", "url": "/monolog-bundle"}'
$(COMPOSER) update symfony/monolog-bundle
```

### Develop & test

Modify files in `../monolog-bundle/` — changes are immediately reflected in the application.

Run the bundle tests inside the container:

```shell
make contrib_tests f=monolog-bundle
```

Clean PHPUnit cache if needed:

```shell
make contrib_tests_clean f=monolog-bundle
```

### Revert

Remove the local Composer repository and restore the original package:

```shell
$(COMPOSER) config --unset repositories.monolog-bundle
$(COMPOSER) update symfony/monolog-bundle
```

### Submit your contribution

Manage your Git branches as usual on your host machine:

```shell
cd ../monolog-bundle
git checkout -b fix/my-issue
# ... commit your changes ...
git push origin fix/my-issue
```

Then open a Pull Request on [github.com/symfony/monolog-bundle](https://github.com/symfony/monolog-bundle).

---

## Cleanup

To remove vendors and lock files from a local repository to save space:

```shell
make contrib_clean f=symfony
make contrib_clean f=monolog-bundle
```

---

[⬅️ README](../README.md)
