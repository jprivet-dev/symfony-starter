# Contributing

[⬅️ README](../README.md)

---

## Contribute to symfony/symfony

### Prerequisites

1. Fork [github.com/symfony/symfony](https://github.com/symfony/symfony) on GitHub
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

[⬅️ README](../README.md)
