#!/usr/bin/env bash
# Create a new overlay repo with the expected layout.
# Usage: ./overlay/unfold.sh <name> [target-dir]
#   name       overlay name (e.g. work, contracting)
#   target-dir where to create the new repo (default: ../.dotfiles-overlay-<name>, hidden)
# Run from the dotfiles repo root (~/.dotfiles).

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
  echo "Usage: $0 <name> [target-dir]"
  echo "  name       overlay name (e.g. work)"
  echo "  target-dir where to create the new repo (default: ../.dotfiles-overlay-<name>)"
  exit 1
}

NAME="${1:?$(usage)}"
TARGET="${2:-$(dirname "$DOTFILES_ROOT")/.dotfiles-overlay-$NAME}"

if [[ -d "$TARGET" ]] && [[ -n "$(ls -A "$TARGET" 2>/dev/null)" ]]; then
  echo "Error: target already exists and is non-empty: $TARGET" >&2
  exit 1
fi

mkdir -p "$TARGET/.bash_aliases" "$TARGET/.bash_scripts" "$TARGET/.local/bin"

cat > "$TARGET/.bash_aliases/example" << 'EOF'
# Example alias group. Rename this file (e.g. to "work") and add your aliases.
# Both bash and zsh source every file in ~/.bash_aliases/

# alias deploy='./scripts/deploy.sh'
# alias logs='kubectl logs -f'
EOF

cat > "$TARGET/.bash_scripts/example.sh" << 'EOF'
# Example script. Rename or add more .sh files; both shells source ~/.bash_scripts/*.sh
# Use for: env vars, functions, work-specific PATH additions.

# export WORK_API_KEY="${WORK_API_KEY:-}"
# export PATH="$HOME/.local/share/work-tools:$PATH"
EOF

touch "$TARGET/.local/bin/.gitkeep"

cat > "$TARGET/README.md" << EOF
# Overlay: $NAME

Layout mirrors \$HOME. Stow from the main dotfiles repo:

- **.bash_aliases/** – sourced by both shells (one file per group).
- **.bash_scripts/** – \*.sh sourced by both shells (env, functions).
- **.local/bin/** – optional scripts; on PATH if main dotfiles add ~/.local/bin.

After pushing, add as submodule: \`git submodule add <url> overlay/$NAME\` then \`./install.sh\`.
EOF

(cd "$TARGET" && git init)

echo ""
echo "Created overlay repo at: $TARGET"
echo ""
echo "Next steps:"
echo "  1. cd $TARGET"
echo "  2. Edit .bash_aliases/ and .bash_scripts/, add your config"
echo "  3. git add . && git commit -m 'Initial overlay'"
echo "  4. Create a remote repo, then: git remote add origin <url> && git push -u origin main"
echo "  5. In ~/.dotfiles run: git submodule add <url> overlay/$NAME && ./install.sh"
echo ""
