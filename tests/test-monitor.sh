#!/usr/bin/env bash
set -euo pipefail

CONTAINER="devops-monitor-test-$$"
MONITOR="./scripts/check-container.sh"

cleanup() {
    docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
}

trap cleanup EXIT

echo "Creating disposable test container..."

docker run -d \
    --name "$CONTAINER" \
    --restart no \
    nginx:stable >/dev/null

echo
echo "TEST 1: Running container"

if "$MONITOR" "$CONTAINER"; then
    echo "PASS: Running container detected"
else
    echo "FAIL: Running container not detected"
    exit 1
fi

echo
echo "TEST 2: Stopped container"

docker stop "$CONTAINER" >/dev/null

set +e
"$MONITOR" "$CONTAINER"
RESULT=$?
set -e

if [[ "$RESULT" -eq 1 ]]; then
    echo "PASS: Stopped container detected"
else
    echo "FAIL: Expected exit code 1, got $RESULT"
    exit 1
fi

echo
echo "TEST 3: Missing container"

docker rm "$CONTAINER" >/dev/null

set +e
"$MONITOR" "$CONTAINER"
RESULT=$?
set -e

if [[ "$RESULT" -eq 2 ]]; then
    echo "PASS: Missing container detected"
else
    echo "FAIL: Expected exit code 2, got $RESULT"
    exit 1
fi

echo
echo "ALL TESTS PASSED"
