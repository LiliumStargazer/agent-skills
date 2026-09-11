## What it does

`structuring-code-modules` decides whether code should remain in one file, split into cohesive files, or become a package with an intentional interface. It organizes around an owned operational chain and makes the smallest structural change that improves locality, navigability, dependency direction, or testability.

A package is not the default. The **package gate** requires evidence that multiple cohesive responsibilities belong together, the current layout creates navigation friction, a smaller interface can hide the implementation, and the move serves concrete work rather than visual symmetry.

## When to reach for it

Type `/structuring-code-modules`, or the [agent](https://www.aihero.dev/ai-coding-dictionary/agent) reaches for it automatically while creating, splitting, moving, grouping, or reviewing source files, directories, packages, or module interfaces.

| The problem | Reach for |
| --- | --- |
| Decide whether implementation belongs in one file, several files, or a package | `structuring-code-modules` |
| Design the module's interface, depth, or seam | [codebase-design](https://aihero.dev/skills-codebase-design), whose vocabulary this skill applies |
| Discover which parts of a whole codebase need structural improvement | [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) |
| Review the resulting diff against repository standards and its spec | [code-review](https://aihero.dev/skills-code-review) |

## The package gate

A new directory or package is justified only when every condition holds:

1. One operational chain or deep module contains multiple cohesive implementation responsibilities.
2. The current file or flat cluster creates evidenced navigation or change friction.
3. The package can expose an intentional interface smaller than the implementation it hides.
4. The move belongs to a concrete implementation or bounded refactor whose behavior can be validated.

File count, line count, nouns in the domain, and a desire for symmetry do not pass the gate. One file remains correct when it is the clearest coherent module.

## One design pass, two responsibilities

[Codebase-design](https://aihero.dev/skills-codebase-design) owns the shared vocabulary and principles: module, interface, depth, seam, adapter, leverage, and locality. `structuring-code-modules` consumes that reference and owns the operational decision about files, directories, entry points, and package boundaries.

The composition is one-way. This skill may load `codebase-design` once as a reference; `codebase-design` does not call back into this skill, and it does not run a second restructuring pass.

## Common questions

**Is file structure the same thing as deep-module design?**

No. A deep module is defined by leverage at its interface, not by a filesystem pattern. A good directory can make that interface and its implementation easier to navigate, but the same tree can contain either deep or shallow modules. This skill does not prescribe a universal tree.

**When should one file become a package?**

Only when all four package-gate conditions are established. A large file can remain coherent, and several small files can still deserve one package when they implement one operational chain behind a smaller interface.

**Should tests import internal files for convenience?**

Normally no. Callers and tests should use the intentional module interface. A test reaches inside only through a deliberate internal seam owned by the module, not an accidental private import.

**Should I add an adapter while splitting the code?**

Only when at least two real adapters occupy the seam. One implementation does not justify speculative indirection.

## It's working if

- Every new package passes all four parts of the package gate.
- A reader can find the entry point, operational stages, and dependencies from the interface.
- Callers and tests stop depending on accidental internal paths.
- Files that must be understood and changed together remain local to each other.
- The change removes replaced paths rather than layering a permanent compatibility facade over them.
- No package, adapter, or directory exists only for anticipated growth or symmetry.

## Where it fits

`structuring-code-modules` is a **model-invoked implementation discipline** applied while code is being created or reorganized. It consumes [codebase-design](https://aihero.dev/skills-codebase-design) for module vocabulary, while [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) is the periodic survey that finds broader deepening candidates. [Code-review](https://aihero.dev/skills-code-review) checks the resulting diff after the structural work. When you are unsure which skill or flow fits, [ask-matt](https://aihero.dev/skills-ask-matt) routes you.
