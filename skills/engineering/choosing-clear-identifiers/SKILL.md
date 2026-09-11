---
name: choosing-clear-identifiers
description: Use when introducing, renaming, or reviewing functions, variables, parameters, types, constants, modules, fields, configuration keys, or test names.
---

# Choosing Clear Identifiers

Choose names that let a reader who knows the domain understand an identifier at its point of use without opening its definition to decode it.

## Process

1. Identify the concept, behavior, result, or effect being named. If that responsibility is unclear, clarify the design before naming it.
2. Use the canonical vocabulary from the domain glossary or authoritative domain documentation. When terminology is missing or conflicting rather than merely being consumed, call the Skill tool with "domain-modeling" to resolve it instead of inventing a local synonym.
3. Check the candidate against every rule below that applies.
4. Review all identifiers introduced or renamed by the change. A name is complete when it communicates its role, distinguishes nearby concepts, and remains accurate if internals change without changing behavior.

## Rules

### Functions and methods

- Use a precise verb and object that describe observable behavior or the returned result: `load_cases`, `verify_session_token`.
- Name predicates as propositions such as `is_compatible`, `has_sources`, or `can_retry`.
- Expose a relevant side effect in the name, such as `persist_feedback` or `send_digest`.
- Qualify broad verbs such as `run`, `process`, `handle`, `manage`, or `update` with the specific operation and object.
- Name behavior rather than the current algorithm, library, or storage mechanism.

### Values, parameters, fields, and constants

- Name the domain meaning rather than only the data structure or generic role. Qualify words such as `data`, `item`, `value`, `result`, and `record` with the concept they represent.
- Use plural nouns for collections and singular nouns for one value.
- Include units where the type does not make them unambiguous: `timeout_seconds`, `size_bytes`.
- Phrase booleans as propositions whose truth value reads naturally.
- Give related and opposing concepts parallel names.
- Let scope justify brevity only when the meaning is immediate at every use.

### Types, modules, configuration, and tests

- Name classes and types with nouns representing the concept they model, not the operation that happened to create them.
- Name modules and files for their cohesive responsibility.
- Name configuration keys for the controlled behavior and include units where applicable.
- Name tests for the behavior and condition they establish, not for an internal method or ticket number alone.

### Abbreviations

Use an abbreviation when it is the canonical and more recognizable name for the concept in the relevant domain or technology. Use the full word for local shorthand that a reader must decode.

Examples such as `URL`, `HTTP`, `ID`, or a canonical algorithm name illustrate the test; they are not a fixed allowlist. Mathematical notation and loop indices may stay short when their conventional meaning and minimal scope make them clearer than an expansion.

### Boundaries and generated names

Preserve names imposed by external protocols, frameworks, serialized contracts, or generated code. Keep the external name at the boundary and use a clearer internal name when translation is already part of that boundary.

### Stability during refactoring

Treat public APIs, persisted fields, configuration keys, and external contracts as stable. Rename one only through an explicitly approved migration or breaking change.

Rename private identifiers when the existing name is misleading or forces readers to decode it. Keep unrelated names stable so a focused refactor does not accumulate cosmetic diff noise.

## Audit classification

Classify existing identifiers before planning a naming refactor:

- **Must rename**: misleading, ambiguous, or inconsistent with canonical domain vocabulary.
- **Should rename**: understandable only after decoding the implementation or local shorthand.
- **Keep**: clear, accurate, and appropriately conventional.
- **Contextual**: clear because its complete scope is minimal and immediately visible.

Plan changes for **Must rename** and **Should rename** findings. Retain **Keep** and **Contextual** findings as audit evidence that brevity alone was not treated as a defect. Separate internal renames from contract migrations, preserve behavior, and require the existing tests and checks for the affected perimeter to remain green.
