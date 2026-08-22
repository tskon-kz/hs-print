#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
set -a
source .env
set +a

docker compose --env-file .env -f compose.yaml exec cups \
  lp -d "$PRINTER_NAME" /usr/share/cups/data/testprint
