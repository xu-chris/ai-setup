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
    exit 2
  fi
fi
exit 0
