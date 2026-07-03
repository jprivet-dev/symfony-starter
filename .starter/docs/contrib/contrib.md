# Generate your reproducer and contribute to Symfony

[⬅️ Symfony Starter documentation](../README.md)

---

This starter provides a powerful toolkit to help you contribute to the Symfony framework or any
Symfony bundle. It allows you to mount a local repository directly into your Dockerized application
and test your changes immediately.

## Step 1: Generate your reproducer

Before contributing to `symfony/symfony` or any Symfony bundle, generate a minimalist Symfony
application configured as a reproducer:

| Command               | Symfony version                     |
|-----------------------|-------------------------------------|
| `make reproducer`     | Latest stable release               |
| `make reproducer@lts` | Long-term support release           |
| `make reproducer@6x`  | Symfony 6.x (for legacy reproducer) |

All commands run in `/symfony-starter`.

> [!TIP]
>
> See the [GotenbergBundle reproducer example](https://github.com/jprivet-dev/symfony-starter/tree/reproducer/gotenberg-bundle/sf6.4).

## Step 2: Contribute

* [Contribute to `symfony/symfony`](symfony.md)
* [Contribute to a Symfony bundle or bridge](bundle-bridge.md)


## Personal shortcuts

If you are working frequently on specific components, you can create your own shortcuts. The
starter includes a mechanism to load local Makefile rules that are not committed to the repository.

### 1. Create your local Makefile

```shell
cp .make/local.mk.dist .make/local.mk
```

### 2. Add your custom commands

Create `.make/_monorepo.mk` to add shortcuts for the components you work on frequently.
These files are automatically loaded and will appear in `make help`.

```makefile
## — MONOREPO CONTRIBUTION 🔗 —————————————————————————————————————————————————

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
> * Files matching `.make/_*.mk` are auto-loaded and can be committed to the repository — ideal
> for project-specific commands.
> * Use `.make/local.mk` (gitignored) for personal shortcuts you don't want to share.

## AI-assisted issue workflow with Claude.ai

> [!IMPORTANT]
>
> This is EXPERIMENTAL!

If you use [Claude.ai](https://claude.ai), you can set up a [Claude Project](https://claude.ai/projects) that
automatically generates the complete contribution procedure from a Symfony issue
— no Claude Code required.

> [!TIP]
>
> See `.claude/project-issue-workflow.md` for the setup instructions.

---

[⬅️ Symfony Starter documentation](../README.md)
