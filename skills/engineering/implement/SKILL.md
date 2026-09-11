---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

## Engineering constraints

At the start, call the Skill tool twice, once with "choosing-clear-identifiers" and once with "structuring-code-modules". Apply them as constraints on the requested implementation, not as invitations to broaden it:

- Use `choosing-clear-identifiers` for naming decisions introduced by the work.
- Use `structuring-code-modules` only when the work creates, splits, moves, groups, or reorganizes modules, files, directories, or packages. Loading it does not require a restructuring pass.
- Do not change unrelated code solely to satisfy either standard.

Use Ponytail during implementation when it is available:

- If Ponytail is already active through native hooks, a plugin, or the current instructions, apply its current mode without invoking or initializing it again.
- If it is not already active, is not explicitly off, and a skill named `ponytail` is available, call the Skill tool with "ponytail" once.
- If Ponytail is unavailable or explicitly off, continue normally.

Do not install, configure, or add hooks for Ponytail from this workflow. Ponytail owns its own activation lifecycle.

Call the Skill tool with "tdd" where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, call the Skill tool with "code-review" to review the work, unless this implementation was requested to address findings from a previous code review.

When addressing code-review findings:
- Fix all confirmed findings.
- Run the relevant targeted tests, typechecking, linting, and regression checks.
- Do not call the Skill tool with "code-review" again automatically.
- Only run another broad code review if the user explicitly requests it.

Commit your work to the current branch.
