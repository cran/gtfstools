## ----include = FALSE----------------------------------------------------------
# the queries in this vignette use {dplyr}, which gtfstools only suggests
has_dplyr <- requireNamespace("dplyr", quietly = TRUE)

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = has_dplyr
)

Sys.setenv(OMP_THREAD_LIMIT = 2)
data.table::setDTthreads(2)

library(gtfstools)

## ----message = FALSE----------------------------------------------------------
library(gtfstools)
library(dplyr)

## -----------------------------------------------------------------------------
path <- system.file("extdata/poa_gtfs.zip", package = "gtfstools")
gtfs <- read_gtfs(path)

get_route_frequency(
  gtfs,
  route_id = "T2",
  from = "07:00:00",
  to = "09:00:00"
)

## -----------------------------------------------------------------------------
new_gtfs <- set_route_frequency(
  gtfs,
  route_id = "T2",
  headway = 10,
  from = "07:00:00",
  to = "09:00:00"
)

get_route_frequency(
  new_gtfs,
  route_id = "T2",
  from = "07:00:00",
  to = "09:00:00"
)

new_gtfs$frequencies

## -----------------------------------------------------------------------------
path <- system.file("extdata/spo_gtfs.zip", package = "gtfstools")
spo_gtfs <- read_gtfs(path)

get_trip_speed(spo_gtfs, trip_id = "CPTM L07-0")

# 'unit' argument defaults to "km/h"
new_speed_gtfs <- set_trip_speed(spo_gtfs, trip_id = "CPTM L07-0", speed = 50)

get_trip_speed(new_speed_gtfs, trip_id = "CPTM L07-0")

new_speed_gtfs$stop_times |>
  filter(trip_id == "CPTM L07-0") |>
  select(stop_id, stop_sequence, arrival_time, departure_time)

## -----------------------------------------------------------------------------
converted_gtfs <- stop_times_to_frequencies(gtfs)

nrow(gtfs$trips)
nrow(converted_gtfs$trips)

# frequencies of route T2 on weekdays, from 6 to 10 am
converted_gtfs$frequencies |>
  filter(
    startsWith(trip_id, "T2-1@1#"),
    start_time >= "06:00:00",
    start_time < "10:00:00"
  )

# the number of departures of route T2 is kept
get_route_frequency(
  converted_gtfs,
  route_id = "T2",
  from = "07:00:00",
  to = "09:00:00"
)

## -----------------------------------------------------------------------------
trip <- "T2-1@1#520"

gtfs$stop_times |> 
  filter(trip_id == trip) |> 
  select(stop_id, arrival_time, departure_time) |> 
  head()


## -----------------------------------------------------------------------------
interpolated_gtfs <- interpolate_stop_times(gtfs, trip_id = trip)

interpolated_gtfs$stop_times |> 
  filter(trip_id == trip) |> 
  select(stop_id, arrival_time, departure_time) |> 
  head()


## -----------------------------------------------------------------------------
fixed_gtfs <- fix_gtfs(
  gtfs, 
  max_speed = 25, 
  min_dwell_time = 20
  )

