#!/bin/sh
set -eu

MARKETPLACE_NAME="flowfield-cleves"
MARKETPLACE_SOURCE="${FLOWFIELD_MARKETPLACE_SOURCE:-flowfieldai/cleves-flowfield-plugin}"
PLUGIN_ID="cleves-flowfield@flowfield-cleves"
LEGACY_PLUGIN_ID="cleves-flowfield@flowfield-internal"
MCP_ID="plugin:cleves-flowfield:cleves-flowfield"
CLAUDE_BIN="${CLAUDE_BIN:-claude}"

say() {
  printf '%s\n' "$*"
}

fail() {
  printf 'Cleves Flowfield installer: %s\n' "$*" >&2
  exit 1
}

command -v "$CLAUDE_BIN" >/dev/null 2>&1 || fail "Claude Code is not installed or is not on PATH. Install it from https://claude.com/download and retry."

say "Cleves Flowfield: using $($CLAUDE_BIN --version)"

marketplaces="$($CLAUDE_BIN plugin marketplace list --json)"
if printf '%s\n' "$marketplaces" | grep -Eq '"name"[[:space:]]*:[[:space:]]*"flowfield-cleves"'; then
  say "Updating the Flowfield plugin source..."
  "$CLAUDE_BIN" plugin marketplace update "$MARKETPLACE_NAME"
else
  say "Adding the official Flowfield plugin source..."
  "$CLAUDE_BIN" plugin marketplace add "$MARKETPLACE_SOURCE" --scope user
fi

installed="$($CLAUDE_BIN plugin list --json)"
if printf '%s\n' "$installed" | grep -Eq "\"id\"[[:space:]]*:[[:space:]]*\"$LEGACY_PLUGIN_ID\""; then
  say "Disabling the older Cleves plugin entry to prevent duplicate MCP tools..."
  "$CLAUDE_BIN" plugin disable "$LEGACY_PLUGIN_ID" --scope user || fail "Could not disable the older $LEGACY_PLUGIN_ID entry. Disable it with /plugin and retry."
fi

installed="$($CLAUDE_BIN plugin list --json)"
if printf '%s\n' "$installed" | grep -Eq "\"id\"[[:space:]]*:[[:space:]]*\"$PLUGIN_ID\""; then
  say "Updating the Cleves Flowfield plugin..."
  "$CLAUDE_BIN" plugin update "$PLUGIN_ID" --scope user
else
  say "Installing the Cleves Flowfield plugin for this user..."
  "$CLAUDE_BIN" plugin install "$PLUGIN_ID" --scope user
fi

if [ "${FLOWFIELD_INSTALLER_SKIP_OAUTH:-0}" = "1" ]; then
  say "Skipping OAuth because FLOWFIELD_INSTALLER_SKIP_OAUTH=1."
else
  say "Opening Flowfield sign-in. Complete the approval in your browser; this installer never receives your password."
  if [ -t 1 ] && [ -r /dev/tty ]; then
    "$CLAUDE_BIN" mcp login "$MCP_ID" </dev/tty
  else
    "$CLAUDE_BIN" mcp login "$MCP_ID"
  fi
fi

status="$($CLAUDE_BIN mcp list 2>&1 || true)"
say "$status"

flowfield_status="$(printf '%s\n' "$status" | grep -F "$MCP_ID" || true)"
if [ "${FLOWFIELD_INSTALLER_SKIP_OAUTH:-0}" != "1" ] && printf '%s\n' "$flowfield_status" | grep -Eiq 'needs authentication|failed|error'; then
  fail "Flowfield is installed but authentication is not complete. Run: claude mcp login '$MCP_ID'"
fi

say ""
say "Cleves Flowfield installation completed."
say "If Claude Code is already open, run /reload-plugins. Otherwise start a new session."
say "Then ask your Cleves question or run /cleves-flowfield:setup-cleves to verify setup."
