#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${PRINTER_NAME:-}" || -z "${PRINTER_URI:-}" ]]; then
  echo "PRINTER_NAME and PRINTER_URI must be set." >&2
  exit 1
fi

find_model() {
  local model
  if [[ -n "${PRINTER_MODEL:-}" ]]; then
    model="$PRINTER_MODEL"
  else
    model="$(lpinfo -m | awk '/EPSON L3250 Series/ { print $1; exit }')"
  fi

  if [[ -z "$model" ]]; then
    echo "No Epson L3250 ESC/P-R driver was found. Set PRINTER_MODEL to a model from 'lpinfo -m'." >&2
    exit 1
  fi

  printf '%s\n' "$model"
}

model="$(find_model)"
lpadmin -p "$PRINTER_NAME" -E -v "$PRINTER_URI" -m "$model" \
  -o printer-is-shared=true \
  -o printer-error-policy=retry-job \
  -o media=iso_a4_210x297mm
cupsenable "$PRINTER_NAME"
accept "$PRINTER_NAME"

echo "Configured CUPS queue '$PRINTER_NAME' with '$PRINTER_URI' and '$model'."
