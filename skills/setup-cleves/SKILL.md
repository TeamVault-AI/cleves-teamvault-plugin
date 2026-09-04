---
name: setup-cleves
description: Install, update, authenticate, repair, or verify the Cleves Flowfield plugin and connector. Use for first-time setup, OAuth login, missing tools, a plugin update, or a request to connect or test Cleves Flowfield.
---

# Set up Cleves Flowfield

Use only supported Claude plugin and MCP commands. Never edit Claude's plugin
registry, cache, or OAuth token storage directly.

## Claude Code

1. Run `claude plugin list --json` and confirm that
   `cleves-teamvault@teamvault-cleves` is installed and enabled.
2. If the plugin was installed or updated in this session, tell the user to run
   `/reload-plugins` or begin a new session.
3. Run `claude mcp list`. The expected connector is
   `plugin:cleves-teamvault:cleves-teamvault` and its canonical endpoint is
   `https://cleves.flowfield.inc/mcp`.
4. If authentication is required, run:

   ```bash
   claude mcp login 'plugin:cleves-teamvault:cleves-teamvault'
   ```

   Let Claude generate the authorization URL. Never ask for a password or
   place an OAuth token in chat.
5. After approval, run `claude mcp list` again and verify the connector exposes
   exactly `hybrid_search` and `read_document`.
6. Run one harmless search and read the most relevant result to verify both
   operations and the signed-in user's access boundary.

## Claude Desktop, Cowork, and Chat

Confirm that the GitHub marketplace plugin is installed and updated. Open its
connector, choose **Connect**, and complete OAuth if prompted. Start a new
conversation after an update so Claude loads the new endpoint.

## Completion report

Report the installed version, enabled state, connector state, canonical URL,
two-tool contract, verification result, and any remaining user action.
