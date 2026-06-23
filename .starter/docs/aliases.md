# Shell Aliases: Seamless Docker Experience

[⬅️ STARTER](STARTER.md)

---

Do you prefer using standard commands like `composer require` or `php bin/console` instead of typing `docker compose exec php ...` every time?

It's possible! This starter includes a set of **Shell Aliases** that transparently map your local commands to their Dockerized counterparts (via the Makefile).

## How to enable aliases

Since these aliases are **project-specific**, they are not loaded globally. You simply "activate" them when you start working on this project.

Run this command in your terminal session:

```bash
. aliases
# or
source aliases
```

You should see a confirmation output like this:

```text
Aliases
-------

 ✔ Create console alias for make console
 ✔ Create symfony alias for make symfony
 ✔ Create sf alias for make sf
 ✔ Create php alias for make php
 ✔ Create composer alias for make composer
 ✔ Create phpunit alias for make phpunit

This aliases are temporary for your current shell session. To remove them close your terminal tab/window (Easiest), or run:
$ unalias symfony console sf php composer phpunit
```

## The Magic (Before vs. After)

Once loaded, you can type commands "naturally". They will be redirected to the `Makefile`, which executes them inside the Docker container.

### Composer

| You type...                        | It runs...                                                 |
|------------------------------------|------------------------------------------------------------|
| `composer require symfony/console` | `make composer a="require symfony/console"`                |
| *(Which runs)*                     | `docker compose exec php composer require symfony/console` |

### PHP

| You type...     | It runs...                                  |
|-----------------|---------------------------------------------|
| `php --version` | `make php a="--version"`                    |
| *(Which runs)*  | `docker compose exec php php php --version` |

### Symfony console

| You type...           | It runs...                                        |
|-----------------------|---------------------------------------------------|
| `console debug:route` | `make console c="debug:route"`                    |
| *(Which runs)*        | `docker compose exec php bin/console debug:route` |

## How to disable

As the output suggests, the aliases are temporary for your current shell session.
To remove them, you have two options:

1. **Close your terminal tab/window.** (Easiest)
2. Run the command provided in the output (e.g., `unalias console symfony ...`).

---

[⬅️ STARTER](STARTER.md)
