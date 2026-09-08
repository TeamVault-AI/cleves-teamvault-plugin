# Cleves Flowfield plugin

Official Claude plugin for Cleves' Flowfield knowledge connector.

The plugin connects Claude to `https://cleves.flowfield.inc/mcp`. It contains
no customer data, passwords, tokens, or shared credentials. Each Cleves user
signs in through Flowfield OAuth and receives their server-enforced access.

The connector intentionally exposes three read-only tools:

- `hybrid_search`
- `read_document`
- the connector's advertised analytics tool

## Install or update

The public marketplace is `flowfieldai/cleves-flowfield-plugin`. Existing
users can update the marketplace/plugin from **Customize → Plugins**. In Claude
Code, rerun `install-claude-code.sh`, then start a new session or run
`/reload-plugins`.

After updating, connect when prompted and test with:

> Use Cleves Flowfield to search for Cleves information, read the most relevant
> result, and confirm that the connector exposes hybrid_search, read_document, and the advertised analytics tool.

## Updates

Server-side ingestion, retrieval, identity, ACL, and tool-description changes
take effect immediately. Changes to the connector URL or local guidance ship
through a versioned marketplace release. Use the canonical MCP URL for all new connections.

## Repair a registration error

Update to **0.2.0** in your installed marketplace/plugin, then restart Claude
or start a fresh session and reconnect. Confirm the URL is
`https://cleves.flowfield.inc/mcp`. Do not enter a manual OAuth client ID.
Sign in with your authorized Google account. Old graph-host configurations
are retired; the dashboard URL's legacy OAuth discovery can fail even while
an already-authenticated MCP call works. Use the canonical URL for reconnects.
If updating is unavailable, add a plain connector with the canonical URL.

## Security

- The package contains no secrets or customer content.
- OAuth and ACL enforcement remain server-side.
- All connector operations are read-only.

Copyright Flowfield. All rights reserved.

## Migration to 0.2.0

The plugin ID is now `cleves-flowfield` and the marketplace is `flowfield-cleves`.
Add marketplace `flowfieldai/cleves-flowfield-plugin`, install **Cleves Flowfield**,
and reconnect with your authorized Google account. Disable the previous Cleves
plugin after confirming the new connection works, to avoid duplicate tools.
An identifier rename is not guaranteed to upgrade an existing installation in
place. No user permissions or backend API identifiers change in this release.
