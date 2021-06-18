FROM debian:buster-slim

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
  BEAST_PORT=30005 \
  UPDATE_TAR="true" \
  UPDATE_TIME="true" \
  UPDATE_GRAPH="true"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY rootfs/ /

RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
  # Required always
  net-tools jq bc rrdtool collectd-core \
  ca-certificates wget git libpython2.7 \
  nginx-light p7zip-full && \
  # S6 OVERLAY
  chmod +x /scripts/s6-overlay.sh && \
  /scripts/s6-overlay.sh && \
  # NGINX
  rm -f /etc/nginx/nginx.conf && \
  rm -f /etc/nginx/sites-enabled/default && \
  mv -v /scripts/nginx.conf /etc/nginx/nginx.conf && \
  mv -v /scripts/tar1090 /etc/nginx/sites-enabled/tar1090 && \
  mkdir -p /srv/nginx/ && \
  mv -v /scripts/timelapse1090.conf /srv/nginx/timelapse1090.conf && \
  # Nettoyage
  rm -rf /scripts /var/lib/apt/lists/* && \
  # Healthcheck
  chmod +x /healthcheck.sh

RUN  apt-get update && \
  apt-get install -y --no-install-recommends \
  build-essential libncurses6 libncurses-dev zlib1g zlib1g-dev && \
  git clone --depth 1 -b master https://github.com/wiedehopf/tar1090-db /srv/tar1090-db && \
  git clone --depth 1 -b master https://github.com/wiedehopf/tar1090 /srv/tar1090 && \
  git clone --depth 1 -b master https://github.com/wiedehopf/timelapse1090 /srv/timelapse1090 && \
  git clone --depth 1 -b master https://github.com/wiedehopf/graphs1090 /srv/graphs1090 && \
  git clone --depth 1 -b dev https://github.com/wiedehopf/readsb /src/readsb && \
  pushd /src/readsb && \
  make RTLSDR=no BLADERF=no PLUTOSDR=no HAVE_BIASTEE=no OPTIMIZE="-O3" && \
  cp -v /src/readsb/readsb /usr/bin/readsb && \
  cp -v /src/readsb/viewadsb /usr/bin/viewadsb && \
  popd && \
  apt-get remove -y build-essential libncurses-dev zlib1g-dev && \
  apt-get autoremove -y && \
  rm -rf  /src /var/lib/apt/lists/*

ENTRYPOINT [ "/init" ]
EXPOSE 80/tcp
VOLUME ["/opt/data/"]

HEALTHCHECK --start-period=120s --interval=300s CMD /healthcheck.sh
LABEL maintainer="Jeremie-C <Jeremie-C@users.noreply.github.com>"
