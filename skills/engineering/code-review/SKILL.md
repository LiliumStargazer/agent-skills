---
name: code-review
description: "Review changes since a fixed point along two core axes: Standards (repository rules, personal engineering standards, and the Fowler smell baseline) and Spec (the originating issue/spec). When ponytail-review is available, add a separate over-engineering perspective. Run active reviews in parallel and report them separately. Use for branches, PRs, work-in-progress changes, or requests to review since a commit, branch, tag, or merge-base."
---

Review the diff between `HEAD` and a fixed point the user supplies along two core axes:

- **Standards**: does the code conform to this repo's documented coding standards, the personal engineering standards, and the Fowler smell baseline?
- **Spec**: does the code faithfully implement the originating issue / spec?

When a skill named `ponytail-review` is available, add a separate **Ponytail** perspective for unnecessary complexity and over-engineering. It is not part of the Standards axis.

All active reviews run as **parallel sub-agents** so they don't pollute each other's context, then this skill aggregates their findings without merging the perspectives.

The issue tracker should have been provided to you. If `docs/agents/issue-tracker.md` is missing, tell the user to run `/setup-matt-pocock-skills`.

## Process

### 1. Pin the fixed point

Whatever the user said is the fixed point (a commit SHA, branch name, tag, `main`, `HEAD~5`, etc.). If they didn't specify one, ask for it.

Capture the diff command once: `git diff <fixed-point>...HEAD` (three-dot, so the comparison is against the merge-base). Also note the list of commits via `git log <fixed-point>..HEAD --oneline`.

Before going further, confirm the fixed point resolves (`git rev-parse <fixed-point>`) and the diff is non-empty. A bad ref or empty diff should fail here, not inside two parallel sub-agents.

### 2. Identify the spec source

Look for the originating spec, in this order:

1. Issue references in the commit messages (`#123`, `Closes #45`, GitLab `!67`, etc.), fetched via the workflow in `docs/agents/issue-tracker.md`.
2. A path the user passed as an argument.
3. A spec file under `docs/`, `specs/`, or `.scratch/` matching the branch name or feature.
4. If nothing is found, ask the user where the spec is. If they say there isn't one, the **Spec** sub-agent will skip and report "no spec available".

### 3. Identify the standards sources

The Standards axis always uses three kinds of source:

- Anything in the repo that documents how code should be written, such as `CODING_STANDARDS.md` or `CONTRIBUTING.md`.
- The `choosing-clear-identifiers` and `structuring-code-modules` skills as personal engineering standards.
- The **smell baseline** below: a fixed set of Fowler code smells (_Refactoring_, ch.3) that applies even when a repo documents nothing.

The Standards sub-agent loads the two personal standards itself through the Skill tool, as specified in step 4. Apply them only to decisions represented by the reviewed diff:

- `choosing-clear-identifiers` governs identifiers introduced, renamed, or materially touched by the change.
- `structuring-code-modules` governs structural decisions only when the change creates, splits, moves, groups, or reorganizes modules, files, directories, or packages. It must not turn the review into a general restructuring pass.

Three rules bind these sources:

- **The repo overrides.** An explicit documented repo standard wins over a personal standard or baseline heuristic when they conflict. Suppress the conflicting generic finding.
- **The diff bounds the review.** Do not report pre-existing issues outside the diff or request unrelated refactoring solely to satisfy a standard.
- **Smells are judgement calls.** Each smell is a labelled heuristic ("possible Feature Envy"), never a hard violation. Like any standard here, skip anything tooling already enforces.

Each smell reads *what it is* → *how to fix*; match it against the diff:

