---
name: using-cleves-teamvault
description: Decide when to use the Cleves TeamVault connector and route the request correctly. Use whenever a user asks for Cleves-specific facts, documents, entities, store/product/campaign mappings, field activity, sales, advertising, warehouse metrics, source coverage, data quality, or evidence-backed findings.
---

# Use Cleves TeamVault

Use the installed `cleves-teamvault` connector proactively when the answer
depends on Cleves-owned information. Do not answer from general knowledge,
memory, a prior chat result, or a dashboard screenshot when the connector can
verify the current governed source.

## Route the request

- Use graph tools for entities, relationships, documents, decisions,
  definitions, mappings, field visits, source evidence, and promoted findings.
- Use `cleves_teamvault_analytics` for quantitative questions: Walmart or
  Amazon sales, Meta or Amazon advertising, trends, comparisons, coverage, or
  metric definitions.
- For a question spanning both, obtain the warehouse result first and use graph
  evidence only for the relevant interpretation or mapping.

## Analytical guardrails

Before any analytics call, run the connector's live `preflight` operation and
follow its returned instructions. Keep the same goal, release ID, and receipt
for every subsequent call. Prefer a reviewed saved query; otherwise inspect the
live relation catalog and use one bounded read-only query.

State source, interval, grain, and material coverage or mapping caveats in the
answer. Do not claim attribution or causality from co-observed data, and do not
invent missing revenue, mappings, or coverage.

## Do not use it for

Generic strategy, writing, or how-to questions that do not need Cleves facts.
If a request would change Cleves data, ask for explicit approval and use only a
supported write workflow; never attempt a warehouse or graph write through an
analytical query.
