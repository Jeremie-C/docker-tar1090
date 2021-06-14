FROM debian:buster-slim

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
  BEAST_PORT=30005 \
  UPDATE_TAR="true" \
  UPDATE_TIMELAPSE="true"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY rootfs/ /

RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
  # Required always
  gawk libncurses6 net-tools jq bc gzip \
  ca-certificates wget git \
  # Readsb
  build-essential libncurses-dev zlib1g-dev \
  # tar1090
  nginx-light p7zip && \
  # S6 OVERLAY
  chmod +x /scripts/s6-overlay.sh && \
  /scripts/s6-overlay.sh && \
  # NGINX
  rm -f /etc/nginx/nginx.conf && \
  rm -f /etc/nginx/sites-enabled/default && \
  mv -v /scripts/nginx.conf /etc/nginx/nginx.conf && \
  mv -v /scripts/tar1090 /etc/nginx/sites-enabled/tar1090 && \
  # Nettoyage
  rm -rf /scripts /var/lib/apt/lists/* && \
  # Healthcheck
  chmod +x /healthcheck.sh

RUN git clone --depth 1 https://github.com/wiedehopf/tar1090-db /srv/tar1090-db && \
  git clone --single-branch -b master --depth 1 https://github.com/wiedehopf/tar1090 /srv/tar1090 && \
  git clone -b master https://github.com/wiedehopf/timelapse1090.git /srv/timelapse1090 && \
  mkdir -p /var/timelapse1090 && \
  git clone --branch=dev --single-branch --depth=1 https://github.com/wiedehopf/readsb.git /src/readsb && \
  pushd /src/readsb && \
  make RTLSDR=no BLADERF=no PLUTOSDR=no HAVE_BIASTEE=no OPTIMIZE="-O3" && \
  cp -v /src/readsb/readsb /usr/bin/readsb && \
  cp -v /src/readsb/viewadsb /usr/bin/viewadsb && \
  mkdir -p /var/globe_history && \
  popd && \
  apt-get remove -y build-essential libncurses-dev zlib1g-dev && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/init" ]

EXPOSE 80/tcp

HEALTHCHECK --start-period=120s --interval=300s CMD /healthcheck.sh

LABEL maintainer="Jeremie-C <Jeremie-C@users.noreply.github.com>"