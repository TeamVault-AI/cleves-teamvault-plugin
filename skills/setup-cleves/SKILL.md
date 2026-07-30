---
name: setup-cleves
description: Install, update, authenticate, repair, or verify the Cleves TeamVault plugin and connector. Use immediately for first-time setup, OAuth login, "needs authentication", missing Cleves tools, a newly installed plugin, or a request to connect or test Cleves TeamVault.
---

# Set up Cleves TeamVault

Use only supported Claude plugin and MCP commands. Never edit
`installed_plugins.json`, Claude's plugin cache, OAuth token storage, or other
internal Claude files directly.

## Claude Code

1. Run `claude plugin list --json` and confirm an enabled
   `cleves-teamvault` plugin is installed. Prefer
   `cleves-teamvault@teamvault-cleves`. If only
   `cleves-teamvault@teamvault-internal` is enabled, direct the user to rerun
   the current public installer.
2. If the plugin was installed or updated during the current session, tell the
   user to run `/reload-plugins`. Slash commands are user-interface actions;
   do not claim to have run one from a shell.
3. Run `claude mcp list`. The expected connector identifier is
   `plugin:cleves-teamvault:cleves-teamvault`.
4. If it needs authentication, run the following command in an interactive
   terminal or PTY:

   ```bash
   claude mcp login 'plugin:cleves-teamvault:cleves-teamvault'
   ```

   Let Claude Code generate the one-time authorization URL and open the
   browser. Never hard-code an OAuth URL, request the user's password, paste a
   token into chat, or attempt to approve access for the user. If the browser
   cannot open, use `--no-browser`, show the generated URL to the user, and
   wait for the callback instructions.
5. After the user approves access, run `claude mcp list` again. If the current
   session still lacks the Cleves tools, ask the user to run
   `/reload-plugins` or start a new session.
6. Load the `analyzing-cleves` skill, obtain a live analytical preflight, and
   run one harmless saved query to verify the connector. Never bypass
   preflight.

## Cowork

Cowork does not use the Claude Code CLI installation flow. Confirm that the
user uploaded the public `.plugin` package in **Customize → Plugins → Add**.
Open the installed plugin's connector page and ask the user to click
**Connect** and approve TeamVault OAuth. Then obtain a live preflight and run
one harmless saved query.

## Completion report

Report the installed plugin version, enabled state, connector state, preflight
release, verification query, and any remaining user action. Do not say setup
is complete while OAuth or plugin reload is still pending.

