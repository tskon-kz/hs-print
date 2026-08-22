# hs-print

Server-side AirPrint gateway for an Epson L3250.

Lets iPhone/iPad discover the printer on the local network and print over AirPrint. An Ubuntu server accepts jobs through CUPS and forwards them to the Epson L3250 over IPP.

## Status

Working: CUPS and Avahi containers, the Epson queue, and diagnostic commands. Printing from iPhone is confirmed.

## Quick start

```bash
cp .env.example .env   # fill in PRINTER_URI, LAN_SUBNET, AVAHI_INTERFACES and the names
make up
make status
```

If the host runs a firewall (UFW, etc.), open TCP/631 for the local network — see [Operations](docs/operations.md).

## Documentation

- [Architecture](docs/architecture.md)
- [Decisions and assumptions](docs/decisions.md)
- [Operations](docs/operations.md)

## Target stack

- Docker Compose on Ubuntu
- CUPS with the Epson ESC/P-R driver
- Avahi for mDNS/Bonjour and AirPrint discovery
- Epson L3250 on the local network
