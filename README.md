# Personal Agent Skills

This repository is the canonical source for the reusable agent skills I want available across projects. It started as a fork of [Matt Pocock's skills](https://github.com/mattpocock/skills) and keeps that upstream relationship while also carrying local modifications and personal skills.

The skill files under `skills/` are the source of truth. Ponytail remains a separate plugin, and project-specific skills remain in their own project repositories.

## Compatibility

The skills follow the Agent Skills format and are available to:

- Claude Code through `~/.claude/skills`
- Codex through `~/.agents/skills`
- Pi through `~/.agents/skills`
- Other compatible harnesses that discover one of those directories

## Install on a new machine

```bash
git clone git@github.com:LiliumStargazer/agent-skills.git
cd agent-skills
scripts/link-skills.sh
```

The script creates per-skill symlinks, so this checkout remains the only canonical copy. It links `engineering/`, `productivity/`, and `in-progress/`. It intentionally excludes `misc/` and `deprecated/`.

Do not install this same set through another installer at the same time. Duplicate names can make skill discovery ambiguous.

## Update

```bash
cd /path/to/agent-skills
git pull --ff-only
scripts/link-skills.sh
```

Existing links receive file updates immediately after the pull. Re-run the script to add new skills and remove stale links after skill renames or removals.

## Start a new project

Copy the reusable steering templates, then fill in the project-specific section:

```bash
cp /path/to/agent-skills/templates/{AGENTS.md,CLAUDE.md} /path/to/new-project/
```

`AGENTS.md` is the shared source of truth. `CLAUDE.md` is a minimal Claude Code adapter that imports it.

## Repository layout

- `skills/engineering/`: promoted daily coding workflows
- `skills/productivity/`: promoted general workflows
- `skills/in-progress/`: beta skills linked locally but not shipped in the Claude plugin
- `skills/misc/`: retained but not installed by default
- `skills/deprecated/`: retired skills
- `templates/`: reusable project instruction files
- `scripts/link-skills.sh`: global symlink installer

Generic personal skills belong in the appropriate bucket here. Skills tied to one project stay in that project's repository.

## Upstream

The expected remotes are:

```text
origin    git@github.com:LiliumStargazer/agent-skills.git
upstream  https://github.com/mattpocock/skills.git
```

Review and integrate upstream changes explicitly:

```bash
git fetch upstream
git merge upstream/main
```

Keep personal changes as ordinary commits so upstream merges remain reviewable. Do not replace `upstream` with this fork.

## Skill reference

Skills are grouped by who can invoke them. User-invoked skills run only when requested by name. Model-invoked skills may also be selected automatically when their descriptions match the task.

### Engineering

**User-invoked**

- **[ask-matt](./skills/engineering/ask-matt/SKILL.md)**: Route a situation to the appropriate skill or flow.
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)**: Interview while refining domain language, `CONTEXT.md`, and ADRs.
- **[triage](./skills/engineering/triage/SKILL.md)**: Move issues through the repository's triage workflow.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)**: Find and examine codebase deepening opportunities.
- **[setup-matt-pocock-skills](./skills/engineering/setup-matt-pocock-skills/SKILL.md)**: Configure issue tracking, triage labels, and domain documentation for a project.
- **[to-spec](./skills/engineering/to-spec/SKILL.md)**: Turn the current conversation into a specification.
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)**: Break a plan or specification into tracer-bullet tickets.
- **[implement](./skills/engineering/implement/SKILL.md)**: Implement a specification or ticket set with TDD and review.
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)**: Map work too large for one agent session.

**Model-invoked**

- **[prototype](./skills/engineering/prototype/SKILL.md)**: Build a throwaway prototype to answer a design question.
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)**: Diagnose difficult bugs and performance regressions with a disciplined loop.
- **[research](./skills/engineering/research/SKILL.md)**: Research primary sources and save cited findings.
- **[tdd](./skills/engineering/tdd/SKILL.md)**: Apply red-green-refactor in vertical slices.
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)**: Build and maintain a project's domain model.
- **[choosing-clear-identifiers](./skills/engineering/choosing-clear-identifiers/SKILL.md)**: Choose and review identifiers for point-of-use clarity.
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)**: Design deep modules with small interfaces and clean seams.
- **[structuring-code-modules](./skills/engineering/structuring-code-modules/SKILL.md)**: Decide file, package, and module structure through an evidence-based package gate.
- **[code-review](./skills/engineering/code-review/SKILL.md)**: Review a diff against repository standards and its specification.
- **[resolving-merge-conflicts](./skills/engineering/resolving-merge-conflicts/SKILL.md)**: Resolve merge or rebase conflicts by tracing intent.
- **[wizard](./skills/engineering/wizard/SKILL.md)**: Generate an interactive shell wizard for required human steps.

### Productivity

**User-invoked**

- **[grill-me](./skills/productivity/grill-me/SKILL.md)**: Interview the user until a plan or decision is resolved.
- **[handoff](./skills/productivity/handoff/SKILL.md)**: Save a compact handoff for another agent session.
- **[teach](./skills/productivity/teach/SKILL.md)**: Teach a topic through a stateful multi-session workspace.
- **[to-questionnaire](./skills/productivity/to-questionnaire/SKILL.md)**: Create a questionnaire for the person who can answer a decision.
- **[wait-what](./skills/productivity/wait-what/SKILL.md)**: Re-explain a response with the missing context and simpler language.

**Model-invoked**

- **[grilling](./skills/productivity/grilling/SKILL.md)**: Reusable interview discipline for plans, decisions, and ideas.
- **[writing-for-agents](./skills/productivity/writing-for-agents/SKILL.md)**: Write effective agent-facing instruction documents and skills.

## Attribution and license

Most existing skills originated in [mattpocock/skills](https://github.com/mattpocock/skills). Local modifications and future personal skills are maintained in this fork. See [LICENSE](./LICENSE).
