# Makefile: target naming richness

[⬅️ Symfony Starter documentation](../README.md)

---

## Context and problem statement

Make commands should be treated like Bash aliases: short, unambiguous, easy to remember. Unlike Bash aliases, targets come with a description for free via `make help`, so the name
itself doesn't need to explain what the command does.

Most targets follow this lightweight approach:

```
up                                       Start the containers (e.g. make up a=-d)
down                                     Stop the containers
logs                                     View logs (follow mode)
dump                                     Create a SQL dump
tables                                   Show all tables
```

The problem arises when several targets, spread across different sections of the same Makefile, risk **clashing** on the same short name.

## Considered options

### 1. Always use short, lightweight names

Effortless to type, but breaks down as soon as two unrelated commands share the same short name in the same Makefile scope.

### 2. Always use rich, fully descriptive semantic names

Removes any collision risk, but turns every target into a mini-sentence and duplicates what `make help` already documents.

### 3. Use short names by default, add richness only to prevent a collision

Keeps the alias-like experience as the default, and reserves longer or prefixed names for the targets that would otherwise clash.

Examples already applied in the project:

* `require_ux_react`, `require_test_pack`, `require_phpcsfixer`, … — a bare `require` could only install one thing; the suffix distinguishes each install target from the others.
* `monorepo_tests`, `repo_tests`, and the project's own `tests` — three "run the tests" commands coexist in the same Makefile; a bare `tests` for each would collide, so a namespace
  prefix disambiguates them.
* `db` / `db_test`, `monolog` / `monolog@prod`, `fixtures` / `fixtures_test` — the base name stays short; only a minimal suffix disambiguates the environment variant.
* `p` (`phpunit`), `a` (`assets`), `cc` (`cache_clear`), `sh` (`php_sh`) — even shorter aliases, viable because `make help` documents what they expand to.

## Decision outcome

> [!NOTE]
>
> **Option 3 is chosen:** Default to short, Bash-alias-style target names. Add richer naming only when a real collision risk exists in the same Makefile scope.

This keeps most commands quick to type, relies on `make help` for explanations, and reserves longer or prefixed names for install targets, near-duplicate command groups, and
environment variants — the cases where a short name alone would collide.

---

[⬅️ Symfony Starter documentation](../README.md)
