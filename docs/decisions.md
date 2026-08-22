# Decisions and assumptions

## Decisions

1. Use Docker Compose instead of installing CUPS/Avahi directly on Ubuntu: the configuration is portable, and updates and backups are easier to reproduce.
2. Use separate CUPS and Avahi containers: the services have distinct responsibilities and independent logs/update cycles.
3. Use host networking: it is the most reliable mode for AirPrint/mDNS on a single local network.
4. The printer address and URI are set via `.env`, so changing the printer or IP needs no image rebuild.
5. A single queue is supported (one printer at a time); multiple printers at once are out of scope.
6. The printer model is set via `.env` (`PRINTER_URI`, `PRINTER_NAME`, `PRINTER_MODEL`, `PRINTER_PRODUCT`). The Epson ESC/P-R driver (`printer-driver-escpr`) is installed by default; L3250 is the default, tested model. Another Epson ESC/P-R printer works by editing `.env`; a different vendor requires adding its driver to `cups/Dockerfile`.
7. Avahi runs without D-Bus (`enable-dbus=no`) and publishes a static `airprint.service` rather than relying on CUPS's own DNS-SD.
