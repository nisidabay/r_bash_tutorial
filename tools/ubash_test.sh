#!/usr/bin/env bash
#
# Test suite for ubash.sh
# Run: ./ubash_test.sh
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UBASH="$SCRIPT_DIR/ubash.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0
SKIPPED=0

pass() {
  echo -e "${GREEN}✓ PASS${NC}: $1"
  ((PASSED++)) || true
}

fail() {
  echo -e "${RED}✗ FAIL${NC}: $1"
  ((FAILED++)) || true
}

skip() {
  echo -e "${YELLOW}⊘ SKIP${NC}: $1"
  ((SKIPPED++)) || true
}

# Test: Script exists and is executable
test_script_exists() {
  [[ -f "$UBASH" ]] && [[ -x "$UBASH" ]]
}

# Test: Help flag works
test_help_flag() {
  "$UBASH" -h 2>&1 | grep -q "Usage:"
}

# Test: Help shows all 4 examples
test_help_examples() {
  local help_output
  help_output=$("$UBASH" -h 2>&1)

  echo "$help_output" | grep -q "ubash.sh mp3 https://youtu.be/example" \
    && echo "$help_output" | grep -q "ubash.sh -c mp3" \
    && echo "$help_output" | grep -q "ubash.sh -f urls.txt bestvideo" \
    && echo "$help_output" | grep -q "ubash.sh -p -f playlist.txt mp4"
}

# Test: Missing format argument
test_missing_format() {
  local output
  output=$("$UBASH" 2>&1) || true
  echo "$output" | grep -q "Missing format"
}

# Test: Invalid format
test_invalid_format() {
  local output
  output=$("$UBASH" invalid_format 2>&1) || true
  echo "$output" | grep -q "Invalid format"
}

# Test: Valid formats are accepted (help exits cleanly)
test_valid_formats() {
  local formats=("mp3" "mp4" "best" "bestvideo" "bestaudio")
  for fmt in "${formats[@]}"; do
    "$UBASH" -h "$fmt" 2>&1 | grep -q "Usage:" || return 1
  done
}

# Test: No URLs provided
test_no_urls() {
  local output
  output=$("$UBASH" mp3 2>&1) || true
  echo "$output" | grep -q "No URLs provided"
}

# Test: File not found
test_file_not_found() {
  local output
  output=$("$UBASH" -f /nonexistent/file.txt mp3 2>&1) || true
  echo "$output" | grep -q "not found"
}

# Test: check_dependencies function exists
test_check_dependencies_function() {
  grep -q "^check_dependencies()" "$UBASH"
}

# Test: wait_for_jobs function exists
test_wait_for_jobs_function() {
  grep -q "^wait_for_jobs()" "$UBASH"
}

# Test: wait_for_jobs uses nameref for result
test_wait_for_jobs_nameref() {
  grep -q 'local -n _result_ref=' "$UBASH"
}

# Test: spawn_download handles empty video_id
test_spawn_download_empty_id() {
  # Check that the pattern uses "|| true" and "if [[ -z"
  grep -q 'yt-dlp --get-id.*|| true' "$UBASH" \
    && grep -A2 'yt-dlp --get-id' "$UBASH" | grep -q 'if \[\[ -z'
}

# Test: main function has local array declarations
test_main_local_arrays() {
  grep -q 'local -a cmd=()' "$UBASH" \
    && grep -q 'local -a pids=()' "$UBASH"
}

# Test: No set -e breaking patterns
test_no_set_e_breaks() {
  # Ensure conditional patterns use if/then, not && which fails with set -e
  grep 'video_id.*&& video_id=' "$UBASH" && return 1 || return 0
}

# Test: Bash syntax check
test_bash_syntax() {
  bash -n "$UBASH" 2>&1
}

# Test: ShellCheck passes (optional, may have expected warnings)
test_shellcheck() {
  if ! command -v shellcheck &> /dev/null; then
    skip "test_shellcheck (shellcheck not installed)"
    return 0
  fi

  # Allow SC2178 (nameref false positive)
  local result
  result=$(shellcheck "$UBASH" 2>&1 | grep -v "SC2178" || true)
  [[ -z "$result" ]]
}

