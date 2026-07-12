# Contribute to the Symfony monorepo

[⬅️ Generate your reproducer and contribute to Symfony](contrib.md)

---

## Overview

| Step                        | In                 | Commands                                                                                    |
|-----------------------------|--------------------|---------------------------------------------------------------------------------------------|
| **Phase 1 — Reproduce**     |                    |                                                                                             |
| Install & Reproduce the bug | `/symfony-starter` | `make require_co a=symfony/http-client`                                                     |
| **Phase 2 — Contribute**    |                    |                                                                                             |
| Fork & clone                | `./`               | `git clone <MY_USERNAME>/symfony.git`<br>`git remote add upstream`                          |
| Create topic branch         | `/symfony`         | `git switch 8.x`<br>`git pull --rebase upstream 8.x`<br>`git switch -c MY_TOPIC_BRANCH 8.x` |
| Add Docker volume           | `/symfony-starter` | `make monorepo_volume`                                                                      |
| Install dependencies & Link | `/symfony-starter` | `make monorepo_install`<br>`make link`                                                      |
| Run tests                   | `/symfony-starter` | `make monorepo_tests a=...`                                                                 |
| Revert                      | `/symfony-starter` | `make unlink`                                                                               |

## Phase 1 — Reproduce the bug

### 1. Install the components needed to reproduce the bug

```shell
# in /symfony-starter

# e.g. composer require symfony/http-client (via docker compose)
make require_co a=symfony/http-client
```

### 2. Reproduce the bug

Create a minimal test case in the reproducer and confirm the bug exists.

## Phase 2 — Contribute to the Symfony monorepo

### 1. Fork and clone side-by-side with the starter

> [!NOTE]
>
> See https://symfony.com/doc/current/contributing/code/pull_requests.html

Fork the [symfony/symfony](https://github.com/symfony/symfony) repository on GitHub. Uncheck
"Copy the `X.Y` branch only", then clone your fork side-by-side with the starter:

```shell
# in ./
git clone git@github.com:<MY_USERNAME>/symfony.git
cd symfony
git remote add upstream https://github.com/symfony/symfony.git
```

```
./                     <-- run git clone from here
├── symfony/           <-- Your fork
└── symfony-starter/   <-- Your reproducer
```

### 2. Create your topic branch

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

### 3. Add the Docker volume for the Symfony monorepo

This mounts your local `../symfony` fork into the container, allowing you to use the
reproducer's PHP container as the PHP interpreter for the Symfony monorepo.

```shell
# in /symfony-starter
make monorepo_volume
```

### 4. Install the monorepo dependencies and link it into your application's vendors

```shell
# in /symfony-starter

# 1. install the external dependencies used during the tests
make monorepo_install

# 2. link the monorepo into your application's vendors
make link
```

### 5. Run the tests for the first time to verify everything is working

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

### 6. Revert: unlink the monorepo

```shell
# in /symfony-starter
make unlink
```

---

[⬅️ Generate your reproducer and contribute to Symfony](contrib.md)