- **Mysterious Name**: a function, variable, or type whose name doesn't reveal what it does or holds. → rename it; if no honest name comes, the design's murky.
- **Duplicated Code**: the same logic shape appears in more than one hunk or file in the change. → extract the shared shape, call it from both.
- **Feature Envy**: a method that reaches into another object's data more than its own. → move the method onto the data it envies.
- **Data Clumps**: the same few fields or params keep travelling together (a type wanting to be born). → bundle them into one type, pass that.
- **Primitive Obsession**: a primitive or string standing in for a domain concept that deserves its own type. → give the concept its own small type.
- **Repeated Switches**: the same `switch`/`if`-cascade on the same type recurs across the change. → replace with polymorphism, or one map both sites share.
- **Shotgun Surgery**: one logical change forces scattered edits across many files in the diff. → gather what changes together into one module.
- **Divergent Change**: one file or module is edited for several unrelated reasons. → split so each module changes for one reason.
- **Speculative Generality**: abstraction, parameters, or hooks added for needs the spec doesn't have. → delete it; inline back until a real need shows.
- **Message Chains**: long `a.b().c().d()` navigation the caller shouldn't depend on. → hide the walk behind one method on the first object.
- **Middle Man**: a class or function that mostly just delegates onward. → cut it, call the real target direct.
- **Refused Bequest**: a subclass or implementer that ignores or overrides most of what it inherits. → drop the inheritance, use composition.

### 4. Spawn the reviews in parallel

**Standards sub-agent prompt** should include:

- The full diff command and commit list.
- The list of standards-source files found in step 3, plus the smell baseline from step 3 pasted in full.
- This loading instruction: `Call the Skill tool twice, once with "choosing-clear-identifiers" and once with "structuring-code-modules". Treat the loaded skill bodies as normative sources for this Standards review.`
- The brief: "Review only the supplied diff. Report, per file/hunk where relevant: (a) violations of documented repository standards, citing the file and rule; (b) violations of choosing-clear-identifiers or structuring-code-modules, citing the skill and rule; and (c) baseline smells, naming the smell and quoting the hunk. Do not request unrelated refactoring or report pre-existing code outside the diff. Deduplicate findings where sources overlap. Distinguish hard violations from judgement calls: documented-standard breaches can be hard, baseline smells are always judgement calls, and an explicit repository standard overrides conflicting personal standards or baseline heuristics. Skip anything tooling already enforces. Under 400 words."

**Spec sub-agent prompt** should include:

- The diff command and commit list.
- The path or fetched contents of the spec.
- The brief: "Report: (a) requirements the spec asked for that are missing or partial; (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding. Under 400 words."

If the spec is missing, skip the Spec sub-agent and note this in the final report.

**Ponytail sub-agent prompt**, only when a skill whose declared name is `ponytail-review` appears in the available skills, should include:

- The full diff command and commit list.
- This loading instruction: `Call the Skill tool with "ponytail-review".`
- The brief: "Review only the supplied diff for unnecessary complexity, speculative abstractions, avoidable dependencies, removable code, and over-engineering. Stay within Ponytail's scope. Do not report correctness, security, performance, Standards, or Spec findings, and do not propose work outside the reviewed change. Do not modify the code."

If `ponytail-review` is unavailable, do not fail or attempt to install or initialize Ponytail. Continue with Standards and Spec, and note that the optional perspective was skipped.

### 5. Aggregate

Present the core reports under `## Standards` and `## Spec` headings, verbatim or lightly cleaned. When the Ponytail review ran, present it under a separate `## Ponytail` heading. When it was unavailable, note `Ponytail unavailable; optional perspective skipped.` after the core reports.

Do **not** merge or rerank findings across perspectives. Ponytail findings never move into Standards, even when they point at the same hunk.

End with a one-line summary: total findings per active perspective and the worst issue _within each one_ (if any). Preserve Ponytail's net line estimate when it provides one. Don't pick a single winner across perspectives.

## Why two core axes

A change can pass one core axis and fail the other:

- Code that follows every standard but implements the wrong thing → **Standards pass, Spec fail.**
- Code that does exactly what the issue asked but breaks the project's conventions → **Spec pass, Standards fail.**

Reporting them separately stops one axis from masking the other.

## Why Ponytail stays separate

Ponytail asks a different question: what complexity can be removed without losing the requested behavior? That is neither repository conformance nor spec fidelity. Keeping it as an optional perspective preserves the two-axis model and lets the review run unchanged when Ponytail is not installed.