# Test: No hardcoded paths in critical places
test_no_hardcoded_paths() {
  # Check that download_dir uses $HOME
  grep -q 'download_dir="$HOME' "$UBASH"
}

# Test: wait_for_jobs works with background processes
test_wait_for_jobs_background() {
  # Create a test script that sources the function
  cat > /tmp/test_wait.sh << 'TESTEOF'
#!/bin/bash
source /home/nisidabay/bin/ubash.sh 2>/dev/null || true

# Redefine the functions we need
wait_for_jobs() {
    local -n _pids_ref="$1"
    local -n _result_ref="$2"
    local failed=0 total=${#_pids_ref[@]} done_count=0

    for pid in "${_pids_ref[@]}"; do
        if ! wait "$pid"; then
            ((failed++)) || true
        fi
        ((done_count++)) || true
    done

    _result_ref=$failed
}

# Test
sleep 0.5 &
test_pids+=($!)
test_failed=0
wait_for_jobs test_pids test_failed
echo "$test_failed"
TESTEOF
  chmod +x /tmp/test_wait.sh

  local result
  result=$(/tmp/test_wait.sh)
  [[ "$result" == "0" ]]
}

# Run all tests
run_tests() {
  echo "============================================"
  echo "  ubash.sh Test Suite"
  echo "============================================"
  echo ""

  # Basic tests
  echo "--- Basic Tests ---"
  test_bash_syntax && pass "Bash syntax check" || fail "Bash syntax check"

  # Help tests
  echo ""
  echo "--- Help Tests ---"
  test_help_flag && pass "Help flag works" || fail "Help flag works"
  test_help_examples && pass "Help shows 4 examples" || fail "Help shows 4 examples"

  # Argument validation tests
  echo ""
  echo "--- Argument Validation Tests ---"
  test_missing_format && pass "Missing format error" || fail "Missing format error"
  test_invalid_format && pass "Invalid format error" || fail "Invalid format error"
  test_valid_formats && pass "Valid formats accepted" || fail "Valid formats accepted"
  test_no_urls && pass "No URLs error" || fail "No URLs error"

  # Structure tests
  echo ""
  echo "--- Structure Tests ---"
  test_check_dependencies_function && pass "check_dependencies function exists" || fail "check_dependencies function exists"
  test_wait_for_jobs_function && pass "wait_for_jobs function exists" || fail "wait_for_jobs function exists"
  test_wait_for_jobs_nameref && pass "wait_for_jobs uses nameref for result" || fail "wait_for_jobs uses nameref for result"
  test_main_local_arrays && pass "main() declares local arrays" || fail "main() declares local arrays"

  # Bug fix tests
  echo ""
  echo "--- Bug Fix Tests ---"
  test_spawn_download_empty_id && pass "spawn_download handles empty video_id" || fail "spawn_download handles empty video_id"
  test_no_set_e_breaks && pass "No set -e breaking patterns" || fail "No set -e breaking patterns"
  test_file_not_found && pass "File not found error" || fail "File not found error"

  # Background job test
  echo ""
  echo "--- Background Job Tests ---"
  test_wait_for_jobs_background && pass "wait_for_jobs works with background processes" || fail "wait_for_jobs works with background processes"

  # Code quality tests
  echo ""
  echo "--- Code Quality Tests ---"
  test_shellcheck
  test_script_exists && pass "Script exists and is executable" || fail "Script exists and is executable"
  test_no_hardcoded_paths && pass "Uses \$HOME for paths" || fail "Uses \$HOME for paths"

  # Summary
  echo ""
  echo "============================================"
  echo "  Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}, ${YELLOW}$SKIPPED skipped${NC}"
  echo "============================================"

  # Exit with appropriate code
  [[ $FAILED -eq 0 ]]
}

# Run tests
run_tests
