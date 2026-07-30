# Cleves TeamVault plugin

Publicly downloadable Claude Cowork and Claude Code plugin for the Cleves TeamVault graph and governed analytics warehouse.

The plugin connects to the hosted TeamVault MCP at `https://graph.cleves.teamvault.ai/mcp`. It contains no customer data or credentials. Access is granted through TeamVault OAuth.

## Fastest Cowork setup

You do **not** need to add this repository as a marketplace or connect GitHub.

1. [Download `cleves-teamvault-v0.1.1.plugin`](https://github.com/TeamVault-AI/cleves-teamvault-plugin/releases/download/v0.1.1/cleves-teamvault-v0.1.1.plugin).
2. In Claude Desktop, open **Cowork** → **Customize** → **Plugins** → **Add**.
3. Choose the downloaded `.plugin` file and approve installation.
4. Open the installed **Cleves TeamVault** plugin, connect its TeamVault connector, and approve OAuth in the browser.

No GitHub account is required. Claude requires the user to confirm installation and TeamVault OAuth; those security confirmations cannot be bypassed by a prompt.

## Post-install setup and test

After installation and OAuth, paste this into a new Cowork task:

> Finish setting up the installed Cleves TeamVault plugin. Confirm that all of its skills, hooks, and the Cleves TeamVault connector are enabled. Do not modify or uninstall any other plugins, skills, connectors, or Claude settings. Obtain the live Cleves analytics preflight, report the current warehouse release, list the governed Amazon Ads relations, run one harmless saved query, and confirm that an analytics query without a valid preflight receipt is rejected. Report exactly what is enabled and whether every check passed.

## Release package

The latest versioned package and checksum are attached to the [GitHub release](https://github.com/TeamVault-AI/cleves-teamvault-plugin/releases/tag/v0.1.1). Install only packages published by the `TeamVault-AI` organization.

SHA-256 for both the `.plugin` and `.zip` release assets:

```text
37ffbb9ab0be0f0f0a354fa1b46f41790e7a59fc7d91b1e92f3923e4c3fb7627
```

## What is dynamic

The plugin intentionally does not embed the warehouse schema, saved-query catalog, coverage, mappings, or current data-quality state. Claude must obtain those from the server's signed analytical preflight before querying. This allows TeamVault to update the warehouse without distributing a new plugin.

## Security

- The connector uses the public hosted TeamVault MCP; the private warehouse is not exposed directly.
- TeamVault OAuth determines the caller's access.
- The local hook enforces the required preflight sequence structurally.
- The server independently validates the receipt, caller, goal, release, and expiration before executing warehouse queries.
- The plugin contains no passwords, API tokens, customer records, or warehouse extracts.

Copyright TeamVault. All rights reserved.
