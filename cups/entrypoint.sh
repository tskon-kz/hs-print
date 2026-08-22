#!/usr/bin/env bash
set -euo pipefail

: "${LAN_SUBNET:?LAN_SUBNET is required}"
: "${PRINTER_NAME:?PRINTER_NAME is required}"
: "${PRINTER_URI:?PRINTER_URI is required}"

mkdir -p /etc/cups /run/cups /var/log/cups /var/spool/cups
envsubst '${LAN_SUBNET}' < /opt/hs-print/cupsd.conf.template > /etc/cups/cupsd.conf

cleanup() {
  kill -TERM "$cups_pid" 2>/dev/null || true
  wait "$cups_pid" 2>/dev/null || true
}

trap cleanup TERM INT
cupsd -f &
cups_pid=$!

for _ in $(seq 1 20); do
  if lpstat -r 2>/dev/null | grep -q 'scheduler is running'; then
    break
  fi
  sleep 1
done

if ! lpstat -r 2>/dev/null | grep -q 'scheduler is running'; then
  echo "CUPS did not start." >&2
  exit 1
fi

/usr/local/bin/configure-printer
wait "$cups_pid"
