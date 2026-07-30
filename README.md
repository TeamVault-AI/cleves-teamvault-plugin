# Cleves TeamVault plugin

Private Claude Cowork and Claude Code plugin for the Cleves TeamVault graph and governed analytics warehouse.

The plugin connects to the hosted TeamVault MCP at `https://graph.cleves.teamvault.ai/mcp`. It contains no customer data or credentials. Access is granted through TeamVault OAuth.

## One-prompt Cowork setup

Paste this into a new Claude Cowork task:

> Set up the Cleves TeamVault plugin from the private GitHub marketplace at `https://github.com/TeamVault-AI/cleves-teamvault-plugin`. Add that repository as a plugin marketplace, install the `cleves-teamvault` plugin, and enable all of its skills, hooks, and the Cleves TeamVault connector. When Claude asks for installation or TeamVault OAuth approval, pause so I can approve it; never request or handle my password. Do not modify or uninstall any other plugins, skills, connectors, or Claude settings. After installation, start a clean task, obtain the live Cleves analytics preflight, report the current warehouse release, list the governed Amazon Ads relations, run one harmless saved query, and confirm that an analytics query without a valid preflight receipt is rejected. Report exactly what was installed and whether every check passed.

Claude may require the user to confirm the plugin installation and complete TeamVault OAuth. Those security confirmations cannot be bypassed.

## Manual fallback

In Claude Desktop, open `Cowork` → `Customize` → `Plugins` → `Add marketplace`, enter:

```text
https://github.com/TeamVault-AI/cleves-teamvault-plugin
```

Then install **Cleves TeamVault** and authorize its connector.

## Release package

The latest versioned package and checksum are attached to the GitHub release. Install only packages published by the `TeamVault-AI` organization and verify the checksum before sideloading.

## What is dynamic

The plugin intentionally does not embed the warehouse schema, saved-query catalog, coverage, mappings, or current data-quality state. Claude must obtain those from the server's signed analytical preflight before querying. This allows TeamVault to update the warehouse without distributing a new plugin.

## Security

- The connector uses the public hosted TeamVault MCP; the private warehouse is not exposed directly.
- TeamVault OAuth determines the caller's access.
- The local hook enforces the required preflight sequence structurally.
- The server independently validates the receipt, caller, goal, release, and expiration before executing warehouse queries.
- The plugin contains no passwords, API tokens, customer records, or warehouse extracts.

Copyright TeamVault. All rights reserved.
