# Contribute to a Symfony bundle or bridge

[⬅️ Generate your reproducer and contribute to Symfony](contrib.md)

---

This section uses the [MonologBundle](https://github.com/symfony/monolog-bundle) as an example.
The same workflow applies to any Symfony bundle or bridge hosted in its own repository, outside
the `symfony/symfony` monorepo.

## Overview

| Step                                    | In                 | Commands                                                                                                              |
|-----------------------------------------|--------------------|-----------------------------------------------------------------------------------------------------------------------|
| **Phase 1 — Reproduce**                 |                    |                                                                                                                       |
| Install & Reproduce the bug             | `/symfony-starter` | `make require_co a=symfony/monolog-bundle`                                                                            |
| **Phase 2 — Contribute**                |                    |                                                                                                                       |
| Fork & clone                            | `./`               | `git clone <MY_USERNAME>/monolog-bundle.git`<br>`git remote add upstream`                                             |
| Create topic branch                     | `/monolog-bundle`  | `git switch 4.x`<br>`git pull --rebase upstream 4.x`<br>`git switch -c MY_TOPIC_BRANCH 4.x`                           |
| Add Docker volume, register repo & link | `/symfony-starter` | `make repo_volume d=monolog-bundle`<br>`make repo_add d=monolog-bundle`<br>`make require_co a=monolog-bundle:4.x-dev` |
| Install dependencies                    | `/symfony-starter` | `make repo_install d=monolog-bundle`                                                                                  |
| Run tests                               | `/symfony-starter` | `make repo_tests d=monolog-bundle`                                                                                    |
| Revert                                  | `/symfony-starter` | `make repo_remove d=monolog-bundle`<br>`make update a=symfony/monolog-bundle`                                         |

## Phase 1 — Reproduce the bug

### 1. Install the bundle needed to reproduce

```shell
# in /symfony-starter
make require_co a="symfony/monolog-bundle"
```

### 2. Reproduce the bug

Create a minimal test case in the reproducer and confirm the bug exists.

## Phase 2 — Contribute to the bundle or bridge

### 1. Fork and clone side-by-side with the starter

> [!NOTE]
>
> See https://github.com/symfony/monolog-bundle

```shell
# in ./
git clone git@github.com:<MY_USERNAME>/monolog-bundle.git ../monolog-bundle
cd ../monolog-bundle
git remote add upstream https://github.com/symfony/monolog-bundle.git
```

```
./
├── symfony-starter/   <-- Your reproducer
└── monolog-bundle/    <-- Your fork
```

### 2. Create your topic branch

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

### 3. Add the Docker volume, register the path repository and link the local version

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

### 4. Install the external dependencies used during the tests

```shell
# in /symfony-starter
make repo_install d=monolog-bundle
```

### 5. Run the tests for the first time to verify everything is working

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

### 6. Revert: remove the path repository and restore the published package

> [!TIP]
>
> Once your changes are ready to submit as a pull request, or if you want to switch back to the
> published version of the package, remove the local path repository.

```shell
# in /symfony-starter
make repo_remove d=monolog-bundle
make update a=symfony/monolog-bundle
```

---

[⬅️ Generate your reproducer and contribute to Symfony](contrib.md)
