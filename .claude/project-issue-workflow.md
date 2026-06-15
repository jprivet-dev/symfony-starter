# Symfony Contribution — Claude Project: Issue Workflow

## Project setup

### 1. Create the Claude Project

Go to https://claude.ai/projects and click **Create project**.

- **Name**: `Symfony Contribution Workflow`
- **Description** *(optional)*: `Step-by-step workflow to reproduce and fix Symfony issues using the Symfony Starter toolkit.`

### 2. Load the project files

In the project settings, upload the following files from your local `symfony-starter` repository:

| File                                | Purpose                                                 |
|-------------------------------------|---------------------------------------------------------|
| `.starter/docs/STARTER.md`          | Starter toolkit overview and available `make` commands  |
| `.starter/docs/contrib.md`          | Full contribution guide (monorepo and bundle workflows) |
| `.make/contrib.mk`                  | Makefile targets for contribution commands              |
| `.make/generate.mk`                 | Makefile targets for project generation                 |
| `.claude/project-issue-workflow.md` | This file — defines the issue workflow                  |

### 3. Set the project instructions

In the project settings, paste the following as **Project instructions**:

```
You are assisting a Symfony developer using the Symfony Starter toolkit.
When the user mentions a Symfony issue, follow the workflow defined in
project-issue-workflow.md, using .starter/docs/contrib.md as the reference
for all commands and procedures.
Always generate complete, ready-to-run commands with no placeholders left unfilled.
Always specify the working directory context (in /symfony-starter or in /symfony).
```

### 4. Start a new conversation

For each issue, **open a new conversation** in this project and name it after the branch:
e.g. `symfony/64610-csrf-token-invalid-sf7.4`

This keeps one conversation per issue, making it easy to resume work later.

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

### 2. Propose a branch name and conversation title

Use the format: `symfony/{issue_id}-{short-kebab-case-description}-sf{version}`
e.g. `symfony/64610-csrf-token-invalid-sf7.4`

The `symfony/` prefix helps distinguish branches across different repositories
(e.g. `monolog/64610-...` for a MonologBundle issue).

The `-sf{version}` suffix makes it easy to work on the same issue across multiple Symfony
versions simultaneously, e.g.:

- `symfony/64610-csrf-token-invalid-sf7.4`
- `symfony/64610-csrf-token-invalid-sf8.1`

This is a suggestion — the user is free to choose a different name. The only constraint
is that **the branch name must be identical** in the reproducer and in the Symfony fork
to avoid confusion. This can be verified at any time with:

```shell
# in /symfony-starter
make monorepo_status
```

Which outputs something like:

```
REPOSITORY                 BRANCH
symfony-starter            symfony/64610-csrf-token-invalid-sf7.4
symfony                    symfony/64610-csrf-token-invalid-sf7.4
```

Suggest the user rename the current conversation to this branch name to keep things organized.

### 3. Select the right reproducer command

| Symfony version | Command                                    |
|-----------------|--------------------------------------------|
| 8.x (stable)    | `make reproducer BRANCH={branch-name}`     |
| 7.x (LTS)       | `make reproducer@lts BRANCH={branch-name}` |
| 6.x (legacy)    | `make reproducer@6x BRANCH={branch-name}`  |

### 4. Present the global approach

Before generating any commands, briefly present the three-phase approach so the user
understands the path ahead:

- **Phase 1 — Setup**: generate the reproducer and install the required dependencies
- **Phase 2 — Reproduce**: write the minimal code to trigger the bug and confirm it exists
- **Phase 3 — Fix**: link the local Symfony fork, investigate the component, and submit a fix
- **Phase 4 — Cleanup**: unlink the monorepo and clean up the reproducer

Then generate only Phase 1. Wait for the user's confirmation before moving to the next phase.

### 5. Generate Phase 1 — Setup

Generate the reproducer and install only the Composer dependencies needed to reproduce the issue.
Do not write any application code at this stage.

Fill in all values from the issue analysis.
Never leave placeholders like `MY_TOPIC_BRANCH`, `MY_USERNAME`, or `{branch-name}` unfilled.
Always specify the working directory context for each command block.

```shell
# in /symfony-starter
make reproducer@lts BRANCH={branch-name}
```

Then add each required Composer dependency:

```shell
# in /symfony-starter
make require a={package}
git add . && git commit -m "require {package}"
```

End Phase 1 with this reminder:
> ✅ Phase 1 complete. Once the environment is ready, ask me for **Phase 2** to write the
> minimal reproduction code.

### 6. Generate Phase 2 — Reproduce (on request only)

Only generate this phase when the user explicitly asks for it.

Provide the minimal application code needed to trigger the bug:

- Controller, form type, template, entity, fixture — only what is strictly necessary
- Target the exact scenario described in the issue
- Include the expected result and the actual result to observe

End Phase 2 with this reminder:
> ✅ Phase 2 complete. If the bug is confirmed, ask me for **Phase 3** to link your local
> Symfony fork and start investigating the fix.

### 7. Generate Phase 3 — Fix (on request only)

Only generate this phase when the user explicitly asks for it, and only if the bug has been
confirmed in Phase 2.

Follow `.starter/docs/contrib.md` for all commands and procedures.

#### Rules

- `make monorepo_install` must always be run **before** `make monorepo_link`
- The branch name must be **identical** in the reproducer and in the Symfony fork
- If the fork already exists locally, include the update steps (`git switch`, `git pull --rebase upstream`)
- If the issue targets a bundle or bridge outside the monorepo, follow the bundle workflow from `contrib.md`

Steps to generate:

1. Fork and clone `symfony/symfony` side-by-side with the starter (if not already done)
2. Create the topic branch in the fork
3. Add the Docker volume: `make monorepo_volume`
4. Install and link: `make monorepo_install` then `make monorepo_link`
5. Run the component tests to verify the setup
6. Provide the monorepo path to investigate
7. Remind how to revert: `make monorepo_unlink`

End Phase 3 with this reminder:
> ✅ Phase 3 ready. Run the tests after each change, then open a Pull Request on
> `symfony/symfony` targeting the `{branch}` branch.
> Once your PR is submitted, ask me for **Phase 4** to clean up the environment.

### 8. Generate Phase 4 — Cleanup (on request only)

Only generate this phase when the user explicitly asks for it.

```shell
# in /symfony-starter
make monorepo_unlink
make clean_app
```

End Phase 4 with this reminder:
> ✅ Phase 4 complete. The environment is clean and ready for the next issue.
