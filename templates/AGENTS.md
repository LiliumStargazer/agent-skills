# Agent instructions

## Workflow

1. **Analyze:** Check `git status`, then read the relevant implementation, tests, and documentation before changing anything.
2. **Implement:** Make the smallest change that satisfies the request. Keep the requested scope and avoid speculative abstractions.
3. **Test:** Run the relevant tests, lint checks, type checks, and other repository validators.
4. **Review:** Inspect the final diff for correctness, unintended changes, secrets, and missing validation.

## Safety and scope

- Preserve unrelated user changes. Do not overwrite, revert, or reformat them.
- Do not fix unrelated problems unless the user expands the scope.
- Never expose secrets, credentials, tokens, or private keys in output, logs, code, or commits.
- Do not push without explicit authorization.
- Do not rewrite Git history without explicit authorization.

## Engineering approach

- Prefer existing project patterns, standard library features, and native platform capabilities.
- Avoid overengineering, unnecessary dependencies, and abstractions for hypothetical future needs.

## Project-specific instructions

<!-- Add repository-specific architecture, commands, conventions, and constraints here. -->
