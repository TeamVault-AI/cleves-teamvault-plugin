---
name: using-cleves-teamvault
description: Search or read Cleves information through the authenticated Cleves Flowfield connector. Use whenever an answer depends on Cleves-owned documents, messages, people, products, campaigns, sales, advertising, decisions, metrics, evidence, or other ingested company knowledge.
---

# Use Cleves Flowfield

Use the installed `cleves-teamvault` connector whenever the answer depends on
Cleves information. Verify current evidence through the connector instead of
relying on general knowledge, memory, an earlier conversation, or a dashboard
screenshot.

The connector intentionally exposes exactly two read-only operations:

- `hybrid_search` finds relevant ACL-filtered evidence across the Cleves brain.
- `read_document` reads a specific result using the document identifier or
  locator returned by search.

Do not expect or request legacy graph, analytics, grep, timeline, preflight,
guide, or traversal tools from this connector. Structured business facts are
projected into governed searchable evidence by the server.

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
