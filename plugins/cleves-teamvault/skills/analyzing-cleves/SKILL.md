---
name: analyzing-cleves
description: Search and analyze Cleves business information through the authenticated Cleves TeamVault MCP. Use for questions about Cleves stores, products, campaigns, people, documents, Walmart or Amazon sales, Amazon or Meta advertising, field activity, mappings, source coverage, data quality, or release-backed findings.
---

# Analyze Cleves through TeamVault

Use the plugin-provided `cleves-teamvault` MCP server. Its Claude Code analytics
tool is
`mcp__plugin_cleves-teamvault_cleves-teamvault__cleves_teamvault_analytics`.

Use graph search, read, traverse, timeline, and source tools for entities,
documents, relationships, definitions, mappings, decisions, and reviewed
findings. Use the analytics tool for numerical warehouse questions. Do not use
graph summaries as substitute metric facts, and do not infer semantic or causal
relationships from SQL alone.

## Required analytical sequence

1. Set one stable user-facing `goal` and reuse it exactly for the request.
2. Before any other analytics operation, call `operation=preflight`.
3. Treat the returned server instructions, immutable release, relation catalog,
   reviewed saved-query catalog, source coverage, mappings, and quality state as
   authoritative. Never use a static warehouse schema or saved-query list.
4. Prefer a reviewed saved query whose live description fits the question.
   Otherwise use the live relation catalog and `describe` before writing bounded
   read-only SQL.
5. Pass the returned `release_id` and `preflight_receipt` unchanged to every
   subsequent analytics call. Preserve the same `goal`.
6. Apply each result's `analysis_context` before interpreting rows. Fail closed
   if it is missing, blocked, or pinned to a different release.

Start like this:

```json
{
  "operation": "preflight",
  "goal": "Answer the user's Cleves performance question using current governed data"
}
```

Then use the exact values returned by the server:

```json
{
  "operation": "saved_query",
  "saved_query_id": "<ID selected from the live preflight catalog>",
  "params": {},
  "release_id": "<exact release_id from preflight>",
  "preflight_receipt": "<exact receipt from preflight>",
  "goal": "Answer the user's Cleves performance question using current governed data"
}
```

For custom SQL, issue one bounded `SELECT` or `WITH ... SELECT` against only
relations returned by the live catalog. Use parameters, explicit date filters,
needed columns, aggregation, and a small result limit. Never attempt writes,
DDL, `COPY`, `ATTACH`, extensions, multiple statements, external paths, or raw
fact-table pagination.

An empty relation proves only that the selected release has no rows at that
relation's declared grain. Check the live catalog and source coverage for other
governed grains before saying data is unavailable.

Report the business answer first. Include the release and interval, source and
grain, metric authority, and only the coverage, mapping, currency,
non-additivity, causal, or quality caveats that affect the answer. Label derived
calculations and co-observed associations; never upgrade either into a reported
fact or causal claim.

If the hook or server rejects a call, rerun preflight with the same stable goal
and retry with the new release and receipt. Never bypass the plugin, hosted MCP,
OAuth boundary, hook, or private query service.
