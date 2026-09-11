## What it does

`choosing-clear-identifiers` chooses and reviews names for functions, values, types, modules, configuration, and tests. It aims for **point-of-use clarity**: a reader who knows the domain should understand the identifier where it appears without opening its definition to decode it.

It does not treat short names as automatically bad or rename everything it could improve. Existing names are classified as **Must rename**, **Should rename**, **Keep**, or **Contextual**, so a naming pass changes misleading names without creating cosmetic diff noise.

## When to reach for it

Type `/choosing-clear-identifiers`, or the [agent](https://www.aihero.dev/ai-coding-dictionary/agent) reaches for it automatically when a task introduces, renames, or reviews identifiers.

| The problem | Reach for |
| --- | --- |
| A function, variable, type, module, configuration key, or test needs an accurate name | `choosing-clear-identifiers` |
| The underlying domain term is missing, overloaded, or disputed | [domain-modeling](https://aihero.dev/skills-domain-modeling), then use the resolved term here |
| The module interface or seam is unclear | [codebase-design](https://aihero.dev/skills-codebase-design) |
| You want a whole diff checked against standards and its spec | [code-review](https://aihero.dev/skills-code-review), whose Mysterious Name check is broader and less detailed |

## Four audit outcomes

The classification keeps a naming review proportional to the problem:

| Outcome | Meaning |
| --- | --- |
| **Must rename** | The name is misleading, ambiguous, or conflicts with canonical domain vocabulary |
| **Should rename** | The name makes sense only after decoding implementation detail or local shorthand |
| **Keep** | The name is clear, accurate, and conventional for its context |
| **Contextual** | The complete scope is so small and visible that a brief name is clearer than an expansion |

Only the first two outcomes become rename work. The last two record that brevity and convention were evaluated rather than treated as defects.

## Stable boundaries

Public APIs, persisted fields, serialized values, configuration keys, generated names, and protocol-defined names are contracts. The skill preserves them unless a migration or breaking change is explicitly approved. Where translation already exists at a boundary, the external name stays at the boundary and the clearer name is used internally.

## Common questions

**Does this replace `domain-modeling`?**

No. `domain-modeling` decides what a concept is called across the domain. This skill applies that vocabulary to concrete identifiers and judges whether each name communicates its role at the point of use.

**Should every abbreviation be expanded?**

No. Canonical names such as `URL`, `HTTP`, `ID`, established algorithm names, and conventional notation can be clearer than their expanded forms. Local shorthand that a reader must decode should be expanded.

**Is every short variable name a problem?**

No. Minimal, immediately visible scope can make a short conventional name **Contextual**. The test is whether the reader can understand it at every use, not how many characters it has.

**Does the skill rename public APIs automatically?**

No. Public and persisted names are stable contracts. A rename happens only through an explicitly approved migration or breaking change.

## It's working if

- A reader can explain a new identifier from its use without opening its definition.
- Predicates read as propositions and side-effecting functions expose the relevant effect.
- Collections, units, opposing concepts, and test conditions are named consistently.
- The review keeps clear short names instead of expanding them mechanically.
- Contract renames are separated from safe internal renames.

## Where it fits

`choosing-clear-identifiers` is a **reach-for-it-anytime standalone** and a model-invoked discipline beneath implementation and review. Its closest neighbours are [domain-modeling](https://aihero.dev/skills-domain-modeling), which owns canonical domain vocabulary, and [code-review](https://aihero.dev/skills-code-review), which can surface mysterious names while reviewing a complete diff. When you are unsure which skill or flow fits, [ask-matt](https://aihero.dev/skills-ask-matt) routes you.
