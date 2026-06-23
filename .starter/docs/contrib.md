# Contributing - Connect your local Symfony repository

[⬅️ STARTER](STARTER.md)

---

This starter provides a powerful toolkit to help you contribute to the Symfony framework or any
Symfony bundle. It allows you to mount a local repository directly into your Dockerized application
and test your changes immediately.

## Before you start: generate your reproducer

Before contributing to `symfony/symfony` or any Symfony bundle, generate a minimalist Symfony
application configured as a reproducer:

```shell
# in /symfony-starter

# stable release
make reproducer
# or LTS - long-term support release
make reproducer@lts
# or Symfony 6.x
make reproducer@6x
```

| Command               | Symfony version                     |
|-----------------------|-------------------------------------|
| `make reproducer`     | Latest stable release               |
| `make reproducer@lts` | Long-term support release           |
| `make reproducer@6x`  | Symfony 6.x (for legacy reproducer) |

## Contribute to `symfony/symfony`

### Phase 1 — Reproduce the bug

#### 1. Install the components needed to reproduce

```shell
# in /symfony-starter

# e.g. composer require symfony/http-client (via docker compose)
make require_co a=symfony/http-client
```

#### 2. Reproduce the bug

Create a minimal test case in the reproducer and confirm the bug exists.

### Phase 2 — Contribute to the monorepo

#### 1. Fork and clone side-by-side with the starter

> [!NOTE]
>
> See https://symfony.com/doc/current/contributing/code/pull_requests.html

