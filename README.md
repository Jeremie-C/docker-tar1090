# docker-tar1090

![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/jeremiec82/tar1090?style=plastic)
![Docker Pulls](https://img.shields.io/docker/pulls/jeremiec82/tar1090?style=plastic)
[![Deploy to Docker Hub](https://github.com/Jeremie-C/docker-tar1090/actions/workflows/deploy.yml/badge.svg)](https://github.com/Jeremie-C/docker-tar1090/actions/workflows/deploy.yml)
[![Check Code](https://github.com/Jeremie-C/docker-tar1090/actions/workflows/check_code.yml/badge.svg)](https://github.com/Jeremie-C/docker-tar1090/actions/workflows/check_code.yml)
[![Docker Build](https://github.com/Jeremie-C/docker-tar1090/actions/workflows/test_build.yml/badge.svg)](https://github.com/Jeremie-C/docker-tar1090/actions/workflows/test_build.yml)

Tar1090, Timelapse1090 and Graph1090 running in a docker container.

This container is intended to be used whith my readsb repository.

## Ports

|  Port  | Detail |
| ------ | ------ |
| 80/tcp | Web UI port you can access via a web browser. |

## Environment Variables

### Container Options

| Variable | Description | Default |
| -------- | ----------- | ------- |
| `UPDATE_TAR` | At startup update tar1090 and tar1090db to the latest version | `true` |
| `UPDATE_TIME` | At startup update timelapse1090 to the latest version | `true` |
| `UPDATE_GRAPH` | At startup update graphs1090 to the latest version | `true` |
| `TZ` | Optional. Local timezone in ["TZ database name" format](<https://en.wikipedia.org/wiki/List_of_tz_database_time_zones>). | `UTC` |

### Options for tar1090

| Variable | Description | Default |
| -------- | ----------- | ------- |
| `TAR_INTERVAL` | Time in seconds between snapshots in the track history | `8` |
| `TAR_HISTORY_SIZE` | How many snapshots are stored in the track history | `450` |
| `TAR_GZIP_LVL` | 1-9 are valid, lower lvl: less CPU usage, higher level: less network bandwidth used when loading the page | `3` |
| `TAR_PTRACKS` | hours of tracks that /?pTracks will show | `8` |
| `TAR_CHUNK_SIZE` |  | `20` |

### Options for timelapse1090

| Variable | Description | Default |
| -------- | ----------- | ------- |
| `TIME_INTERVAL` | snapshot interval in seconds | `10` |
| `TIME_HISTORY` | time saved in hours | `24` |
| `TIME_CHUNK_SIZE` |  | `240` |

### Options for graphs1090

| Variable | Description | Default |
| -------- | ----------- | ------- |
| `GRAPHS_FARENHEIT` | set to 1 to enable farenheit instead of celsius | `0` |
| `GRAPHS_RANGE` | set range graph to either nautical, statute, or metric | `nautical` |
| `GRAPHS_RANGE2` | set the right axis unit: (leftaxis, nautical, statute, metric) | `leftaxis` |
| `GRAPHS_SIZE` | set graph size, possible values: small, default, large, huge, custom | `default` |
| `GRAPHS_ALL_LARGE` | make the small graphs as large as the big ones | `no` |
| `GRAPHS_FONT_SIZE` | font size (relative to graph size) | `10.0` |
| `GRAPHS_MAX_MSG_LINE` | set to 1 to draw a reference line at the maximum message rate | `0` |

### tar1090 UI configuration

| Variable | Description | Default |
| -------- | ----------- | ------- |
| `TAR_TITLE` | Set the tar1090 web page title | `tar1090` |
| `TAR_MAPTYPE` | Set the tar1090 map type. Values are `osm_adsbx`, `osm`, `carto_light_all`, `carto_light_nolabels`, `gibs`, `esri` | `osm_adsbx` |
| `TAR_RANGE_COLOR` | Colour for the range outline. | `#00596b` |
| `TAR_RANGE_WIDTH` | Width for the range outline. | `1.7` |
| `TAR_RANGE_LINE` | Range outline dashing. `null` for solid line, ['L,S'] for dashed. `L` is pixel of line, `S` is pixel of space | `null` |

#### HeyWhatsThat range outline

Option to display what kind of range is even possible for the receiver location.
To get that theoretical range for a location, follow the guide.

1. Visit [http://www.heywhatsthat.com/](<http://www.heywhatsthat.com/>)
2. Click "New Panorama"
3. Set the location for your antenna precisely.
4. Enter a title / submit the request and wait for it to finish.
5. Near the top of the page, an URL for the panorama is mentioned. www.heywhatsthat.com/?view=**XXXXXXXX**
6. Replace the XXXXXX with the ID contained in your panorama URL.
7. Set the Environment Variabe to active this feature

| Variable | Description | Default |
| --------- | ----------- | ------- |
| `HWT_PID` | Your panorama ID | Unset |
| `HWT_RANGE_COLOR` | Colour for the range outline. | `#0000DD` |
| `HWT_RANGE_COLORBYALT` | Colour the range outline by altitude. | `false` |
| `HWT_RANGE_WIDTH` | Width for the range outline. | `1.7` |
| `HWT_RANGE_LINE` | Range outline dashing. `null` for solid line, ['L,S'] for dashed. `L` is pixel of line, `S` is pixel of space | `[5, 5]` |

### timelapse1090 UI configuration

| Variable | Description | Default |
| -------- | ----------- | ------- |
| `TIMELAPSE_TITLE` | Set the timelpase1090 web page title | `PiAware Skyview` |

### tar1090 & timelapse1090 common UI configuration

| Variable | Description | Default |
| -------- | ----------- | ------- |
| `TAR_NBPLANEINTITLE` | Show number of aircraft in the page title | `false` |
| `TAR_MSGRATEINTITLE` | Show number of messages per second in the page title | `false` |
| `TAR_UNITS` | Valid values are "`nautical`", "`metric`", or "`imperial`". | `nautical` |
| `TAR_ZOOMLVL` | Default zoom level | `7` |
| `TAR_SITESHOW` | Show center marker from LAT and LONG provided by Readsb | `true` |
| `TAR_SITENAME` | The tooltip of the center marker | `My Radar Site` |
| `TAR_RANGERINGS` | Show range rings. Set to `false` to disable | `true` |
| `TAR_RANGERINGSDIST` | Distances to display range rings. Accepts a comma separated list of numbers (no spaces, no quotes). | `100,150,200,250` |
| `TAR_SHOWFLAGS` | Show country flags by ICAO addresses | `true` |

## Paths & Volumes

| Path in container | Detail |
| ----------------- | ------ |
| /var/readsb | Readsb container output files & history. |
| /opt/data | Tar1090, Timelapse1090 and Graph1090 output files & history. |
