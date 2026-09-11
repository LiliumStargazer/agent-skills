---
name: structuring-code-modules
description: Use when creating, splitting, moving, grouping, or reviewing source files, directories, packages, or module interfaces during implementation or refactoring.
---

# Structuring Code Modules

Organize code around owned operational chains, using the smallest structure that improves locality and hides implementation behind an intentional interface.

Use `codebase-design` as the vocabulary layer for modules, interfaces, depth, seams, adapters, leverage, and locality. If it is not already in the current context, call the Skill tool with "codebase-design" before choosing a structure. Treat it as a reference, not a second restructuring pass: this skill owns the file and package decision.

## Process

1. Define the behavior and operational chain owned by the change. Keep unrelated chains outside the scope.
2. Inspect the current files, distant sections, callers, tests, dependencies, documented constraints, change hotspots, and private implementation access before choosing a structure.
3. Identify the interface callers and tests should depend on. Keep implementation details behind it.
4. Apply the package gate below. If every condition is not established, prefer one file or the existing layout.
5. Make the smallest structural change that improves depth, locality, navigability, or testability.
6. Update callers, tests, imports, diagnostics, evals, and documentation through the chosen interface. Remove replaced paths in the same change.
7. Validate behavior through the module interface and run the checks for the affected perimeter.

## Package gate

Create a subdirectory or package only when all of these are true:

1. One operational chain or deep module contains multiple cohesive implementation responsibilities, whether they currently live in one file or several files.
2. Understanding or changing that chain currently requires navigation across distant file sections or a flat sibling list. Evidence identifies the affected stages, dependencies, callers, tests, change hotspots, or private implementation access.
3. The package can expose an intentional interface smaller than the implementation surface it hides.
4. The move belongs to a concrete implementation or bounded refactor with behavior that can be validated, rather than aesthetic symmetry.

Prefer one file when it remains the clearest coherent module. File count, line count, package-per-function, package-per-noun, and generic `utils` or `helpers` buckets do not justify a package.

## Interface and dependency rules

- Make the module interface the surface used by both callers and tests.
- Make the module entry point, operational stages, and dependencies discoverable from the interface.
- Name internal files by cohesive responsibility.
- Keep internal files, helpers, ordering constraints, and dependency wiring out of the caller-facing interface.
- Production callers depend on the intentional interface, not on internal implementation files.
- Tests use the module interface, or a deliberate internal seam owned by the module.
- Diagnostic and eval callers that need stage-level control use an explicit diagnostic interface rather than accidental private imports.
- Accept dependencies at a deliberate seam when doing so improves testability or supports real variation.
- Introduce an adapter only when at least two real adapters occupy the seam.
- Replace an obsolete interface or path instead of layering a permanent compatibility facade over it. Use temporary compatibility only for an explicit migration.
- Keep dependency direction legible: callers depend on the interface, not on internal implementation files.

## New implementations

Start with the smallest coherent module. Add files and directories after real cohesive responsibilities exist and the operational chain and interface are concrete, not in anticipation of possible future growth. Co-locate files that must be understood and changed together; keep independently changing responsibilities separate.

## Refactors

Establish the current behavior and test surface before moving code. A structural refactor must improve at least one evidenced property, such as interface depth, locality, dependency direction, or testability, without changing behavior unless that behavior change is separately approved.

Keep the refactor within the owning scope. Move complete responsibilities rather than fragments, update every caller atomically, and delete obsolete imports, facades, files, configuration, tests, and documentation in the same change. State `nothing obsolete` when no replaced path exists.

## Completion criteria

The structure is complete when:

- the package gate justifies every new directory or package with evidence from a single-file monolith or multi-file cluster;
- a reader can locate the module entry point, operational stages, and dependencies starting from its interface;
- internal filenames communicate cohesive responsibilities;
- production callers use the intentional interface rather than internal files;
- tests use the module interface or a deliberate internal seam owned by the module;
- diagnostic and eval callers that need stage-level control use an explicit diagnostic interface rather than accidental private imports;
- implementation details remain internal;
- no speculative adapter, second implementation pipeline, or aesthetic reshuffle was introduced;
- replaced paths are removed atomically or governed by an explicit migration;
- affected tests, lint, and type checks pass.
