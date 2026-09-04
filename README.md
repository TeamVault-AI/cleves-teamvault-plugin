# Cleves Flowfield plugin

Official Claude plugin for Cleves' Flowfield knowledge connector.

The plugin connects Claude to `https://cleves.flowfield.inc/mcp`. It contains
no customer data, passwords, tokens, or shared credentials. Each Cleves user
signs in through Flowfield OAuth and receives their server-enforced access.

The connector intentionally exposes exactly two read-only tools:

- `hybrid_search`
- `read_document`

## Install or update

The public marketplace is `TeamVault-AI/cleves-teamvault-plugin`. Existing
users can update the marketplace/plugin from **Customize → Plugins**. In Claude
Code, rerun `install-claude-code.sh`, then start a new session or run
`/reload-plugins`.

After updating, connect when prompted and test with:

> Use Cleves Flowfield to search for Cleves information, read the most relevant
> result, and confirm that the connector exposes only hybrid_search and
> read_document.

## Updates

Server-side ingestion, retrieval, identity, ACL, and tool-description changes
take effect immediately. Changes to the connector URL or local guidance ship
through a versioned marketplace release. The former
`https://cleves.teamvault.ai/mcp` endpoint remains available during this
hostname migration so users on the previous plugin version are not interrupted.

## Security

- The package contains no secrets or customer content.
- OAuth and ACL enforcement remain server-side.
- Both connector operations are read-only.

Copyright Flowfield. All rights reserved.
