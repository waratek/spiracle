#!/bin/sh
# run.sh — Spiracle Hurl test runner
#
# Usage:
#   ./tests/hurl/run.sh smoke [host] [port]
#   ./tests/hurl/run.sh rasp  [host] [port]
#
# Arguments:
#   suite   — "smoke" or "rasp"
#   host    — hostname/IP of Spiracle (default: localhost)
#   port    — TCP port          (default: 8080)
#
# Environment:
#   BLOCK_STATUS — expected RASP block code (default: 550)
#                  only used by the "rasp" suite
#
# Requirements:
#   hurl v5+ at ~/.local/bin/hurl or on PATH

set -eu

SUITE="${1:-smoke}"
HOST="${2:-localhost}"
PORT="${3:-8080}"
BLOCK_STATUS="${BLOCK_STATUS:-550}"

# Resolve hurl binary
HURL=""
if command -v hurl >/dev/null 2>&1; then
    HURL="hurl"
elif [ -x "$HOME/.local/bin/hurl" ]; then
    HURL="$HOME/.local/bin/hurl"
else
    echo "ERROR: hurl not found. Install from https://hurl.dev" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

case "$SUITE" in
    smoke)
        VARS_FILE="$SCRIPT_DIR/smoke/local.env"
        FILES="$SCRIPT_DIR/smoke/smoke.hurl"
        REPORT_DIR="${REPORT_DIR:-/tmp/spiracle-smoke-report}"
        ;;
    rasp)
        VARS_FILE="$SCRIPT_DIR/rasp/protected.env"
        FILES="$SCRIPT_DIR/rasp/mysql/*.hurl $SCRIPT_DIR/rasp/oracle/*.hurl"
        REPORT_DIR="${REPORT_DIR:-/tmp/spiracle-rasp-report}"
        ;;
    *)
        echo "ERROR: unknown suite '$SUITE'. Use 'smoke' or 'rasp'." >&2
        exit 1
        ;;
esac

mkdir -p "$REPORT_DIR"

echo "Running Spiracle $SUITE suite against http://$HOST:$PORT"
echo "Report: $REPORT_DIR/junit.xml"
echo ""

# shellcheck disable=SC2086
$HURL \
    --test \
    --variables-file "$VARS_FILE" \
    --variable host="$HOST" \
    --variable port="$PORT" \
    --variable block_status="$BLOCK_STATUS" \
    --report-junit "$REPORT_DIR/junit.xml" \
    $FILES
