#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
set -a
# .env is local, user-maintained configuration; it is intentionally not tracked.
source .env
set +a

docker compose --env-file .env -f compose.yaml exec cups \
  lp -d "$PRINTER_NAME" /usr/share/cups/data/testprint
