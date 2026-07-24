# Makefile: target naming convention

[⬅️ Symfony Starter documentation](../README.md)

---

## Context and problem statement

The basic structure of a Makefile rule is as follows:

```makefile
.PHONY: target
target: dependencies # Comment
    command
    command
    # ...
    command
```

The primary goal is to **improve developer experience** by allowing commands, specifically the target name, to be quickly and easily **selected, copied, and pasted** anywhere (terminal, shell scripts, other Makefiles).

However, we face inconsistent selection behavior when using the **double-click** action in the Linux environment (this behavior is typically absent in Windows).

* ✅ **Success** when double-clicking on a **`snake_case`** target name:

  ```makefile
      .PHONY: my_target_a
      my_target_a: # Comment
        command
  ```

* ❌ **Failure** when double-clicking on a **`kebab-case`** target name: The double-click action treats the hyphen (`-`) as a word separator, resulting in only a fragment of the target name being selected.

  ```makefile
      .PHONY: my-target-a
      my-target-a: # Comment
        command
  ```

* ❌ **Failure** when double-clicking on a **`slash/separated`** target name: The double-click action treats the slash (`/`) as a word separator too, resulting in the same fragmented selection.

  ```makefile
      .PHONY: my/target/a
      my/target/a: # Comment
        command
  ```

* ❌ **Failure** when double-clicking on an **`@`-categorized** target name: The double-click action treats the at sign (`@`) as a word separator too, resulting in the same fragmented selection. This pattern is sometimes used to visually group a command under a category (e.g., `test`), but suffers from the same selection issue.

  ```makefile
      .PHONY: my_target_a@test
      my_target_a@test: # Comment
        command
  ```

## Considered options

### 1. Use `snake_case` (e.g., `my_target_a`)

The underscore (`_`) is not treated as a word separator by default in Linux terminals, allowing the entire target name to be selected instantly with a double-click across various operating systems.

### 2. Use `kebab-case` (e.g., `my-target-a`)

This is the preferred standard for command-line options in some ecosystems. Selection would require manually highlighting the entire word with the mouse or a triple-click.

### 3. Use `slash/separated` (e.g., `my/target/a`)

Sometimes used to mimic a namespace or hierarchy (e.g., `docker/build`, `db/migrate`). Suffers from the same double-click selection failure as `kebab-case`, since `/` is also treated as a word separator.

### 4. Use `@`-categorized naming (e.g., `my_target_a@test`)

Sometimes used to visually group a command under a category, similar to a suffix tag. Visually appealing, but suffers from the same double-click selection failure as `kebab-case` and `slash/separated`, since `@` is also treated as a word separator. `my_target_a_test` (plain `snake_case`) achieves the same grouping intent without the selection issue.

## Decision outcome

> [!NOTE]
>
> **Option 1 is chosen:** Adopt `snake_case` (e.g., `my_target_a`) for all Makefile targets.

The increased efficiency and seamless copy/paste experience enabled by double-clicking on a `snake_case` target outweigh the preference for `kebab-case`, `slash/separated`, or `@`-categorized naming commonly seen elsewhere. This decision directly supports the goal of improving developer workflow and reducing friction when executing commands.

---

[⬅️ Symfony Starter documentation](../README.md)
