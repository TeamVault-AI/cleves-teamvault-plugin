#!/bin/sh
set -eu

MARKETPLACE_NAME="teamvault-cleves"
MARKETPLACE_SOURCE="${TEAMVAULT_MARKETPLACE_SOURCE:-TeamVault-AI/cleves-teamvault-plugin}"
PLUGIN_ID="cleves-teamvault@teamvault-cleves"
LEGACY_PLUGIN_ID="cleves-teamvault@teamvault-internal"
MCP_ID="plugin:cleves-teamvault:cleves-teamvault"
CLAUDE_BIN="${CLAUDE_BIN:-claude}"

say() {
  printf '%s\n' "$*"
}

fail() {
  printf 'Cleves TeamVault installer: %s\n' "$*" >&2
  exit 1
}

command -v "$CLAUDE_BIN" >/dev/null 2>&1 || fail "Claude Code is not installed or is not on PATH. Install it from https://claude.com/download and retry."

say "Cleves TeamVault: using $($CLAUDE_BIN --version)"

marketplaces="$($CLAUDE_BIN plugin marketplace list --json)"
if printf '%s\n' "$marketplaces" | grep -Eq '"name"[[:space:]]*:[[:space:]]*"teamvault-cleves"'; then
  say "Updating the TeamVault plugin source..."
  "$CLAUDE_BIN" plugin marketplace update "$MARKETPLACE_NAME"
else
  say "Adding the official TeamVault plugin source..."
  "$CLAUDE_BIN" plugin marketplace add "$MARKETPLACE_SOURCE" --scope user
fi

installed="$($CLAUDE_BIN plugin list --json)"
if printf '%s\n' "$installed" | grep -Eq "\"id\"[[:space:]]*:[[:space:]]*\"$LEGACY_PLUGIN_ID\""; then
  say "Disabling the older Cleves plugin entry to prevent duplicate MCP tools..."
  "$CLAUDE_BIN" plugin disable "$LEGACY_PLUGIN_ID" --scope user || fail "Could not disable the older $LEGACY_PLUGIN_ID entry. Disable it with /plugin and retry."
fi

installed="$($CLAUDE_BIN plugin list --json)"
if printf '%s\n' "$installed" | grep -Eq "\"id\"[[:space:]]*:[[:space:]]*\"$PLUGIN_ID\""; then
  say "Updating the Cleves TeamVault plugin..."
  "$CLAUDE_BIN" plugin update "$PLUGIN_ID" --scope user
else
  say "Installing the Cleves TeamVault plugin for this user..."
  "$CLAUDE_BIN" plugin install "$PLUGIN_ID" --scope user
fi

if [ "${TEAMVAULT_INSTALLER_SKIP_OAUTH:-0}" = "1" ]; then
  say "Skipping OAuth because TEAMVAULT_INSTALLER_SKIP_OAUTH=1."
else
  say "Opening TeamVault sign-in. Complete the approval in your browser; this installer never receives your password."
  if [ -t 1 ] && [ -r /dev/tty ]; then
    "$CLAUDE_BIN" mcp login "$MCP_ID" </dev/tty
  else
    "$CLAUDE_BIN" mcp login "$MCP_ID"
  fi
fi

status="$($CLAUDE_BIN mcp list 2>&1 || true)"
say "$status"

teamvault_status="$(printf '%s\n' "$status" | grep -F "$MCP_ID" || true)"
if [ "${TEAMVAULT_INSTALLER_SKIP_OAUTH:-0}" != "1" ] && printf '%s\n' "$teamvault_status" | grep -Eiq 'needs authentication|failed|error'; then
  fail "TeamVault is installed but authentication is not complete. Run: claude mcp login '$MCP_ID'"
fi

say ""
say "Cleves TeamVault installation completed."
say "If Claude Code is already open, run /reload-plugins. Otherwise start a new session."
say "Then ask your Cleves question or run /cleves-teamvault:setup-cleves to verify setup."
