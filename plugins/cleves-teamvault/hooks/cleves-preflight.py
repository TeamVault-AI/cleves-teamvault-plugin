#!/usr/bin/env python3
"""Claude Code hooks for the Cleves TeamVault analytical preflight protocol."""

from __future__ import annotations

import json
import re
import sys
from typing import Any


ANALYTICS_TOOL_SUFFIX = "__cleves_teamvault_analytics"
SUPPORTED_OPERATIONS = {
    "preflight",
    "schema",
    "describe",
    "query",
    "saved_query",
    "status",
}
RECEIPT_PATTERN = re.compile(r"^[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+$")
PREFLIGHT_INSTRUCTION = (
    "Cleves warehouse analysis is release-gated. First call the Cleves TeamVault "
    "analytics tool with operation=preflight and the exact stable user-facing goal. "
    "Treat its live instructions and catalogs as authoritative. Then retry with the "
    "returned release_id and preflight_receipt unchanged."
)


def emit(payload: dict[str, Any]) -> None:
    sys.stdout.write(json.dumps(payload, separators=(",", ":")))


def deny(reason: str) -> None:
    emit({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason,
            "additionalContext": PREFLIGHT_INSTRUCTION,
        }
    })


def session_start() -> None:
    emit({
        "hookSpecificOutput": {
            "hookEventName": "SessionStart",
            "additionalContext": (
                "The Cleves TeamVault plugin is connected to a live graph and governed "
                "warehouse. Use graph tools for entities, documents, relationships, "
                "definitions, mappings, and reviewed findings. For every numerical "
                f"analysis, {PREFLIGHT_INSTRUCTION} Do not rely on relation names, saved "
                "queries, coverage, mappings, or quality state copied into a local skill."
            ),
        }
    })


def pre_tool_use() -> None:
    try:
        event = json.load(sys.stdin)
    except Exception:
        deny(f"The Cleves preflight gate could not parse the analytics call. {PREFLIGHT_INSTRUCTION}")
        return

    if not isinstance(event, dict):
        deny(f"The Cleves preflight gate received invalid analytics input. {PREFLIGHT_INSTRUCTION}")
        return

    tool_name = str(event.get("tool_name") or "")
    if not tool_name.endswith(ANALYTICS_TOOL_SUFFIX):
        emit({})
        return

    tool_input = event.get("tool_input")
    if not isinstance(tool_input, dict):
        deny(f"The Cleves analytics tool input must be an object. {PREFLIGHT_INSTRUCTION}")
        return

    operation = str(tool_input.get("operation") or "").strip().lower()
    goal = " ".join(str(tool_input.get("goal") or "").split())
    if len(goal) < 8:
        deny(
            "Every Cleves analytics call requires one stable user-facing goal of at least "
            f"eight characters. {PREFLIGHT_INSTRUCTION}"
        )
        return

    if operation not in SUPPORTED_OPERATIONS:
        deny(f"Unknown Cleves analytics operation {operation or '(missing)'!r}. {PREFLIGHT_INSTRUCTION}")
        return

    if operation == "preflight":
        emit({})
        return

    release_id = str(tool_input.get("release_id") or "").strip()
    receipt = str(tool_input.get("preflight_receipt") or "").strip()
    if not release_id or release_id.startswith("<"):
        deny(f"This {operation} call is missing the release_id returned by preflight. {PREFLIGHT_INSTRUCTION}")
        return
    if len(receipt) < 80 or not RECEIPT_PATTERN.fullmatch(receipt):
        deny(f"This {operation} call is missing a valid-shaped preflight_receipt. {PREFLIGHT_INSTRUCTION}")
        return

    # The hook proves that Claude followed the required sequence structurally.
    # TeamVault performs the authoritative HMAC, caller, goal, release, and
    # expiration checks before SQL or a saved query can reach DuckDB.
    emit({})


def main() -> None:
    mode = sys.argv[1] if len(sys.argv) > 1 else ""
    if mode == "session-start":
        session_start()
        return
    if mode == "pre-tool-use":
        pre_tool_use()
        return
    emit({})


if __name__ == "__main__":
    main()
