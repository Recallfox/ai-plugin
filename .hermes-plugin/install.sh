#!/usr/bin/env bash
# Install or update the recallfox Hermes adapter while keeping shared skills
# in the repository checkout beside the other agent manifests.
set -euo pipefail

REPO_URL="${RECALLFOX_PLUGIN_REPO_URL:-https://github.com/Recallfox/ai-plugin.git}"
HERMES_ROOT="${HERMES_HOME:-$HOME/.hermes}"
REPO_DIR="$HERMES_ROOT/repos/recallfox-ai-plugin"
PLUGIN_LINK="$HERMES_ROOT/plugins/recallfox"

mkdir -p "$(dirname "$REPO_DIR")" "$(dirname "$PLUGIN_LINK")"

if [ -d "$REPO_DIR/.git" ]; then
  echo "Updating existing checkout at $REPO_DIR"
  git -C "$REPO_DIR" pull --ff-only
else
  echo "Cloning $REPO_URL to $REPO_DIR"
  git clone --depth=1 "$REPO_URL" "$REPO_DIR"
fi

# Refresh only an installer-owned symlink; never replace a real user directory.
if [ -L "$PLUGIN_LINK" ]; then
  rm "$PLUGIN_LINK"
elif [ -e "$PLUGIN_LINK" ]; then
  echo "$PLUGIN_LINK exists and is not a symlink. Move or remove it, then re-run." >&2
  exit 1
fi

ln -s "$REPO_DIR/.hermes-plugin" "$PLUGIN_LINK"

echo "Installed the recallfox Hermes plugin."
echo "Enable it with: hermes plugins enable recallfox"
echo "Then add the OAuth MCP connection; see $REPO_DIR/.hermes-plugin/README.md"

