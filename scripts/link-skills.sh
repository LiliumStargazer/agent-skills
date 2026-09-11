#!/usr/bin/env bash
set -euo pipefail

# Links this repository's daily-driver skills into the global directories used
# by Claude Code, Codex, Pi, and other Agent Skills-compatible harnesses. Each
# entry remains a symlink into this repository, so there is one canonical copy.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS="$REPO/skills"
POLICY="$REPO/policies/ponytail.md"
SKILL_DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills")
DEFAULT_PI_AGENT_DIR="$HOME/.pi/agent"
ACTIVE_PI_AGENT_DIR="${PI_CODING_AGENT_DIR:-$DEFAULT_PI_AGENT_DIR}"
POLICY_DESTS=(
  "$HOME/.claude/CLAUDE.md"
  "${CODEX_HOME:-$HOME/.codex}/AGENTS.md"
  "$DEFAULT_PI_AGENT_DIR/AGENTS.md"
)
if [ "$ACTIVE_PI_AGENT_DIR" != "$DEFAULT_PI_AGENT_DIR" ]; then
  POLICY_DESTS+=("$ACTIVE_PI_AGENT_DIR/AGENTS.md")
fi
PONYTAIL_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/ponytail/config.json"

if [ ! -d "$SKILLS" ]; then
  echo "error: skill directory not found: $SKILLS" >&2
  exit 1
fi
if [ ! -f "$POLICY" ]; then
  echo "error: global policy not found: $POLICY" >&2
  exit 1
fi
if ! command -v node >/dev/null 2>&1; then
  echo "error: node is required to preserve and update Ponytail's config" >&2
  exit 1
fi

# Promoted and in-progress skills are linked for daily use and beta feedback.
# Retired deprecated skills and rarely used misc skills stay out of the global
# directories.
names=()
srcs=()
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  names+=("$(basename "$src")")
  srcs+=("$src")
done < <(find "$SKILLS" -name SKILL.md -not -path '*/node_modules/*' -not -path '*/deprecated/*' -not -path '*/misc/*' -print0)

if [ "${#names[@]}" -eq 0 ]; then
  echo "error: no skills found under $SKILLS" >&2
  exit 1
fi

duplicates="$(printf '%s\n' "${names[@]}" | sort | uniq -d)"
if [ -n "$duplicates" ]; then
  echo "error: duplicate skill names cannot share a global skill directory:" >&2
  printf '  %s\n' $duplicates >&2
  exit 1
fi

# Validate every destination and collision before changing anything.
conflicts=0
for DEST in "${SKILL_DESTS[@]}"; do
  if [ -L "$DEST" ]; then
    if [ ! -d "$DEST" ]; then
      echo "error: destination is a broken symlink: $DEST" >&2
      conflicts=1
      continue
    fi

    resolved="$(cd "$DEST" && pwd -P)"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        echo "error: $DEST resolves into this repository ($resolved)." >&2
        conflicts=1
        continue
        ;;
    esac
  elif [ -e "$DEST" ] && [ ! -d "$DEST" ]; then
    echo "error: destination exists and is not a directory: $DEST" >&2
    conflicts=1
    continue
  fi

  for i in "${!names[@]}"; do
    target="$DEST/${names[$i]}"
    src="${srcs[$i]}"

    if [ -L "$target" ]; then
      if [ "$(readlink "$target")" != "$src" ]; then
        echo "error: refusing to replace symlink owned by another installation: $target" >&2
        conflicts=1
      fi
    elif [ -e "$target" ]; then
      echo "error: refusing to replace existing path: $target" >&2
      conflicts=1
    fi
  done
done

for target in "${POLICY_DESTS[@]}"; do
  if [ -L "$target" ]; then
    if [ "$(readlink "$target")" != "$POLICY" ]; then
      echo "error: refusing to replace policy symlink owned by another source: $target" >&2
      conflicts=1
    fi
  elif [ -e "$target" ] && { [ ! -f "$target" ] || [ -s "$target" ]; }; then
    echo "error: refusing to replace non-empty global instructions: $target" >&2
    conflicts=1
  fi
done

if [ -e "$PONYTAIL_CONFIG" ] && [ ! -f "$PONYTAIL_CONFIG" ]; then
  echo "error: Ponytail config path is not a file: $PONYTAIL_CONFIG" >&2
  conflicts=1
elif [ -f "$PONYTAIL_CONFIG" ] && ! node -e 'JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"))' "$PONYTAIL_CONFIG"; then
  echo "error: refusing to replace invalid Ponytail config: $PONYTAIL_CONFIG" >&2
  conflicts=1
fi

if [ "$conflicts" -ne 0 ]; then
  exit 1
fi

node - "$PONYTAIL_CONFIG" <<'NODE'
const fs = require("fs");
const path = require("path");
const configPath = process.argv[2];
const config = fs.existsSync(configPath)
  ? JSON.parse(fs.readFileSync(configPath, "utf8"))
  : {};
config.defaultMode = "full";
fs.mkdirSync(path.dirname(configPath), { recursive: true });
fs.writeFileSync(configPath, `${JSON.stringify(config, null, 2)}\n`);
NODE
echo "configured Ponytail default mode -> full ($PONYTAIL_CONFIG)"

for DEST in "${SKILL_DESTS[@]}"; do
  mkdir -p "$DEST"

  # Remove links created by this repository for skills that were later renamed
  # or removed. Links to any other source are left untouched.
  for target in "$DEST"/*; do
    [ -L "$target" ] || continue
    linked="$(readlink "$target")"
    case "$linked" in
      "$SKILLS"/*)
        current=0
        for src in "${srcs[@]}"; do
          if [ "$linked" = "$src" ]; then
            current=1
            break
          fi
        done
        if [ "$current" -eq 0 ]; then
          rm "$target"
          echo "removed stale link $target"
        fi
        ;;
    esac
  done

  for i in "${!names[@]}"; do
    name="${names[$i]}"
    src="${srcs[$i]}"
    target="$DEST/$name"

    if [ -L "$target" ]; then
      echo "already linked $name -> $src ($DEST)"
    else
      ln -s "$src" "$target"
      echo "linked $name -> $src ($DEST)"
    fi
  done
done

for target in "${POLICY_DESTS[@]}"; do
  mkdir -p "$(dirname "$target")"
  if [ -L "$target" ]; then
    echo "already linked global policy -> $POLICY ($target)"
  else
    [ -e "$target" ] && rm "$target"
    ln -s "$POLICY" "$target"
    echo "linked global policy -> $POLICY ($target)"
  fi
done
