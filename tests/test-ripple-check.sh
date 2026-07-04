#!/usr/bin/env bash
# Unit tests for hooks/ripple-check.sh
#
# Tests the script directly with simulated PostToolUse JSON input.
# No Claude session needed.
#
# Run: bash tests/test-ripple-check.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOOK="$SCRIPT_DIR/../plugins/shape-up/hooks/ripple-check.sh"

PASS=0
FAIL=0

run_test() {
    local name="$1"
    local input_json="$2"
    local expected_exit="$3"
    local expect_pattern="${4:-}"

    local stderr_file
    stderr_file=$(mktemp)

    local actual_exit=0
    echo "$input_json" | bash "$HOOK" 2>"$stderr_file" || actual_exit=$?

    local stderr_out
    stderr_out=$(cat "$stderr_file")
    rm -f "$stderr_file"

    if [[ "$actual_exit" -ne "$expected_exit" ]]; then
        echo "  [FAIL] $name"
        echo "    Expected exit $expected_exit, got $actual_exit"
        echo "    stderr: $stderr_out"
        FAIL=$((FAIL + 1))
        return
    fi

    if [[ -n "$expect_pattern" ]]; then
        if echo "$stderr_out" | grep -q "$expect_pattern"; then
            echo "  [PASS] $name"
            PASS=$((PASS + 1))
        else
            echo "  [FAIL] $name"
            echo "    Expected pattern in stderr: $expect_pattern"
            echo "    stderr was: $stderr_out"
            FAIL=$((FAIL + 1))
        fi
    else
        echo "  [PASS] $name"
        PASS=$((PASS + 1))
    fi
}

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# --- Fixtures ---

# shape.md with shaping: true in first 5 lines
SHAPING_FILE="$TMP/shape.md"
cat > "$SHAPING_FILE" <<'EOF'
---
shaping: true
status: shape-go
---
# My Concept
EOF

# slices.md with shaping: true
SLICES_FILE="$TMP/slices.md"
cat > "$SLICES_FILE" <<'EOF'
---
shaping: true
concept: docs/concepts/foo/shape.md
status: building
---
# Slices
EOF

# Plain md without shaping: true
PLAIN_FILE="$TMP/notes.md"
cat > "$PLAIN_FILE" <<'EOF'
---
status: draft
---
# Notes
EOF

# shaping: true present but below line 5 (should NOT trigger)
LATE_FILE="$TMP/late.md"
cat > "$LATE_FILE" <<'EOF'
---
status: draft
---

# Header

shaping: true
EOF

# Non-md file
CODE_FILE="$TMP/script.sh"
echo '#!/bin/bash' > "$CODE_FILE"

echo "=== ripple-check.sh unit tests ==="
echo ""

# --- Tests ---

echo "-- Trigger cases --"

run_test "shape.md with shaping: true triggers ripple check (exit 2)" \
    "{\"tool_input\":{\"file_path\":\"$SHAPING_FILE\"}}" \
    2 "Ripple check"

run_test "ripple message lists breadboard instruction" \
    "{\"tool_input\":{\"file_path\":\"$SHAPING_FILE\"}}" \
    2 "affordance tables"

run_test "ripple message lists requirements instruction" \
    "{\"tool_input\":{\"file_path\":\"$SHAPING_FILE\"}}" \
    2 "Fit Check"

run_test "ripple message lists slices instruction" \
    "{\"tool_input\":{\"file_path\":\"$SHAPING_FILE\"}}" \
    2 "slices.md"

run_test "slices.md with shaping: true triggers ripple check" \
    "{\"tool_input\":{\"file_path\":\"$SLICES_FILE\"}}" \
    2 "Ripple check"

echo ""
echo "-- No-trigger cases --"

run_test "plain md without shaping: true does not trigger (exit 0)" \
    "{\"tool_input\":{\"file_path\":\"$PLAIN_FILE\"}}" \
    0 ""

run_test "shaping: true after line 5 does not trigger (exit 0)" \
    "{\"tool_input\":{\"file_path\":\"$LATE_FILE\"}}" \
    0 ""

run_test "non-md file does not trigger (exit 0)" \
    "{\"tool_input\":{\"file_path\":\"$CODE_FILE\"}}" \
    0 ""

run_test "missing file path field does not trigger (exit 0)" \
    '{"tool_input":{}}' \
    0 ""

run_test "nonexistent file path does not trigger (exit 0)" \
    '{"tool_input":{"file_path":"/tmp/does-not-exist-shaping.md"}}' \
    0 ""

run_test "Edit tool input format (file_path field) works" \
    "{\"tool_input\":{\"file_path\":\"$SHAPING_FILE\",\"old_string\":\"foo\",\"new_string\":\"bar\"}}" \
    2 "Ripple check"

echo ""
echo "Results: $PASS passed, $FAIL failed"
echo ""

[[ $FAIL -eq 0 ]]
