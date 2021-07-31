# docker-tar1090

Tar1090, Timelapse1090 and Graph1090 running in a docker container.

This container is intended to be used whith my readsb repository.

## Ports

|  Port  | Detail |
| 80/tcp | Web UI port you can access via a web browser. |

## Environment Variables

### Container Options

| Variable | Description | Default |
|----------|-------------|---------|
| `UPDATE_TAR` | At startup update tar1090 and tar1090db to the latest version | `true` |
| `UPDATE_TIME` | At startup update timelapse1090 to the latest version | `true` |
| `UPDATE_GRAPH` | At startup update graphs1090 to the latest version | `true` |
| `TZ` | Optional. Local timezone in ["TZ database name" format](<https://en.wikipedia.org/wiki/List_of_tz_database_time_zones>). | `UTC` |

### Options for tar1090

| Variable | Description | Default |
|----------|-------------|---------|
| `TAR_INTERVAL` | Time in seconds between snapshots in the track history | `8` |
| `TAR_HISTORY_SIZE` | How many snapshots are stored in the track history | `450` |
| `TAR_GZIP_LVL` | 1-9 are valid, lower lvl: less CPU usage, higher level: less network bandwidth used when loading the page | `3` |
| `TAR_PTRACKS` | hours of tracks that /?pTracks will show | `8` |
| `TAR_CHUNK_SIZE` |  | `20` |

### Options for timelapse1090

| Variable | Description | Default |
|----------|-------------|---------|
| `TIME_INTERVAL` | snapshot interval in seconds | `10` |
| `TIME_HISTORY` | time saved in hours | `24` |
| `TIME_CHUNK_SIZE` |  | `240` |

### Options for graphs1090

| Variable | Description | Default |
|----------|-------------|---------|
| `GRAPHS_FARENHEIT` | set to 1 to enable farenheit instead of celsius | `0` |
| `GRAPHS_RANGE` | set range graph to either nautical, statute, or metric | `nautical` |
| `GRAPHS_RANGE2` | set the right axis unit: (leftaxis, nautical, statute, metric) | `leftaxis` |
| `GRAPHS_SIZE` | set graph size, possible values: small, default, large, huge, custom | `default` |
| `GRAPHS_ALL_LARGE` | make the small graphs as large as the big ones | `no` |
| `GRAPHS_FONT_SIZE` | font size (relative to graph size) | `10.0` |
| `GRAPHS_MAX_MSG_LINE` | set to 1 to draw a reference line at the maximum message rate | `0` |

### tar1090 UI configuration

|  Variable  | Description | Default |
|----------|-------------|---------|
| `TAR_TITLE` | Set the tar1090 web page title | `tar1090` |
| `TAR_NBPLANEINTITLE` | Show number of aircraft in the page title | `false` |
| `TAR_MSGRATEINTITLE` | Show number of messages per second in the page title | `false` |
| `TAR_UNITS` | Valid values are "`nautical`", "`metric`", or "`imperial`". | `nautical` |
| `` |  | `` |
| `` |  | `` |
| `` |  | `` |
| `` |  | `` |
| `` |  | `` |
| `` |  | `` |


## Paths & Volumes

| Path in container | Detail |
| /var/readsb | Readsb container output files & history. |
| /opt/data | Tar1090, Timelapse1090 and Graph1090 output files & history. |
