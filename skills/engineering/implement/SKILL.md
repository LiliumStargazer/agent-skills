---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /code-review to review the work, unless this implementation
was requested to address findings from a previous code review.

When addressing code-review findings:
- Fix all confirmed findings.
- Run the relevant targeted tests, typechecking, linting, and regression checks.
- Do not run /code-review again automatically.
- Only run another broad /code-review if the user explicitly requests it.

Commit your work to the current branch.
