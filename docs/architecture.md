# Architecture

## Components

| Component | Purpose | Network / storage |
| --- | --- | --- |
| iPhone / iPad | Discovers and submits AirPrint jobs | Local LAN |
| Avahi | Publishes the CUPS queue over mDNS/Bonjour | Host network for multicast DNS |
| CUPS | Accepts IPP jobs, processes the document, manages the queue | Host network; configuration in a Docker volume |
| Epson L3250 | Physically prints the document | IPP over a fixed LAN address |

## Network flow

```text
iPhone/iPad
    │  mDNS: AirPrint discovery
    ▼
Avahi on Ubuntu (Docker, host network)
    │  IPP: job to the CUPS queue
    ▼
CUPS + Epson ESC/P-R (Docker, host network)
    │  IPP: PRINTER_URI
    ▼
Epson L3250 (PRINTER_URI)
```

`network_mode: host` is used for the AirPrint services because mDNS relies on multicast UDP/5353 and must be visible to devices on the physical LAN. In this mode the container ports are the Ubuntu host's ports.

## Data and configuration

- `.env` holds local parameters and is not committed;
- `.env.example` holds safe example parameters;
- CUPS state is stored in a named Docker volume;
- image configuration and scripts live in the repository;
- no passwords, keys, or print-job backups are stored in the repository.

## Security

- AirPrint and administration are reachable only from the trusted local network;
- the service is not exposed to the internet and needs no port forwarding;
- access to the CUPS web interface is restricted by configuration;
- updates are controlled: pull/build, restart, verify with a test print.
