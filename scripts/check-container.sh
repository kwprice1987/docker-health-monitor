#!/usr/bin/env bash
set -euo pipefail

CONTAINER="${1:-}"

if [[ -z "$CONTAINER" ]]; then
    echo "Usage: $0 <container-name>"
    exit 2
fi

if ! docker inspect "$CONTAINER" >/dev/null 2>&1; then
    echo "ERROR: Container not found or Docker unavailable: $CONTAINER"
    exit 2
fi

STATUS=$(docker inspect \
    --format '{{.State.Status}}' \
    "$CONTAINER")

HEALTH=$(docker inspect \
    --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}not-configured{{end}}' \
    "$CONTAINER")

echo "Container: $CONTAINER"
echo "State: $STATUS"
echo "Health: $HEALTH"

if [[ "$STATUS" != "running" ]]; then
    echo "CRITICAL: Container is not running"
    exit 1
fi

if [[ "$HEALTH" == "unhealthy" ]]; then
    echo "CRITICAL: Container is unhealthy"
    exit 1
fi

if [[ "$HEALTH" == "starting" ]]; then
    echo "WARNING: Health checks are still starting"
    exit 3
fi

echo "OK: Container is running"
exit 0
