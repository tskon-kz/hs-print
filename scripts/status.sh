#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
set -a
source .env
set +a
compose=(docker compose --env-file .env -f compose.yaml)

"${compose[@]}" ps
"${compose[@]}" exec cups lpstat -r
"${compose[@]}" exec cups lpstat -p "$PRINTER_NAME"
