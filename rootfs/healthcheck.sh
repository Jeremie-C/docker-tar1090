#!/usr/bin/env bash
set -e
EXITCODE=0

if [ -f "/var/readsb/readsb/aircraft.json" ]; then
  # get latest timestamp of readsb json update
  TIMESTAMP_LAST_READSB_UPDATE=$(jq '.now' < /var/readsb/readsb/aircraft.json)
  # get current timestamp
  TIMESTAMP_NOW=$(date +"%s.%N")
  # makse sure readsb has updated json in past 60 seconds
  TIMEDELTA=$(echo "$TIMESTAMP_NOW - $TIMESTAMP_LAST_READSB_UPDATE" | bc)
  if [ "$(echo "$TIMEDELTA" \< 60 | bc)" -ne 1 ]; then
      echo "readsb last updated: ${TIMESTAMP_LAST_READSB_UPDATE}, now: ${TIMESTAMP_NOW}, delta: ${TIMEDELTA}. UNHEALTHY"
      EXITCODE=1
  else
      echo "readsb last updated: ${TIMESTAMP_LAST_READSB_UPDATE}, now: ${TIMESTAMP_NOW}, delta: ${TIMEDELTA}. HEALTHY"
  fi
  # get number of aircraft
  NUM_AIRCRAFT=$(jq '.aircraft | length' < /var/readsb/readsb/aircraft.json)
  if [ "$NUM_AIRCRAFT" -lt 1 ]; then
      echo "total aircraft: $NUM_AIRCRAFT. UNHEALTHY"
      EXITCODE=1
  else
      echo "total aircraft: $NUM_AIRCRAFT. HEALTHY"
  fi
else
  echo "ERROR: Cannot find /var/readsb/readsb/aircraft.json !"
  EXITCODE=1
fi

# shellcheck disable=SC2126
NGINX_DEATHS=$(s6-svdt /run/s6/services/nginx | grep -v "exitcode 0" | wc -l)
if [ "$HTTPD_DEATHS" -ge 1 ]; then
    echo "nginx deaths: $NGINX_DEATHS. UNHEALTHY"
    EXITCODE=1
else
    echo "nginx deaths: $NGINX_DEATHS. HEALTHY"
fi
s6-svdt-clear /run/s6/services/nginx

# shellcheck disable=SC2126
TAR_DEATHS=$(s6-svdt /run/s6/services/tar1090 | grep -v "exitcode 0" | wc -l)
if [ "$TAR_DEATHS" -ge 1 ]; then
    echo "tar1090 deaths: $TAR_DEATHS. UNHEALTHY"
    EXITCODE=1
else
    echo "tar1090 deaths: $TAR_DEATHS. HEALTHY"
fi
s6-svdt-clear /run/s6/services/tar1090

# shellcheck disable=SC2126
TIME_DEATHS=$(s6-svdt /run/s6/services/timelapse1090 | grep -v "exitcode 0" | wc -l)
if [ "$TIME_DEATHS" -ge 1 ]; then
    echo "timelapse1090 deaths: $TIME_DEATHS. UNHEALTHY"
    EXITCODE=1
else
    echo "timelapse1090 deaths: $TIME_DEATHS. HEALTHY"
fi
s6-svdt-clear /run/s6/services/timelapse1090

# shellcheck disable=SC2126
GRAPHS_DEATHS=$(s6-svdt /run/s6/services/graphs1090 | grep -v "exitcode 0" | wc -l)
if [ "$GRAPHS_DEATHS" -ge 1 ]; then
    echo "graphs1090 deaths: $GRAPHS_DEATHS. UNHEALTHY"
    EXITCODE=1
else
    echo "graphs1090 deaths: $GRAPHS_DEATHS. HEALTHY"
fi
s6-svdt-clear /run/s6/services/graphs1090

# shellcheck disable=SC2126
COLLECTD_DEATHS=$(s6-svdt /run/s6/services/collectd | grep -v "exitcode 0" | wc -l)
if [ "$COLLECTD_DEATHS" -ge 1 ]; then
    echo "collectd deaths: $COLLECTD_DEATHS. UNHEALTHY"
    EXITCODE=1
else
    echo "collectd deaths: $COLLECTD_DEATHS. HEALTHY"
fi
s6-svdt-clear /run/s6/services/collectd

exit $EXITCODE
