# Makefile: .PHONY usage convention

[⬅️ Symfony Starter documentation](../README.md)

---

## Context and problem statement

`.PHONY` tells `make` that a target is not a real file, preventing `make` from skipping the recipe when a file or directory with the same name already exists in the project.

Two questions arise once a target naming convention (see [makefile-naming.md](makefile-naming.md)) is in place:

1. **Where** should `.PHONY` be declared?
2. **When** is `.PHONY` actually needed?

### Where

`.PHONY` works identically regardless of its position in the file — `make` collects all `.PHONY` prerequisites file-wide. Declaring it directly above the target it protects is a readability choice, not a functional requirement:

```makefile
.PHONY: my_target_a
my_target_a: # Comment
    command
```

This keeps the link between a target and its `.PHONY` declaration explicit and local, instead of grouping all `.PHONY` declarations in one block disconnected from the targets they protect.

### When

`.PHONY` only changes behavior when a file or directory could collide with the target name. Declaring it on every single target adds visual noise without functional benefit when no such collision is possible.

Short target names (e.g., `test`, `build`, `docs`) are more likely to collide with an actual file or directory in the project. Following the `snake_case` convention from [makefile-naming.md](makefile-naming.md), compound target names (e.g., `test_unit`, `build_assets`) are less likely to match an existing file or directory, reducing the practical need for `.PHONY` on those targets.

## Considered options

### 1. Always declare `.PHONY` for every target

Systematic and safe regardless of naming, but adds a `.PHONY` line above every single target, increasing file length and noise even when no collision risk exists.

### 2. Declare `.PHONY` only when a collision risk exists, directly above the target

Reserves `.PHONY` for short or otherwise collision-prone target names. Reduces noise and keeps Makefiles shorter and easier to read, at the cost of requiring a judgment call on which targets need it.

## Decision outcome

> [!NOTE]
>
> **Option 2 is chosen:** Declare `.PHONY` only when necessary, directly above the target it protects.

`.PHONY` is added when a target name is short or otherwise likely to collide with a file or directory (e.g., `test`, `build`, `docs`). It is generally omitted for multi-word `snake_case` targets, which are statistically less likely to collide.

This reduces `.PHONY` noise and keeps Makefiles easier to scan, while preserving safety where collisions are plausible.

---

[⬅️ Symfony Starter documentation](../README.md)
