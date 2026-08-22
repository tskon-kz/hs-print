FROM debian:bookworm-slim

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    avahi-daemon \
    gettext-base \
  && rm -rf /var/lib/apt/lists/*

COPY avahi-daemon.conf.template /opt/hs-print/avahi-daemon.conf.template
COPY services/airprint.service.template /opt/hs-print/airprint.service.template
COPY entrypoint.sh /usr/local/bin/hs-print-avahi

RUN chmod 0755 /usr/local/bin/hs-print-avahi

ENTRYPOINT ["/usr/local/bin/hs-print-avahi"]
