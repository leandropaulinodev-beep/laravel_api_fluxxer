#!/usr/bin/env bash
set -euo pipefail
ENV_FILE=".env"
touch "$ENV_FILE"
grep -q "^QUEUE_CONNECTION=" "$ENV_FILE" || echo "QUEUE_CONNECTION=redis" >> "$ENV_FILE"
grep -q "^REDIS_CLIENT=" "$ENV_FILE" || echo "REDIS_CLIENT=predis" >> "$ENV_FILE"
