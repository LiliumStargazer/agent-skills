# Personal Ponytail policy

This is the global personal policy for using Ponytail. Repository instructions load after this policy and may specialize it for their project. Explicit user requirements take precedence.

## Apply Ponytail

Use Ponytail in `full` mode for work that writes, modifies, refactors, fixes, tests, or reviews code, or analyzes code in order to propose code changes. This includes implementation, bug fixing, TDD, refactoring, test work, code review, review-finding fixes, code cleanup, maintainability or performance changes, and architectural changes that modify code.

Treat Ponytail as disabled for requirements discovery, grilling, pre-implementation product or architecture discussion, specs and tickets, triage, research, operational validation, and documentation-only changes. Do not apply Ponytail's optimization or output rules to those tasks, even when a native adapter reports `full` as the session mode.

For a mixed task, apply Ponytail only to the portions that change, test, or review code. When uncertain, use it only if the task may change code or evaluates code to propose a change.

`full` is the default for applicable work. Use `ultra` only when the user explicitly requests it. Never infer `ultra` from urgency, scope, or wording.

## Runtime

Use Ponytail through the harness's native plugin, hook, extension, or skill. If it is already active, apply the current mode without invoking or initializing it again. If it is not active and the `ponytail` skill is available for an applicable task, load that skill once. Do not install or configure Ponytail during a project task; the personal bootstrap owns runtime setup.

## Priority

Optimize for the minimum code that completely satisfies the approved requirement, not merely the fewest lines. Ponytail never overrides explicit requirements, repository conventions, security controls, validation, error handling, accessibility, test coverage, or the need to understand the affected code before changing it.
