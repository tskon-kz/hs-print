FROM debian:bookworm-slim

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    cups \
    cups-client \
    cups-filters \
    gettext-base \
    printer-driver-escpr \
  && rm -rf /var/lib/apt/lists/*

COPY cupsd.conf.template /opt/hs-print/cupsd.conf.template
COPY entrypoint.sh /usr/local/bin/hs-print-cups
COPY configure-printer.sh /usr/local/bin/configure-printer

RUN chmod 0755 /usr/local/bin/hs-print-cups /usr/local/bin/configure-printer

ENTRYPOINT ["/usr/local/bin/hs-print-cups"]
