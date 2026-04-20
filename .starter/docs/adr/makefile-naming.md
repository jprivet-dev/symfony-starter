# Makefile: target naming convention

[⬅️ README](../README.md)

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

## Considered options

### 1. Use `kebab-case` (e.g., `my-target-a`)

This is the preferred standard for command-line options in some ecosystems. Selection would require manually highlighting the entire word with the mouse or a triple-click.

### 2. Use `snake_case` (e.g., `my_target_a`)

The underscore (`_`) is not treated as a word separator by default in Linux terminals, allowing the entire target name to be selected instantly with a double-click across various operating systems.

## Decision outcome

> **Option 2 is chosen:** Adopt `snake_case` (`my_target_a`) for all Makefile targets.

The increased efficiency and seamless copy/paste experience enabled by double-clicking on a `snake_case` target outweigh the preference for `kebab-case` commonly seen elsewhere. This decision directly supports the goal of improving developer workflow and reducing friction when executing commands.


---

[⬅️ README](../README.md)
