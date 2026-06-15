# Symfony Contribution — Claude Project: Issue Workflow

## Project setup

Create a Claude Project at https://claude.ai with the following configuration:

### Files to load

- `.starter/docs/STARTER.md`
- `.starter/docs/contrib.md`
- `.make/contrib.mk`
- `.make/generate.mk`
- `.claude/project-contrib-issue.md` (this file)

### Project instructions

```
You are assisting a Symfony developer using the Symfony Starter toolkit.
When the user mentions a Symfony issue, follow the workflow defined in
project-contrib-issue.md, using .starter/docs/contrib.md as the reference
for all commands and procedures.
Always generate complete, ready-to-run commands with no placeholders left unfilled.
Always specify the working directory context (in /symfony-starter or in /symfony).
```

---

## When the user mentions a Symfony issue

When the user shares an issue URL, number, or content, do the following:

### 1. Analyze the issue

Extract:

- **Symfony version** affected → target branch (e.g. `7.4`, `8.1`)
- **Component** affected → Composer package and monorepo path:
  - Form → `symfony/form` → `/symfony/src/Symfony/Component/Form`
  - Security CSRF → `symfony/security-csrf` → `/symfony/src/Symfony/Component/Security/Csrf`
  - HttpKernel → `symfony/http-kernel` → `/symfony/src/Symfony/Component/HttpKernel`
  - HttpClient → `symfony/http-client` → `/symfony/src/Symfony/Component/HttpClient`
  - Routing → `symfony/routing` → `/symfony/src/Symfony/Component/Routing`
  - EventDispatcher → `symfony/event-dispatcher` → `/symfony/src/Symfony/Component/EventDispatcher`
  - Console → `symfony/console` → `/symfony/src/Symfony/Component/Console`
  - *(adapt for any other component)*
- **Type** : bug, feature, deprecation, RFC

### 2. Propose a branch name

Use the format: `{issue_id}-{short-kebab-case-description}`
e.g. `64610-csrf-token-invalid`

### 3. Select the right reproducer command

| Symfony version | Command                                    |
|-----------------|--------------------------------------------|
| 8.x (stable)    | `make reproducer BRANCH={branch-name}`     |
| 7.x (LTS)       | `make reproducer@lts BRANCH={branch-name}` |
| 6.x (legacy)    | `make reproducer@6x BRANCH={branch-name}`  |

### 4. Generate the complete two-phase workflow

Follow `.starter/docs/contrib.md` and fill in all values from the issue analysis.
Never leave placeholders like `MY_TOPIC_BRANCH`, `MY_USERNAME`, or `{branch-name}` unfilled.
Always specify the working directory context for each command block.

#### Rules

- `make monorepo_install` must always be run **before** `make monorepo_link`
- The branch name must be **identical** in the reproducer and in the symfony fork
- If the fork already exists locally, include the update steps (`git switch`, `git pull --rebase upstream`)
- If the issue targets a bundle or bridge outside the monorepo, follow the bundle workflow from `contrib.md`
