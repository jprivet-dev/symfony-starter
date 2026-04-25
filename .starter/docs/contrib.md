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
make monorepo_volume
git commit -am "Add a Docker volume for the Symfony monorepo"

make build
make up_detached
```

Link the monorepo into your application's vendors:

```shell
make monorepo_link
```

### Develop & Test

Modify files in `../symfony/src/` — changes are immediately reflected in the application.

Before running tests, ensure all dependencies are installed within the monorepo:

```bash
make monorepo_install
```

Run the framework tests inside the container using absolute paths from the container's root:

```bash
# Run tests for a specific component
make monorepo_tests a="/symfony/src/Symfony/Component/HttpKernel"
```

**Pro-tip:** When running large test suites, you can exclude specific groups that require additional infrastructure (like Redis) by appending the argument:

```bash
make monorepo_tests a="/symfony/src/Symfony/Bundle --exclude-group=redis"
```

Clean PHPUnit cache and temporary files if needed (recommended before running large suites):

```bash
make monorepo_tests_clean
```

### Personal shortcuts (local customization)

If you are working frequently on specific components, you can create your own shortcuts. The starter includes a mechanism to load local Makefile rules that are not committed to the repository.

1. Create your local Makefile:
   ```bash
   cp make/local.mk.dist make/local.mk
   ```

2. Add your custom commands to `make/local.mk`. These will automatically appear in `make help`. Here are some useful examples you can use:

```makefile
monorepo_tests_bridge: ## Run tests for all Bridge components
	make monorepo_tests a="/symfony/src/Symfony/Bridge"

monorepo_tests_bundle: ## Run tests for all Bundle components
	make monorepo_tests a="/symfony/src/Symfony/Bundle"

monorepo_tests_component: ## Run tests for all Components
	make monorepo_tests a="/symfony/src/Symfony/Component"

monorepo_tests_di: ## Run tests for DependencyInjection: Testing service container compilation and resolution
	make monorepo_tests a="/symfony/src/Symfony/Component/DependencyInjection"

monorepo_tests_doctrine: ## Run tests for DoctrineBridge: Verifying integration between Symfony and Doctrine
	make monorepo_tests a="/symfony/src/Symfony/Bridge/Doctrine"

monorepo_tests_eventdispatcher: ## Run tests for EventDispatcher: Testing the communication layer between components
	make monorepo_tests a="/symfony/src/Symfony/Component/EventDispatcher"

monorepo_tests_form: ## Run tests for Form: Testing complex mapping, validation, and rendering logic
	make monorepo_tests a="/symfony/src/Symfony/Component/Form"

monorepo_tests_httpfoundation: ## Run tests for HttpFoundation: Verifying HTTP request/response standards and logic
	make monorepo_tests a="/symfony/src/Symfony/Component/HttpFoundation"

monorepo_tests_httpkernel: ## Run tests for HttpKernel: The central engine managing the request lifecycle
	make monorepo_tests a="/symfony/src/Symfony/Component/HttpKernel"

monorepo_tests_routing: ## Run tests for Routing: Validating URL matching and generation
	make monorepo_tests a="/symfony/src/Symfony/Component/Routing"

monorepo_tests_security: ## Run tests for SecurityBundle: Testing authentication, firewalls, and authorization
	make monorepo_tests a="/symfony/src/Symfony/Bundle/SecurityBundle"

monorepo_tests_twig: ## Run tests for TwigBridge: Validating Twig extensions and integration with components
	make monorepo_tests a="/symfony/src/Symfony/Bridge/Twig"
```

> **Note:** The `make/local.mk` file is ignored by Git. This is the perfect place to experiment with new commands before potentially proposing them as a permanent addition to the project.

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
make contrib_add_repo d=monolog-bundle
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
make monorepo_clean
make contrib_clean d=monolog-bundle
```

---

[⬅️ README](README.md)
