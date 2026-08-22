# Repository Guidelines

## Project Structure & Module Organization

This repository contains a Docker-based AirPrint gateway for an Epson L3250. Documentation is in `docs/`:

- `docs/architecture.md` describes CUPS, Avahi, host networking, and persistent state.
- `docs/decisions.md` records the design decisions and rationale.
- `docs/operations.md` covers deployment, verification, and troubleshooting.

Implementation follows the layout: `compose.yaml`, `.env.example`, `Makefile`, `cups/`, `avahi/`, and `scripts/`. Keep component files together and operator checks in `scripts/`.

## Build, Test, and Development Commands

Keep the Makefile interface stable:

- `make up` — build and start the gateway.
- `make down` — stop the stack without deleting persistent printer state.
- `make logs` — follow container logs.
- `make status` — verify containers, CUPS queue, and printer reachability.
- `make test` — submit a controlled test print.

Use `docker compose config` to validate Compose changes before starting services. Do not introduce a second, undocumented launch path.

## Coding Style & Naming Conventions

Use two spaces for YAML, four spaces for shell blocks only when required, and LF line endings. Shell scripts must use `#!/usr/bin/env bash` and begin with `set -euo pipefail`. Name scripts with lowercase kebab case, for example `scripts/test-print.sh`; use uppercase underscore-separated names for environment variables, such as `PRINTER_URI` and `AIRPRINT_NAME`.

Keep settings configurable through `.env`; commit only `.env.example`. Never hard-code LAN addresses, credentials, or host-specific interfaces in images or tracked configuration.

## Testing Guidelines

Validate configuration parsing, then service health, then an actual print. Networking changes must verify mDNS discovery from an iPhone on the same LAN. When a host firewall is active, confirm TCP/631 reachability with `ipptool` before assuming a discovery problem.

## Commit & Pull Request Guidelines

Use concise imperative commits such as `Add CUPS container configuration` or `Document recovery procedure`. Keep each commit focused. Pull requests should state the affected component, configuration changes, validation commands and outcomes, and any required router or iPhone checks. Include redacted logs or screenshots only when they help diagnose UI or discovery behavior.

## Security & Operations

Use host networking only where required for mDNS, restrict CUPS to the trusted LAN, and never expose it to the internet. Preserve Docker volumes during updates and test printing after driver upgrades.
