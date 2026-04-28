# Contributing: Connect your local Symfony repository

[⬅️ README](README.md)

---

This starter provides a powerful toolkit to help you contribute to the Symfony framework or any
Symfony bundle. It allows you to mount a local repository directly into your Dockerized application
and test your changes immediately.

## Contribute to `symfony/symfony`

### 1. Fork and clone side-by-side with the starter

> See https://github.com/symfony/symfony

```shell
git clone git@github.com:YOUR_USERNAME/symfony.git ../symfony
```

```
./
├── symfony/           <-- Your fork
└── symfony-starter/   <-- Your reproducer
```

### 2. Generate a minimalist Symfony application configured for contribution

```shell
# stable release
make contrib
# or LTS - long-term support release
make contrib@lts
```

### 3. Add the Docker volume for the Symfony monorepo and rebuild

```shell
make monorepo_volume
git commit -am "Add the Docker volume for the Symfony monorepo"

make build up_detached
```

### 4. Install the component you wish to contribute

e.g. [HTTP Client](https://symfony.com/doc/current/http_client.html):

```shell
# composer require symfony/http-client (via docker compose)
make require a=symfony/http-client
```

### 5. Link the monorepo into your application's vendors

```shell
make monorepo_link
```

### 6. Install the external dependencies used during the tests

```shell
make monorepo_install
```

### 7. Run the tests for the first time to verify everything is working

e.g. [HTTP Client](https://symfony.com/doc/current/http_client.html):

```shell
make monorepo_tests a="/symfony/src/Symfony/Component/HttpClient"
```

> Tests are run inside the reproducer's PHP container using absolute paths from the container's
> root (e.g. `/symfony/src/...`).

**Pro-tip:** When running large test suites, you can exclude the integration group, which requires
additional infrastructure (e.g. Redis or RabbitMQ), by appending the `--exclude-group` argument:

```shell
make monorepo_tests a="/symfony/src/Symfony/Bundle --exclude-group=redis"
```

PHPUnit cache and temporary files are automatically cleaned before each test run.
If you need to clean them manually:

```shell
make monorepo_tests_clean
```

### 8. Revert: unlink the monorepo

```shell
make monorepo_unlink
```

## Contribute to a Symfony bundle or bridge

This section uses the [MonologBundle](https://github.com/symfony/monolog-bundle) as an example.
The same workflow applies to any Symfony bundle or bridge hosted in its own repository, outside
the `symfony/symfony` monorepo.

### 1. Fork and clone side-by-side with the starter

> See https://github.com/symfony/monolog-bundle

```shell
git clone git@github.com:YOUR_USERNAME/monolog-bundle.git ../monolog-bundle
```

```
./
├── symfony-starter/   <-- Your reproducer
└── monolog-bundle/    <-- Your fork
```

### 2. Generate a minimalist Symfony application configured for contribution

```shell
# stable release
make contrib
# or LTS - long-term support release
make contrib@lts
```

### 3. Add the Docker volume and register the path repository

```shell
make bundle_volume d=monolog-bundle
make bundle_add d=monolog-bundle
git commit -am "Add the Docker volume and register the path repository"

make build up_detached
```

### 4. Link the local version

```shell
# composer require symfony/monolog-bundle:4.x-dev --prefer-source (via docker compose)
make require a="symfony/monolog-bundle:4.x-dev --prefer-source"
git add . && git commit -m "Install symfony/monolog-bundle:4.x-dev"
```

> [!NOTE]
>
> Composer expects a version following the `[branch-name]-dev` pattern. If your local branch is
> named `main`, use `main-dev`; if it's `4.x`, use `4.x-dev`.

### 5. Install the external dependencies used during the tests

```shell
make bundle_install d=monolog-bundle
```

### 6. Run the tests for the first time to verify everything is working

```shell
make bundle_tests d=monolog-bundle
```

PHPUnit cache and temporary files are automatically cleaned before each test run.
If you need to clean them manually:

```shell
make bundle_tests_clean d=monolog-bundle
```

### 7. Revert: remove the path repository and restore the published package

> Once your changes are ready to submit as a pull request, or if you want to switch back to the
> published version of the package, remove the local path repository.

```shell
make bundle_remove d=monolog-bundle
make update a=symfony/monolog-bundle
```

## Personal shortcuts

If you are working frequently on specific components, you can create your own shortcuts. The
starter includes a mechanism to load local Makefile rules that are not committed to the repository.

### 1. Create your local Makefile

```shell
cp make/local.mk.dist make/local.mk
```

### 2. Add your custom commands to `make/local.mk`

These will automatically appear in `make help`. Here are some useful examples you can use:

```makefile
monorepo_tests_bridge: ## Run tests for all Bridge components
	$(MAKE) monorepo_tests a="/symfony/src/Symfony/Bridge"

monorepo_tests_bundle: ## Run tests for all Bundle components
	$(MAKE) monorepo_tests a="/symfony/src/Symfony/Bundle"

monorepo_tests_component: ## Run tests for all Components
	$(MAKE) monorepo_tests a="/symfony/src/Symfony/Component"

monorepo_tests_di: ## Run tests for DependencyInjection
	$(MAKE) monorepo_tests a="/symfony/src/Symfony/Component/DependencyInjection"

monorepo_tests_doctrine: ## Run tests for DoctrineBridge
	$(MAKE) monorepo_tests a="/symfony/src/Symfony/Bridge/Doctrine"

monorepo_tests_eventdispatcher: ## Run tests for EventDispatcher
	$(MAKE) monorepo_tests a="/symfony/src/Symfony/Component/EventDispatcher"

monorepo_tests_form: ## Run tests for Form
	$(MAKE) monorepo_tests a="/symfony/src/Symfony/Component/Form"

monorepo_tests_httpfoundation: ## Run tests for HttpFoundation
	$(MAKE) monorepo_tests a="/symfony/src/Symfony/Component/HttpFoundation"

monorepo_tests_httpkernel: ## Run tests for HttpKernel
	$(MAKE) monorepo_tests a="/symfony/src/Symfony/Component/HttpKernel"

monorepo_tests_routing: ## Run tests for Routing
	$(MAKE) monorepo_tests a="/symfony/src/Symfony/Component/Routing"

monorepo_tests_security: ## Run tests for SecurityBundle
	$(MAKE) monorepo_tests a="/symfony/src/Symfony/Bundle/SecurityBundle"

monorepo_tests_twig: ## Run tests for TwigBridge
	$(MAKE) monorepo_tests a="/symfony/src/Symfony/Bridge/Twig"
```

> [!NOTE]
>
> The `make/local.mk` file is ignored by Git. This is the perfect place to experiment with new
> commands before potentially proposing them as a permanent addition to the project.

---

[⬅️ README](README.md)
