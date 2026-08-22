#!/usr/bin/env bash
set -euo pipefail

: "${AIRPRINT_NAME:?AIRPRINT_NAME is required}"
: "${PRINTER_NAME:?PRINTER_NAME is required}"
: "${PRINTER_PRODUCT:?PRINTER_PRODUCT is required}"

mkdir -p /etc/avahi/services
envsubst '${AIRPRINT_NAME} ${PRINTER_NAME} ${PRINTER_PRODUCT}' \
  < /opt/hs-print/airprint.service.template \
  > /etc/avahi/services/airprint.service
cp /opt/hs-print/avahi-daemon.conf.template /etc/avahi/avahi-daemon.conf

# Restrict advertising to the physical LAN interface(s) so iOS does not receive
# unreachable docker bridge A-records for home-server.local.
if [[ -n "${AVAHI_INTERFACES:-}" ]]; then
  sed -i "/^\[server\]/a allow-interfaces=${AVAHI_INTERFACES}" /etc/avahi/avahi-daemon.conf
fi

exec avahi-daemon --no-chroot --debug
