#!/bin/bash
FILE=$(jq -r '.tool_input.file_path // empty')
if [[ "$FILE" == *.md && -f "$FILE" ]]; then
  if head -5 "$FILE" 2>/dev/null | grep -q '^shaping: true'; then
    cat >&2 <<'MSG'
Ripple check:
- Changed a breadboard diagram? → Update the 4 affordance tables in shape.md FIRST, then re-render Mermaid
- Changed R (requirements) in shape.md? → Update the Fit Check; update slices.md if the winning shape changes
- Changed S (shape parts) in shape.md? → Update the Fit Check
- Changed slices.md? → Update affected S#-plan.md files
- Changed an S#-plan.md? → Update the slice summary in slices.md if scope changed
MSG

    # Advisory breadboard check. If this file carries affordance tables, surface
    # any referential ERRORs (dangling refs, dead affordances, orphan stores).
    # Advisory only: it never adds a halt beyond the ripple reminder, and it
    # leaves WARNs for the Step-4 gate — the edit stands either way. Errors are
    # expected transiently while the tables are being built row by row; treat
    # them as a nudge, not a stop.
    if grep -qE '^\|[[:space:]]*~?[UNPS][0-9]+[[:space:]]*\|' "$FILE"; then
      HOOK_DIR=$(cd "$(dirname "$0")" && pwd)
      VALIDATOR="$(dirname "$HOOK_DIR")/skills/breadboarding/scripts/check-tables.sh"
      if [[ -x "$VALIDATOR" ]]; then
        OUT=$("$VALIDATOR" "$FILE" 2>/dev/null) || true
        ERRLINES=$(printf '%s\n' "$OUT" | grep '^ERROR' || true)
        if [[ -n "$ERRLINES" ]]; then
          {
            echo
            echo "Breadboard table check (scripts/check-tables.sh) — fix before Step 5:"
            printf '%s\n' "$ERRLINES"
          } >&2
        fi
      fi
    fi

    exit 2
  fi
fi
exit 0