Fork the [symfony/symfony](https://github.com/symfony/symfony) repository on GitHub. Uncheck
"Copy the `X.Y` branch only", then clone your fork side-by-side with the starter:

```shell
# in ./
git clone git@github.com:MY_USERNAME/symfony.git
cd symfony
git remote add upstream https://github.com/symfony/symfony.git
```

```
./                     <-- run git clone from here
├── symfony/           <-- Your fork
└── symfony-starter/   <-- Your reproducer
```

#### 2. Create your topic branch

```shell
# IN /symfony - NOT IN /symfony-starter

# Update an existing branch
git switch 8.x
git pull --rebase upstream 8.x
git switch -c MY_TOPIC_BRANCH 8.x

# Or track a new remote branch
git switch 6.x
git switch -c MY_TOPIC_BRANCH 6.x
```

#### 3. Add the Docker volume for the Symfony monorepo

This mounts your local `../symfony` fork into the container, allowing you to use the
reproducer's PHP container as the PHP interpreter for the Symfony monorepo.

```shell
# in /symfony-starter
make monorepo_volume
```

#### 4. Install the monorepo dependencies and link it into your application's vendors

```shell
# in /symfony-starter

# 1. install the external dependencies used during the tests
make monorepo_install

# 2. link the monorepo into your application's vendors
make monorepo_link
```

#### 5. Run the tests for the first time to verify everything is working

e.g. [HTTP Client](https://symfony.com/doc/current/http_client.html):

```shell
# in /symfony-starter
make monorepo_tests a="/symfony/src/Symfony/Component/HttpClient"
```

> [!NOTE]
>
> Tests are run inside the reproducer's PHP container using absolute paths from the container's
> root (e.g. `/symfony/src/...`).

> [!TIP]
>
> When running large test suites, you can exclude the integration group, which requires
> additional infrastructure (e.g. Redis or RabbitMQ), by appending the `--exclude-group` argument:

```shell
# in /symfony-starter
make monorepo_tests a="/symfony/src/Symfony/Bundle --exclude-group=redis"
```

PHPUnit cache and temporary files are automatically cleaned before each test run.
If you need to clean them manually:

```shell
# in /symfony-starter
make monorepo_tests_clean
```

#### 6. Revert: unlink the monorepo

```shell
# in /symfony-starter
make monorepo_unlink
```

## Contribute to a Symfony bundle or bridge

This section uses the [MonologBundle](https://github.com/symfony/monolog-bundle) as an example.
The same workflow applies to any Symfony bundle or bridge hosted in its own repository, outside
the `symfony/symfony` monorepo.

### Phase 1 — Reproduce the bug

#### 1. Install the bundle needed to reproduce

```shell
# in /symfony-starter
make require_co a="symfony/monolog-bundle"
```

#### 2. Reproduce the bug

Create a minimal test case in the reproducer and confirm the bug exists.

### Phase 2 — Contribute to the bundle

#### 1. Fork and clone side-by-side with the starter

> [!NOTE]
>
> See https://github.com/symfony/monolog-bundle

```shell
# in ./
git clone git@github.com:MY_USERNAME/monolog-bundle.git ../monolog-bundle
cd ../monolog-bundle
git remote add upstream https://github.com/symfony/monolog-bundle.git
```

```
./
├── symfony-starter/   <-- Your reproducer
└── monolog-bundle/    <-- Your fork
```

#### 2. Create your topic branch

```shell
# IN /monolog-bundle - NOT IN /symfony-starter

# Update an existing branch
git switch 4.x
git pull --rebase upstream 4.x
git switch -c MY_TOPIC_BRANCH 4.x

# Or track a new remote branch
git switch 3.x
git switch -c MY_TOPIC_BRANCH 3.x
```

#### 3. Add the Docker volume, register the path repository and link the local version

```shell
# in /symfony-starter
make repo_volume d=monolog-bundle
make repo_add d=monolog-bundle
make require_co a="symfony/monolog-bundle:4.x-dev --prefer-source"
```

> [!TIP]
>
> Composer expects a version following the `[branch-name]-dev` pattern. If your local branch is
> named `main`, use `main-dev`; if it's `4.x`, use `4.x-dev`.

#### 4. Install the external dependencies used during the tests

```shell
# in /symfony-starter
make repo_install d=monolog-bundle
```

#### 5. Run the tests for the first time to verify everything is working

```shell
# in /symfony-starter
make repo_tests d=monolog-bundle
```

PHPUnit cache and temporary files are automatically cleaned before each test run.
If you need to clean them manually:

```shell
# in /symfony-starter
make repo_tests_clean d=monolog-bundle
```

#### 6. Revert: remove the path repository and restore the published package

> [!TIP]
>
> Once your changes are ready to submit as a pull request, or if you want to switch back to the
> published version of the package, remove the local path repository.

```shell
# in /symfony-starter
make repo_remove d=monolog-bundle
make update a=symfony/monolog-bundle
```

## Workflow overview

```mermaid
flowchart TD
  START([Start]) --> REPRODUCER
  REPRODUCER["GENERATE YOUR REPRODUCER\n─────────────────────\n$ make reproducer\n$ make reproducer@lts\n$ make reproducer@6x\n\nin /symfony-starter"]
  REPRODUCER --> CHOICE{What do you\nwant to contribute to?}
  CHOICE -->|symfony/symfony| MP1
  CHOICE -->|Bundle or Bridge| BP1
%% ── MONOREPO WORKFLOW ──────────────────────────────────────
  MP1["PHASE 1 — REPRODUCE\n─────────────────────\n$ make require_co a=symfony/http-client\n\nin /symfony-starter"]
  MP1 --> MP2["PHASE 2 — CONTRIBUTE\n1. FORK & CLONE\n─────────────────────\n$ git clone MY_USERNAME/symfony.git\n$ git remote add upstream\n\nin ./"]
  MP2 --> M2["2. CREATE TOPIC BRANCH\n─────────────────────\n$ git switch 8.x\n$ git pull --rebase upstream 8.x\n$ git switch -c MY_TOPIC_BRANCH 8.x\n\nin /symfony"]
  M2 --> M3["3. ADD DOCKER VOLUME\n─────────────────────\n$ make monorepo_volume\n\nin /symfony-starter"]
  M3 --> M4["4. INSTALL & LINK\n─────────────────────\n$ make monorepo_install\n$ make monorepo_link\n\nin /symfony-starter"]
  M4 --> M5["5. RUN TESTS\n─────────────────────\n$ make monorepo_tests a=...\n\nin /symfony-starter"]
  M5 --> M6(["6. REVERT\n$ make monorepo_unlink"])
%% ── BUNDLE WORKFLOW ────────────────────────────────────────
  BP1["PHASE 1 — REPRODUCE\n─────────────────────\n$ make require_co a=symfony/monolog-bundle\n\nin /symfony-starter"]
  BP1 --> BP2["PHASE 2 — CONTRIBUTE\n1. FORK & CLONE\n─────────────────────\n$ git clone MY_USERNAME/monolog-bundle.git\n$ git remote add upstream\n\nin ./"]
  BP2 --> B2["2. CREATE TOPIC BRANCH\n─────────────────────\n$ git switch 4.x\n$ git pull --rebase upstream 4.x\n$ git switch -c MY_TOPIC_BRANCH 4.x\n\nin /monolog-bundle"]
  B2 --> B3["3. ADD DOCKER VOLUME, REGISTER REPO & LINK\n─────────────────────\n$ make repo_volume d=monolog-bundle\n$ make repo_add d=monolog-bundle\n$ make require_co a=monolog-bundle:4.x-dev\n\nin /symfony-starter"]
  B3 --> B4["4. INSTALL DEPENDENCIES\n─────────────────────\n$ make repo_install d=monolog-bundle\n\nin /symfony-starter"]
  B4 --> B5["5. RUN TESTS\n─────────────────────\n$ make repo_tests d=monolog-bundle\n\nin /symfony-starter"]
  B5 --> B6(["6. REVERT\n$ make repo_remove d=monolog-bundle\n$ make update a=symfony/monolog-bundle"])
```

## Personal shortcuts

If you are working frequently on specific components, you can create your own shortcuts. The
starter includes a mechanism to load local Makefile rules that are not committed to the repository.

### 1. Create your local Makefile

```shell
cp .make/local.mk.dist .make/local.mk
```

### 2. Add your custom commands to `.make/local.mk`

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

> [!TIP]
>
> The `.make/local.mk` file is ignored by Git. This is the perfect place to experiment with new
> commands before potentially proposing them as a permanent addition to the project.

## AI-assisted issue workflow with Claude.ai

If you use [Claude.ai](https://claude.ai), you can set up a [Claude Project](https://claude.ai/projects) that
automatically generates the complete contribution procedure from a Symfony issue
— no Claude Code required.

> [!TIP]
>
> See `.claude/project-issue-workflow.md` for the setup instructions.

---

[⬅️ STARTER](STARTER.md)
