# The canonical install block

This repository is the canonical editable copy. `README.md` and active installation documentation must use these commands. Change them here first, then propagate them.

## New machine

Clone the repository once, then create global symlinks:

<canonical-block name="clone-and-link">

```bash
git clone git@github.com:LiliumStargazer/agent-skills.git
cd agent-skills
scripts/link-skills.sh

# Install Ponytail's native runtime once in each harness you use.
claude plugin marketplace add DietrichGebert/ponytail
claude plugin install ponytail@ponytail
codex plugin marketplace add DietrichGebert/ponytail
codex plugin add ponytail@ponytail
pi install npm:@dietrichgebert/ponytail
```

</canonical-block>

The script links promoted and in-progress skills into both `~/.claude/skills` and `~/.agents/skills`. Claude Code reads the first directory. Codex, Pi, and other Agent Skills-compatible harnesses read the second. `misc/` and `deprecated/` are intentionally excluded.

It also links the canonical Ponytail policy into the supported global instruction location for Claude Code, Codex, Pi's default agent directory, and the active `PI_CODING_AGENT_DIR` when set. It sets Ponytail's shared native default to `full` without copying or reimplementing the runtime hooks. Run the script once per non-default Pi profile so each profile receives its `AGENTS.md` adapter.

## Update

<canonical-block name="update-and-relink">

```bash
cd /path/to/agent-skills
git pull --ff-only
scripts/link-skills.sh
```

</canonical-block>

Existing skill and policy symlinks see pulled changes immediately. Re-running the script discovers new skills, removes links for skills renamed or removed from this repository, and restores Ponytail's `full` default.

## Why symlinks

The repository remains the only editable source. There are no generated or copied skill trees to synchronize. Do not install this same set through another mechanism at the same time, because duplicate skill names can make harness discovery ambiguous.

Ponytail's runtime is distributed separately through each harness's native plugin or package mechanism. Its personal activation policy is canonical in this repository.
