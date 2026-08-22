# Operations

## First run on Ubuntu

1. Install Docker Engine with the Docker Compose plugin.
2. Make sure no CUPS or Avahi is running on the host: they conflict on TCP/631 and mDNS UDP/5353.
3. Create the local configuration: `cp .env.example .env`.
4. Set `PRINTER_URI`, `LAN_SUBNET`, and the printer names in `.env`. Reserve the printer IP in the router's DHCP.
5. Run `make up`, then `make status`.

`network_mode: host` is required for Bonjour discovery. Run the stack on Linux; Docker Desktop on macOS/Windows does not reproduce the target Ubuntu host's network model.

### Firewall (required)

If the host runs UFW with a default `deny incoming` policy, mDNS (multicast) passes but TCP/631 does not. The printer then **appears** in the AirPrint list, but iOS cannot open an IPP session and **hides** it. Open the port for the local network:

```bash
sudo ufw allow from <LAN_SUBNET> to any port 631 proto tcp
# and, if needed, mDNS explicitly:
sudo ufw allow from <LAN_SUBNET> to any port 5353 proto udp
```

Verify from another host (Mac/Linux with CUPS): `ipptool -tv ipp://<server-ip>:631/printers/<PRINTER_NAME> get-printer-attributes.test` must return `successful-ok`.

If the host has several interfaces on the same subnet (e.g. wired + Wi-Fi), set only the primary one in `AVAHI_INTERFACES` (e.g. `enp2s0`) so `<hostname>.local` does not resolve to multiple addresses.

## Verification and test print

Check the queue: `make status`. If it shows as available, submit the built-in CUPS test page: `make test`.

On an iPhone in the same LAN, open a PDF, choose Share → Print. The name from `AIRPRINT_NAME` should appear.

## Updates and recovery

To update images run `make down`, then `make up`; the named CUPS volumes keep the queue and jobs. After an update always run `make status` and `make test`.

To re-apply queue settings after changing `PRINTER_URI` or `PRINTER_MODEL`, run `./scripts/install-printer.sh`. The script is idempotent.

Do not expose TCP/631 to the internet and do not commit `.env`. Use `make logs` for diagnostics; redact addresses and other local data before sharing logs if they are sensitive.
