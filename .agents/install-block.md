# The canonical install block

This repository is the canonical editable copy. `README.md` and active installation documentation must use these commands. Change them here first, then propagate them.

## New machine

Clone the repository once, then create global symlinks:

<canonical-block name="clone-and-link">

```bash
git clone git@github.com:LiliumStargazer/matt-skills.git
cd matt-skills
scripts/link-skills.sh
```

</canonical-block>

The script links promoted and in-progress skills into both `~/.claude/skills` and `~/.agents/skills`. Claude Code reads the first directory. Codex, Pi, and other Agent Skills-compatible harnesses read the second. `misc/` and `deprecated/` are intentionally excluded.

## Update

<canonical-block name="update-and-relink">

```bash
cd /path/to/matt-skills
git pull --ff-only
scripts/link-skills.sh
```

</canonical-block>

Existing symlinks see pulled changes immediately. Re-running the script discovers new skills and removes links for skills renamed or removed from this repository.

## Why symlinks

The repository remains the only editable source. There are no generated or copied skill trees to synchronize. Do not install this same set through another mechanism at the same time, because duplicate skill names can make harness discovery ambiguous.

Ponytail is distributed separately as a plugin and is not part of this installation.
