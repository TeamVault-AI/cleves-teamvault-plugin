---
name: using-cleves-flowfield
description: Search or read Cleves information through the authenticated Cleves Flowfield connector. Use whenever an answer depends on Cleves-owned documents, messages, people, products, campaigns, sales, advertising, decisions, metrics, evidence, or other ingested company knowledge.
---

# Use Cleves Flowfield

Use the installed `cleves-flowfield` connector whenever the answer depends on
Cleves information. Verify current evidence through the connector instead of
relying on general knowledge, memory, an earlier conversation, or a dashboard
screenshot.

The connector intentionally exposes three read-only operations:

- `hybrid_search` finds relevant ACL-filtered evidence across the Cleves brain.
- `read_document` reads a specific result using the document identifier or
  locator returned by search.

- the connector's advertised analytics tool answers governed numerical questions using the
  current warehouse. Start with `operation: preflight` and a stable `goal`;
  carry its `release_id` and `preflight_receipt` into query/saved_query calls.
  Prefer the returned saved-query catalog, inspect schemas as needed, and use
  coverage paging when detail is omitted. Keep one release per comparison.
  Distinguish retail-week calendars, missing rows, partial periods, derived
  dollars and causal claims. Do not aggregate only a truncated result set.

Do not expect legacy graph, grep, timeline, guide, or traversal tools.

## Retrieval workflow

1. Translate the request into the smallest useful search query while
   preserving distinctive names, products, identifiers, dates, and phrases.
2. Call `hybrid_search`. Search independent subquestions separately.
3. Use `read_document` for the most relevant results when exact context,
   provenance, or disambiguation is needed.
4. If evidence is thin, refine the query using concrete terms found in the
   first results. One empty search is not proof that no evidence exists.
5. Answer the business question first. Distinguish evidence from synthesis and
   cite the returned sources, dates, and locators when material.

## Access boundary

Flowfield resolves the signed-in Cleves user and enforces source permissions on
the server. Never ask for a bearer token, password, or shared credential. The
connector cannot edit, delete, send, approve, or mutate Cleves source data.
